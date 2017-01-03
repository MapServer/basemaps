#!/usr/bin/env bash
# 03 janvier 2017:
# shell cmds to generate terrain image from dem:
# TODO: correct params handling

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


#------ merge: TODO: UI to choose dems to merge ??
#echo "••• merging..."
#${GDALDIR}/gdalbuildvrt ./dem/srtm_merged.vrt ./dem/srtm_37_04.tif
#
##------ warp:
#echo "••• warping..."
#rm -f ./dem/srtm_merged_3857.vrt
#${GDALDIR}/gdalwarp -t_srs epsg:3857 -r bilinear -of VRT ./dem/srtm_merged.vrt ./dem/srtm_merged_3857.vrt

#------- color-relief
if [[ "$1" == 'relief=true' ]]; then
    echo "••• color relief..."
    ${GDALDIR}/gdaldem color-relief -alpha ./dem/srtm_merged_3857.vrt tmpramp.txt ./dem/color_relief.tif
fi

#------- slope:
if [[ "$2" == 'slope=true' ]]; then
    echo "••• slope..."
    ${GDALDIR}/gdaldem slope -co compress=lzw ./dem/srtm_merged_3857.vrt ./dem/slope.tif -of GTiff
    #------ slopeshade:
    echo "••• slope shade..."
    ${GDALDIR}/gdaldem color-relief -co compress=lzw ./dem/slope.tif color_slope.txt ./dem/slopeshade.tif
fi

#------- hillshade
if [[ "$3" == 'hillshade=true' ]]; then
    echo "••• hillshade..."
    ${GDALDIR}/gdaldem hillshade -co compress=lzw ./dem/srtm_merged_3857.vrt ./dem/hillshade.tif -of GTiff
fi

echo "•••terrain generation done•••"

# TODO: vrt for process
# TODO: only if needed for each gdal cmd
# TODO: remove rasters if op not asked, for mapserver display to be synced.
# TODO: pyramids