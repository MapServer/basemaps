UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
SED=sed -i ""
CPP=cpp-4.2
else
SED=sed -i
CPP=cpp
endif


OSM_PREFIX=osm_new_
OSM_NAME_COLUMN=name
OSM_SRID=4326
OSM_UNITS=dd
OSM_EXTENT=-180 -90 180 90
OSM_SRID=3857
OSM_UNITS=meters
OSM_DB_CONNECTION=host=localhost dbname=osm user=osm password=osm port=5432
OSM_EXTENT=-20000000 -20000000 20000000 20000000
OSM_WMS_SRS="EPSG:900913 EPSG:4326 EPSG:3857 EPSG:2154 EPSG:310642901 EPSG:4171 EPSG:310024802 EPSG:310915814 EPSG:310486805 EPSG:310702807 EPSG:310700806 EPSG:310547809 EPSG:310706808 EPSG:310642810 EPSG:310642801 EPSG:310642812 EPSG:310032811 EPSG:310642813 EPSG:2986"
DEBUG=1
LAYERDEBUG=1
STYLE=default
#can also use google or bing

template=osmbase.map

includes=land.map landusage.map borders.map highways.map places.map \
		 generated/$(STYLE)style.msinc \
		 generated/$(STYLE)level0.msinc generated/$(STYLE)level1.msinc generated/$(STYLE)level2.msinc generated/$(STYLE)level3.msinc \
		 generated/$(STYLE)level4.msinc generated/$(STYLE)level5.msinc generated/$(STYLE)level6.msinc generated/$(STYLE)level7.msinc \
		 generated/$(STYLE)level8.msinc generated/$(STYLE)level9.msinc generated/$(STYLE)level10.msinc generated/$(STYLE)level11.msinc \
		 generated/$(STYLE)level12.msinc generated/$(STYLE)level13.msinc generated/$(STYLE)level14.msinc generated/$(STYLE)level15.msinc \
		 generated/$(STYLE)level16.msinc generated/$(STYLE)level17.msinc generated/$(STYLE)level18.msinc



mapfile=osm-$(STYLE).map
here=`pwd`

all:$(mapfile) boundaries.sql

generated/$(STYLE)style.msinc: generate_style.py
	python generate_style.py -s $(STYLE) -g > $@

generated/$(STYLE)level0.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 0 > $@ 

generated/$(STYLE)level1.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 1 > $@ 

generated/$(STYLE)level2.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 2 > $@ 

generated/$(STYLE)level3.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 3 > $@ 

generated/$(STYLE)level4.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 4 > $@ 

generated/$(STYLE)level5.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 5 > $@ 

generated/$(STYLE)level6.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 6 > $@ 

generated/$(STYLE)level7.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 7 > $@ 

generated/$(STYLE)level8.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 8 > $@ 

generated/$(STYLE)level9.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 9 > $@ 

generated/$(STYLE)level10.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 10 > $@

generated/$(STYLE)level11.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 11 > $@

generated/$(STYLE)level12.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 12 > $@

generated/$(STYLE)level13.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 13 > $@

generated/$(STYLE)level14.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 14 > $@

generated/$(STYLE)level15.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 15 > $@

generated/$(STYLE)level16.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 16 > $@

generated/$(STYLE)level17.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 17 > $@

generated/$(STYLE)level18.msinc: generate_style.py
	python generate_style.py  -s $(STYLE) -l 18 > $@

$(mapfile):$(template) $(includes)
	$(CPP) -D_debug=$(DEBUG) -D_layerdebug=$(LAYERDEBUG)  -DOSM_PREFIX=$(OSM_PREFIX) -DOSM_SRID=$(OSM_SRID) -P -o $(mapfile) $(template) -DTHEME=$(STYLE) -D_proj_lib=\"$(here)\" -Igenerated
	$(SED) 's/##.*$$//g' $(mapfile)
	$(SED) '/^ *$$/d' $(mapfile)
	$(SED) -e 's/OSM_PREFIX_/$(OSM_PREFIX)/g' $(mapfile)
	$(SED) -e 's/OSM_SRID/$(OSM_SRID)/g' $(mapfile)
	$(SED) -e 's/OSM_UNITS/$(OSM_UNITS)/g' $(mapfile)
	$(SED) -e 's/OSM_EXTENT/$(OSM_EXTENT)/g' $(mapfile)
	$(SED) -e 's/OSM_WMS_SRS/$(OSM_WMS_SRS)/g' $(mapfile)
	$(SED) -e 's/OSM_NAME_COLUMN/$(OSM_NAME_COLUMN)/g' $(mapfile)
	$(SED) -e 's/OSM_DB_CONNECTION/$(OSM_DB_CONNECTION)/g' $(mapfile)

boundaries.sql: boundaries.sql.in
	cp -f $< $@
	$(SED) -e 's/OSM_PREFIX_/$(OSM_PREFIX)/g' $@

clean:
	rm -f generated/*

data:
	cd data; $(MAKE) $(MFLAGS)
