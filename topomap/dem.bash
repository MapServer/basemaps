#!/usr/bin/env bash
# generates sample dem for topo map

# vrt for set of dem
#gdalbuildvrt -a_srs EPSG:4258 dem.vrt eudem*.tif
#
#gdalwarp -overwrite -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 \
#    -t_srs EPSG:3857 -r cubicspline -tr 5000 5000 \
#    dem.vrt warp-5000.tif
#
#gdalwarp -overwrite -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 \
#    -t_srs EPSG:3857 -r cubicspline -tr 500 500 \
#    dem.vrt warp-500.tif
#
#gdalwarp -overwrite -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 \
#    -t_srs EPSG:3857 -r cubicspline -tr 700 700 \
#    dem.vrt warp-700.tif
#
#gdalwarp -overwrite -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 \
#    -t_srs EPSG:3857 -r bilinear -tr 30 30 \
#    dem.vrt warp-30.tif
#
## relief:
#gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-700.tif relief.txt relief-700.tif
#gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-500.tif relief.txt relief-500.tif


# hillshade
#gdaldem hillshade -z 7 -compute_edges -co COMPRESS=JPEG warp-5000.tif hillshade-5000.tif
#gdaldem hillshade -z 7 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-700.tif hillshade-700.tif
#gdaldem hillshade -z 4 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-500.tif hillshade-500.tif
#gdaldem hillshade -z 2 -co compress=lzw -co predictor=2 -co bigtiff=yes -compute_edges warp-30.tif hillshade-30.tif
#gdal_translate -co compress=JPEG -co bigtiff=yes -co tiled=yes hillshade-30.tif hillshade-30m-jpeg.tif

#slopeshade

#gdaldem --config GDAL_CACHEMAX 512 slope -co compress=lzw warp-5000.tif slope-5000.tif -of GTiff
#gdaldem --config GDAL_CACHEMAX 512 color-relief -co compress=lzw slope-5000.tif color_slope.txt slopeshade-5000.tif
#gdaldem --config GDAL_CACHEMAX 512 slope -co compress=lzw warp-700.tif slope-700.tif -of GTiff
#gdaldem --config GDAL_CACHEMAX 512 color-relief -co compress=lzw slope-700.tif color_slope.txt slopeshade-700.tif
#gdaldem --config GDAL_CACHEMAX 512 slope -co compress=lzw warp-500.tif slope-500.tif -of GTiff
#gdaldem --config GDAL_CACHEMAX 512 color-relief -co compress=lzw slope-500.tif color_slope.txt slopeshade-500.tif

# todo: slope with lower resolution.
#gdaldem --config GDAL_CACHEMAX 512 slope -co compress=lzw -co BIGTIFF=YES warp-30.tif slope-30.tif -of GTiff
#gdaldem --config GDAL_CACHEMAX 512 color-relief -co compress=lzw -co BIGTIFF=YES slope-30.tif color_slope.txt slopeshade-30.tif
gdal_translate -co compress=JPEG -co bigtiff=yes -co tiled=yes slopeshade-30.tif slopeshade-30m-jpeg.tif

#contour:
#todo:
#-- contours 1m:
gdal_contour -LCO OVERWRITE=Yes -a height -i 100 -f PostgreSQL warp-5000.tif PG:"dbname=osm port=5436 user=ubuntu" -nln contour_100m
gdal_contour -LCO OVERWRITE=Yes -a height -i 50 -f PostgreSQL warp-700.tif PG:"dbname=osm port=5436 user=ubuntu" -nln contour_50m
gdal_contour -LCO OVERWRITE=Yes -a height -i 20 -f PostgreSQL warp-500.tif PG:"dbname=osm port=5436 user=ubuntu" -nln contour_20m
gdal_contour -LCO OVERWRITE=Yes -a height -i 10 -f PostgreSQL warp-30.tif PG:"dbname=osm port=5436 user=ubuntu" -nln contour_10m

