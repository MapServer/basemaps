CPP=cpp

OSM_PREFIX=osm_new_
OSM_SRID=4326
OSM_UNITS=dd
OSM_WMS_SRS="EPSG:900913 EPSG:4326 EPSG:3857"

template=osmtemplate.map
theme=thematic
includes=landuse.map buildings.map\
		 highways_5k.map highways_10k.map highways_25k.map highways_50k.map \
		 highways_100k.map highways_250k.map highways_500k.map highways_1m.map\
		 highways_2.5m.map highways_5m.map highways_10m.map\
		 places.map places_25k.map places_50k.map places_100k.map places_250k.map\
		 places_500k.map places_1m.map places_2.5m.map places_5m.map places_10m.map\
		 places_25m.map\
		 highways-close.map highways-medium.map highways-far.map\
		 $(theme).style
mapfile=osm-$(theme).map
here=`pwd`

all:$(mapfile) $(postprocess)

SED=sed
SEDI=$(SED) -i
#if on BSD, use
# SED=sed -i ""

$(mapfile):$(template) $(includes) shapefiles
	$(CPP) -DOSM_PREFIX=$(OSM_PREFIX) -DOSM_SRID=$(OSM_SRID) -P -o $(mapfile) $(template) -Dtheme=\"$(theme).style\" -D_proj_lib=\"$(here)\"
	$(SEDI) 's/##.*$$//g' $(mapfile)
	$(SEDI) '/^ *$$/d' $(mapfile)
	$(SEDI) -e 's/OSM_PREFIX_/$(OSM_PREFIX)/g' $(mapfile)
	$(SEDI) -e 's/OSM_SRID/$(OSM_SRID)/g' $(mapfile)
	$(SEDI) -e 's/OSM_UNITS/$(OSM_UNITS)/g' $(mapfile)
	$(SEDI) -e 's/OSM_WMS_SRS/$(OSM_WMS_SRS)/g' $(mapfile)

shapefiles:
	cd data; $(MAKE) $(MFLAGS)

extent="-189249.81140511,4805160.045596,339916.56951172,5334326.4265128"
extent="235459.12591906,5064998.3775063,246042.4535374,5075581.7051247"
