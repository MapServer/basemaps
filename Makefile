UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
SED=sed -i ""
CPP=cpp-4.2
else
SED=sed -i
CPP=cpp
endif


OSM_PREFIX=osm_new_
#OSM_SRID=4326
#OSM_UNITS=dd
#OSM_EXTENT=-180 -90 180 90
OSM_SRID=900913
OSM_UNITS=meters
OSM_EXTENT=-20000000 -20000000 20000000 20000000
OSM_WMS_SRS="EPSG:900913 EPSG:4326 EPSG:3857 EPSG:2154 EPSG:310642901 EPSG:4171 EPSG:310024802 EPSG:310915814 EPSG:310486805 EPSG:310702807 EPSG:310700806 EPSG:310547809 EPSG:310706808 EPSG:310642810 EPSG:310642801 EPSG:310642812 EPSG:310032811 EPSG:310642813 EPSG:2986"
DEBUG=1
LAYERDEBUG=1
STYLE=outlined,google,usshields
#can also use google or bing

template=osmbase.map

includes=land.map landusage.map borders.map highways.map places.map \
		 style-$(STYLE).inc \
		 level0.inc level1.inc level2.inc level4.inc level3.inc level5.inc level6.inc\
       level7.inc level8.inc level9.inc level10.inc level11.inc level12.inc\
       level13.inc level14.inc level15.inc level16.inc level17.inc level18.inc



mapfile=osm-$(STYLE).map
here=`pwd`

all:$(mapfile) boundaries.sql

style-$(STYLE).inc: generate_style.py
	python generate_style.py -s $(STYLE) -g > $@

level0.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 0 > $@ 

level1.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 1 > $@ 

level2.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 2 > $@ 

level3.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 3 > $@ 

level4.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 4 > $@ 

level5.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 5 > $@ 

level6.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 6 > $@ 

level7.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 7 > $@ 

level8.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 8 > $@ 

level9.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 9 > $@ 

level10.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 10 > $@
level11.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 11 > $@

level12.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 12 > $@

level13.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 13 > $@

level14.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 14 > $@

level15.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 15 > $@

level16.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 16 > $@

level17.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 17 > $@

level18.inc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 18 > $@

$(mapfile):$(template) $(includes) shapefiles
	$(CPP) -D_debug=$(DEBUG) -D_layerdebug=$(LAYERDEBUG)  -DOSM_PREFIX=$(OSM_PREFIX) -DOSM_SRID=$(OSM_SRID) -P -o $(mapfile) $(template) -Dtheme=\"style-$(STYLE).inc\" -D_proj_lib=\"$(here)\"
	$(SED) 's/##.*$$//g' $(mapfile)
	$(SED) '/^ *$$/d' $(mapfile)
	$(SED) -e 's/OSM_PREFIX_/$(OSM_PREFIX)/g' $(mapfile)
	$(SED) -e 's/OSM_SRID/$(OSM_SRID)/g' $(mapfile)
	$(SED) -e 's/OSM_UNITS/$(OSM_UNITS)/g' $(mapfile)
	$(SED) -e 's/OSM_EXTENT/$(OSM_EXTENT)/g' $(mapfile)
	$(SED) -e 's/OSM_WMS_SRS/$(OSM_WMS_SRS)/g' $(mapfile)

boundaries.sql: boundaries.sql.in
	cp -f $< $@
	$(SED) -e 's/OSM_PREFIX_/$(OSM_PREFIX)/g' $@

shapefiles:
	cd data; $(MAKE) $(MFLAGS)
