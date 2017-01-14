#!/usr/bin/env bash
# 12 janvier 2017:
#
# script to prepprocess prices to generate jpeg images from DEM price, with correct res and smoothing
#
#
# Etapes:
#   en amont: génération du raster DEM France entiere à partir des prices corrigés, redressés.
#
#   puis génération des images correspondant aux zones admin a croper dans le raster
#
# Usage:
# ./price2img.bash dem
#    pour générer le DEM france entiere
#
# ./price2img img
#    pour générer les images des zones, masquées cropées.

# output folder for DEM
DEM_DIR="/tmp"

#GDALDIR=/Users/nicolas/bin/gdal-2.0.1/apps
#2.1
GDALDIR=/Library/Frameworks/GDAL.framework/Versions/Current/Programs/
USER=_www
DB_HOST="localhost"
DB_PORT="5438"
DB_USER="nicolas"
DB_NAME="osm"
DB_PWD="aimelerafting"

PGCON="dbname=${DB_NAME} host=${DB_HOST} port=${DB_PORT} user=${DB_USER} password=${DB_PWD}"

# TODO: choose right resolution
DEMSIZE="10240 10240"
OUTSIZE="256 256"
EXTENT=""

# query to get list of img to generate (one per zone)
QUERY="SELECT
  a.node_path,
  nlevel(a.node_path) AS nlevel,
  st_asgeojson(a.geommask, 5) as json,
  st_xmin(a.geommask::box2d)::int as xmin, st_xmax(a.geommask::box2d)::int as xmax,
  st_ymin(a.geommask::box2d)::int as ymin , st_ymax(a.geommask::box2d)::int as ymax,
  ab.ramp
FROM zone_mask a join admin_bound_values ab on a.node_path = ab.node_path
ORDER BY nlevel(a.node_path), a.node_path DESC"

if [[ "$1" == "" ]]; then
    echo "price2img: script to generate DEM/images from prices observations"
    echo ""
    echo "usage:"
    echo "  price2img.bash dem|img"
    echo "    • dem to generate the DEM from prices"
    echo "    • img to generate cropped, colored images from DEM and zones"
    exit 1
fi

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

if [[ "$platform" == 'osx' ]]; then
    #GDALDIR=/Library/Frameworks/GDAL.framework/Versions/Current/Programs/
    #GDALDIR=/Users/nicolas/bin/gdal-2.0.1/apps
    GDALDIR=/Library/Frameworks/GDAL.framework/Versions/Current/Programs
    PGDIR=/usr/local/pgsql-9.6/bin
elif [[ "$platform" == 'linux' ]]; then
    # gdal 2.1, custom compil....
    GDALDIR=/home/ubuntu/apps/usr/bin
    PGDIR=/usr/bin
fi

echo "script running on: $platform"

#######################################
## DEM generation
#######################################
if [[ "$1" == "dem" ]]; then
    echo ""
    echo "•••generating raster grid from ALL prices points..."
    ${GDALDIR}/gdal_grid -a_srs EPSG:3857 \
        --config GDAL_NUM_THREADS ALL_CPUS \
        -a invdist:power=3:smoothing=150 \
        -co COMPRESS=LZW \
        -outsize ${DEMSIZE} \
        -sql "SELECT  o.node_path,  o.point,  o.m2_price FROM observations_for_carto o where not o.is_outlier AND o.is_geocoded_to_address_precision" \
        PG:"${PGCON}" \
        ${DEM_DIR}/price_dem.tif
fi

if [[ "$1" == "img" ]]; then
    echo ""
    echo "•••generating cropped, masked images from prices DEM..."

    # Execute query, loops through the result and generates cropped img for each node_path zone:
    set -e
    set -u

    psql \
        -X \
        -h ${DB_HOST} \
        -U ${DB_USER} \
        -p ${DB_PORT} \
        -c "${QUERY}" \
        --single-transaction \
        --set AUTOCOMMIT=off \
        --set ON_ERROR_STOP=on \
        --no-align \
        -t \
        --field-separator ' ' \
        --quiet \
        -d ${DB_NAME} \
    | while read node_path nlevel json xmin xmax ymin ymax ramp ; do
        # writes json into file
        echo ${json} > /tmp/mask.json
        # detect level for custom params like grid size or commune extent:
        if [ "$nlevel" = "4" ]; then
            OUTSIZE="728 728"
            EXTENT="-txe ${xmin} ${xmax} -tye ${ymin} ${ymax}"
        else
            OUTSIZE="512 512"
            EXTENT=""
        fi

        # if file already exists, skips
        if [ -f ${DEM_DIR}/price_img_${node_path}.tif ] ; then
            echo "[WARNING] file price_img_${node_path}.tif exists, skipping"
        else
            echo "•••generating ramp for ${node_path}..."
            rm -f /tmp/tmpramp.txt
            OIFS=$IFS
            IFS=','
            RAMP=$ramp
            for x in $RAMP
            do
                echo "$x" >> /tmp/tmpramp.txt
            done
            IFS=$OIFS

            cat /tmp/tmpramp.txt

            echo "•••cropping big DEM for zone: ${node_path}..."
            #${GDALDIR}/gdal_translate -projwin ${xmin} ${ymax} ${xmax} ${ymin} \
            ${GDALDIR}/gdal_translate -projwin ${xmin} ${ymin} ${xmax} ${ymax} \
                -of VRT ${DEM_DIR}/price_dem.tif \
                ${DEM_DIR}/price_crop_${node_path}.vrt

            echo "•••producing color-relief image based on ramp for ${node_path}..."
            ${GDALDIR}/gdaldem color-relief \
                -of VRT \
                --config GDAL_NUM_THREADS ALL_CPUS \
                ${DEM_DIR}/price_crop_${node_path}.vrt \
                /tmp/tmpramp.txt \
                ${DEM_DIR}/price_clr_${node_path}.vrt

            echo "•••masking image by commune or mask for zone: ${node_path}..."
            # TODO: less precise geoms for adminbound: simplified geom in json
            ${GDALDIR}/gdalwarp -co COMPRESS=LZW \
                -cutline /tmp/mask.json \
                -crop_to_cutline \
               -overwrite -dstalpha \
               ${DEM_DIR}/price_clr_${node_path}.vrt \
               ${DEM_DIR}/price_${node_path}.tif

            # cleans generated tmp images:
            rm -f ${DEM_DIR}/price_crop_${node_path}.vrt
            rm -f ${DEM_DIR}/price_clr_${node_path}.vrt
        fi
    done
fi


