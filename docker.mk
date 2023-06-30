OSM_DB_CONNECTION=host=postgis dbname=osm user=osm password=osm port=5432
OSM_PREFIX=osm_
OSM_FORCE_POSTGIS_EXTENT=1
OSM_WMS_SRS=EPSG:900913 EPSG:4326 EPSG:3857 EPSG:28992
PROJ_LIB=/usr/share/proj/
STYLE=google

include Makefile
