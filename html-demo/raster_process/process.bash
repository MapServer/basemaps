#!/usr/bin/env bash
# 29 dec 2016:
# shell cmds to generate raster/heatmap from prices:

# plateform detection:
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

# TODO: unify conn params
DBCON="-h localhost -p 5438 -U nicolas -d osm"

if [[ "$platform" == 'osx' ]]; then
    GDALDIR=/Library/Frameworks/GDAL.framework/Versions/Current/Programs/
    PGDIR=/usr/local/pgsql-9.6/bin
elif [[ "$platform" == 'linux' ]]; then
    # gdal 2.1, custom compil....
    GDALDIR=/home/ubuntu/apps/usr/bin
    PGDIR=/usr/bin
fi

echo "script running on: $platform"

#-- TODO: test several algorithms...

# todo: struct here or from file ?
#psql $DBCON -f create_struct.sql

# exports points as shapefile
#echo "dumping pts/mask as shp"
#pgsql2shp -f ../data/points.shp -p 5438 -h localhost osm price_font
#pgsql2shp -f ../data/mask.shp -p 5438 -h localhost osm "select id, code_insee, geom from administrative_boundaries where code_insee = '77186'"

#${PGDIR}/pgsql2shp -f ../data/po≤ints.shp -p 5438 -h localhost osm samplept
#${PGDIR}/pgsql2shp -f ../data/mask.shp -p 5438 -h localhost osm "select 1::int as id, geom from samplepg"

#${PGDIR}/pgsql2shp -f ../data/points_93048.shp -p 5438 -h localhost -u nicolas -P aimelerafting osm "select * from observations_for_carto where code_insee='93048'"
#${PGDIR}/pgsql2shp -f ../data/mask_93048.shp -p 5438 -h localhost -u nicolas -P aimelerafting osm "select id, code_insee, geom from administrative_boundaries where code_insee = '93048'"
#${PGDIR}/pgsql2shp -f ../data/maskstr_93048.shp -p 5438 -h localhost -u nicolas -P aimelerafting osm "select * from mask_street_93048"
#
#${PGDIR}/pgsql2shp -f ../data/points_06088.shp -p 5438 -h localhost -u nicolas -P aimelerafting osm "select * from observations_for_carto where code_insee='06088' and is_outliers"
#${PGDIR}/pgsql2shp -f ../data/mask_06088.shp -p 5438 -h localhost -u nicolas -P aimelerafting osm "select id, code_insee, geom from administrative_boundaries where code_insee = '06088'"
#
#${PGDIR}/pgsql2shp -f ../data/points_35051.shp -p 5438 -h localhost -u nicolas -P aimelerafting osm "select * from observations_for_carto where code_insee='35051'"
#${PGDIR}/pgsql2shp -f ../data/mask_35051.shp -p 5438 -h localhost -u nicolas -P aimelerafting osm "select id, code_insee, geom from administrative_boundaries where code_insee = '35051'"


METH="invdist:power=3:smoothing=20:radius1=200:radius2=200"

echo "•••generating raster grid from points observations... $1"
${GDALDIR}/gdal_grid -l points_$2  -a "$1" \
    ../data/points_$2.shp \
    ../data/price_grid1_$2.tif

# color relief:
echo "•••producing color-relief image based on ramp..."
#gdaldem color-relief ../data/price_grid1.tif color_relief2.txt ../data/price_grid1_clr.tif
${GDALDIR}/gdaldem color-relief ../data/price_grid1_$2.tif tmpramp.txt ../data/price_grid1_clr_$2.tif

# slope ?
if [[ "$2" == 'slope' ]]; then
    echo "•••hillshade generation..."
    ${GDALDIR}/gdaldem hillshade -of PNG ../data/price_grid1_$2.tif ../data/price_grid1_hillshade_$2.png
    echo "•••slope generation..."
    ${GDALDIR}/gdaldem slope  -s 300 ../data/price_grid1_$2.tif ../data/price_grid1_slope_$2.tif
    echo "•••slopeshade generation..."
    ${GDALDIR}/gdaldem color-relief ../data/price_grid1_slope_$2.tif color_slope.txt ../data/price_grid1_slopeshade_$2.tif
fi

# line cut
echo "•••masking and smoothing image by commune pg..."
#${GDALDIR}/gdalwarp \
#    -r bilinear -s_srs EPSG:3857 -t_srs EPSG:3857 \
#   -cutline ../data/mask_$2.shp -crop_to_cutline \
#   -overwrite -dstalpha  \
#   ../data/price_grid1_clr_$2.tif \
#   ../data/price_grid1_clr_mask_$2.tif

# resample: cutline here.
rm -f ../data/price_grid1_clr_mask_$2.vrt
${GDALDIR}/gdalwarp -of VRT -tr 2.917 1.96 \
    -r bilinear -s_srs EPSG:3857 -t_srs EPSG:3857 \
   ../data/price_grid1_clr_$2.tif \
   ../data/price_grid1_clr_mask_$2.vrt

# and cutline on precise raster.
${GDALDIR}/gdalwarp -tr 2.917 1.96 \
    -s_srs EPSG:3857 -t_srs EPSG:3857 \
   -cutline ../data/maskstr_$2.shp -crop_to_cutline \
   -overwrite -dstalpha  \
   ../data/price_grid1_clr_mask_$2.vrt \
   ../data/price_grid1_clr_mask_$2.tif

#
#${GDALDIR}/gdalwarp \
#    -r bilinear -s_srs EPSG:3857 -t_srs EPSG:3857 \
#   -cutline ../data/maskstr_$2.shp -crop_to_cutline \
#   -overwrite -dstalpha  \
#   ../data/price_grid1_clr_$2.tif \
#   ../data/price_grid1_clr_mask_$2.tif

#gdalwarp -s_srs EPSG:3857 -t_srs EPSG:3857 \
#   -cutline PG:"host=localhost dbname=osm port=5438 user=nicolas" \
#   -cl administrative_boundaries -cwhere "code_insee = '77186'" -crop_to_cutline \
#   -overwrite -dstalpha  \
#   ../data/price_grid1_clr.tif \
#   ../data/price_grid1_clr_mask.tif
#
# smoothen raster:

echo "•••process raster done•••"

# TODO: order of cmds
# TODO: vrt for process
# TODO: image smoothing (Mapserver ?)
# TODO: cutline with explicit nodata value set
# slope for fun