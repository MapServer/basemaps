CPP=cpp

OSM_PREFIX=osm_
OSM_SRID=4326
OSM_UNITS=dd
OSM_WMS_SRS="EPSG:900913 EPSG:4326 EPSG:3857"
DEBUG=1
LAYERDEBUG=1

template=osmbase.map

includes=land.map landusage.map borders.map highways.map places.map \
		 style.inc \
		 level0.inc level1.inc level2.inc level4.inc level3.inc level5.inc level6.inc\
       level7.inc level8.inc level9.inc level10.inc level11.inc level12.inc\
       level13.inc level14.inc level15.inc level16.inc level17.inc level18.inc



mapfile=osm.map
here=`pwd`

all:$(mapfile) boundaries.sql

SED=sed
SEDI=$(SED) -i
#if on BSD, use
# SED=sed -i ""
#

style.inc: generate_style.py
	python generate_style.py -s > style.inc

level0.inc: generate_style.py
	python generate_style.py -l 0 > $@ 

level1.inc: generate_style.py
	python generate_style.py -l 1 > $@ 

level2.inc: generate_style.py
	python generate_style.py -l 2 > $@ 

level3.inc: generate_style.py
	python generate_style.py -l 3 > $@ 

level4.inc: generate_style.py
	python generate_style.py -l 4 > $@ 

level5.inc: generate_style.py
	python generate_style.py -l 5 > $@ 

level6.inc: generate_style.py
	python generate_style.py -l 6 > $@ 

level7.inc: generate_style.py
	python generate_style.py -l 7 > $@ 

level8.inc: generate_style.py
	python generate_style.py -l 8 > $@ 

level9.inc: generate_style.py
	python generate_style.py -l 9 > $@ 

level10.inc: generate_style.py
	python generate_style.py -l 10 > $@
level11.inc: generate_style.py
	python generate_style.py -l 11 > $@

level12.inc: generate_style.py
	python generate_style.py -l 12 > $@

level13.inc: generate_style.py
	python generate_style.py -l 13 > $@

level14.inc: generate_style.py
	python generate_style.py -l 14 > $@

level15.inc: generate_style.py
	python generate_style.py -l 15 > $@

level16.inc: generate_style.py
	python generate_style.py -l 16 > $@

level17.inc: generate_style.py
	python generate_style.py -l 17 > $@

level18.inc: generate_style.py
	python generate_style.py -l 18 > $@

$(mapfile):$(template) $(includes) shapefiles
	$(CPP) -D_debug=$(DEBUG) -D_layerdebug=$(LAYERDEBUG)  -DOSM_PREFIX=$(OSM_PREFIX) -DOSM_SRID=$(OSM_SRID) -P -o $(mapfile) $(template) -D_proj_lib=\"$(here)\"
	$(SEDI) 's/##.*$$//g' $(mapfile)
	$(SEDI) '/^ *$$/d' $(mapfile)
	$(SEDI) -e 's/OSM_PREFIX_/$(OSM_PREFIX)/g' $(mapfile)
	$(SEDI) -e 's/OSM_SRID/$(OSM_SRID)/g' $(mapfile)
	$(SEDI) -e 's/OSM_UNITS/$(OSM_UNITS)/g' $(mapfile)
	$(SEDI) -e 's/OSM_WMS_SRS/$(OSM_WMS_SRS)/g' $(mapfile)

boundaries.sql: boundaries.sql.in
	cp -f $< $@
	$(SEDI) -e 's/OSM_PREFIX_/$(OSM_PREFIX)/g' $@

shapefiles:
	cd data; $(MAKE) $(MFLAGS)
