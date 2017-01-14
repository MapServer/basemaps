#!/usr/bin/env bash
# 06 janvier 2017:
#
# script to resample rasterprice
# .
#
# Etapes:
#  requete donnant les zones à générer et les node_path:.
# script grid + gdal for each node_path,

#GDALDIR=/Users/nicolas/bin/gdal-2.0.1/apps
#2.1
GDALDIR=/Library/Frameworks/GDAL.framework/Versions/Current/Programs/
USER=_www
DB_HOST="localhost"
DB_PORT="5438"
DB_USER="nicolas"
DB_NAME="osm"
OUTSIZE="256 256"
EXTENT=""

# query to get list of maps to generate
QUERY="SELECT
  a.node_path,
  nlevel(a.node_path) AS nlevel,
  st_asgeojson(ab.geomsimple_4326, 5) as json,
  st_xmin(ab.geom::box2d)::int as xmin, st_xmax(ab.geom::box2d)::int as xmax,
    st_ymin(ab.geom::box2d)::int as ymin , st_ymax(ab.geom::box2d)::int as ymax,
      a.ramp
FROM admin_bound_values a join administrative_boundaries ab on a.node_path = ab.node_path
WHERE valid
ORDER BY nlevel(a.node_path), a.node_path DESC"

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

# Execute query, loops through the result and generates mapcache_seed commands for each map to generate:
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
        OUTSIZE="1024 1024"
        EXTENT="-txe ${xmin} ${xmax} -tye ${ymin} ${ymax}"
    else
        OUTSIZE="512 512"
        EXTENT=""
    fi

    # if file already exists, skips
    if [ -f /Volumes/GROSSD/tmp/priceeffi/rasterprice_${node_path}.jpg.tif ] ; then
        echo "[WARNING] file rasterprice_${node_path}.tif exists, skipping"
    else
        echo ""
        echo "•••resampling for ${node_path}..."
        ${GDALDIR}/gdalwarp -co COMPRESS=JPEG -co JPEG_QUALITY=75 \
            -r bilinear -ts 1024 0 \
           /Volumes/GROSSD/tmp/priceeffi/rasterprice_${node_path}.tif \
           /Volumes/GROSSD/tmp/priceeffi/rasterprice_${node_path}.jpg.tif
    fi
done
