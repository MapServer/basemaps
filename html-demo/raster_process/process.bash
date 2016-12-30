#!/usr/bin/env bash
# 29 dec 2016:
# shell cmds to generate raster/heatmap from prices:

# TODO: unify conn params
DBCON="-h localhost -p 5438 -U nicolas -d osm"

#-- TODO: test several band types...
#-- TODO: test several algorithms...

# todo: struct here or from file ?
#psql $DBCON -f create_struct.sql

# exports points as shapefile
#echo "dumping pts/mask as shp"
#pgsql2shp -f ../data/points.shp -p 5438 -h localhost osm price_font
#pgsql2shp -f ../data/mask.shp -p 5438 -h localhost osm "select id, code_insee, geom from administrative_boundaries where code_insee = '77186'"

echo "generating raster grid from points observations..."
gdal_grid -l points  \
    ../data/points.shp \
    ../data/price_grid1.tif

#    PG:"dbname=osm user=nicolas host=localhost port=5438" \

# color relief:
echo "producing color-relief image based on ramp..."
gdaldem color-relief ../data/price_grid1.tif color_relief.txt ../data/price_grid1_clr.tif

# line cut
echo "masking and smoothing image by commune pg..."
gdalwarp -s_srs EPSG:3857 -t_srs EPSG:3857 \
   -cutline ../data/mask.shp -crop_to_cutline \
   -overwrite -dstalpha  \
   ../data/price_grid1_clr.tif \
   ../data/price_grid1_clr_mask.tif

#gdalwarp -s_srs EPSG:3857 -t_srs EPSG:3857 \
#   -cutline PG:"host=localhost dbname=osm port=5438 user=nicolas" \
#   -cl administrative_boundaries -cwhere "code_insee = '77186'" -crop_to_cutline \
#   -overwrite -dstalpha  \
#   ../data/price_grid1_clr.tif \
#   ../data/price_grid1_clr_mask.tif
#
# smoothen raster:

echo "process raster done"

# TODO: order of cmds
# TODO: vrt for process
# TODO: image smoothing (Mapserver ?)
# TODO: cutline with explicit nodata value set
# slope for fun