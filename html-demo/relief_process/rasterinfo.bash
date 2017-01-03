#!/usr/bin/env bash
# returns info on given raster

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

#echo "script running on: $platform"

${GDALDIR}/gdalinfo -hist dem/srtm_merged_3857.vrt | egrep "STATISTICS_MAXIMUM|STATISTICS_MINIMUM|STATISTICS_MEAN"
