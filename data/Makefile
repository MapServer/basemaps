SHPTREE=shptree

all: simplified_land_polygons.qix land_polygons.qix

%.qix: %.shp
	$(SHPTREE) $< 8


simplified_land_polygons.qix: simplified_land_polygons.shp
	$(SHPTREE) $< 8

land_polygons.qix: land_polygons.shp
	$(SHPTREE) $< 8

simplified_land_polygons.shp: simplified-land-polygons-complete-3857.zip
	unzip -o -D -j simplified-land-polygons-complete-3857.zip

.INTERMEDIATE: simplified-land-polygons-complete-3857.zip
simplified-land-polygons-complete-3857.zip:
	wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip

land_polygons.shp: land-polygons-split-3857.zip
	unzip -o -D -j land-polygons-split-3857.zip

.INTERMEDIATE: land-polygons-split-3857.zip
land-polygons-split-3857.zip:
	wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip
