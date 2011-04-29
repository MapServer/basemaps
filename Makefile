CPP=cpp

OSM_PREFIX=osm_new_
OSM_SRID=4326
OSM_UNITS=dd
OSM_WMS_SRS="EPSG:900913 EPSG:4326 EPSG:3857"

template=osmtemplate.map
theme=mapserver
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
postprocess=postprocess.sql
postprocess_in=postprocess.sql.in
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

$(postprocess):$(postprocess_in)
	$(SED) -e 's/OSM_PREFIX_/$(OSM_PREFIX)/g' $(postprocess_in) > $(postprocess)
	
shapefiles:
	cd data; $(MAKE) $(MFLAGS)

extent="-189249.81140511,4805160.045596,339916.56951172,5334326.4265128"
extent="235459.12591906,5064998.3775063,246042.4535374,5075581.7051247"

tl=$(theme)
tc=~/src/tilecache/tilecache_seed.py
td=/scratch/tbonfort/data/tilecache/$(tl)

tiles: tiles0 tiles1 tiles2 tiles3 tiles4 tiles5 tiles6 tiles7 tiles8 tiles9 tiles10 tiles11

tiles0:
	rm -rf $(td)/00
	$(tc) $(tl) 0 1 -p 2 -b $(extent)

tiles1:
	rm -rf $(td)/01
	$(tc) $(tl) 1 2 -p 2 -b $(extent)

tiles2:
	rm -rf $(td)/02
	$(tc) $(tl) 2 3 -p 2 -b $(extent)

tiles3:
	rm -rf $(td)/03
	$(tc) $(tl) 3 4 -p 2 -b $(extent)

tiles4:
	rm -rf $(td)/04
	$(tc) $(tl) 4 5 -p 2 -b $(extent)

tiles5:
	rm -rf $(td)/05
	$(tc) $(tl) 5 6 -p 2 -b $(extent)

tiles6:
	rm -rf $(td)/06
	$(tc) $(tl) 6 7 -p 2 -b $(extent)

tiles7:
	rm -rf $(td)/07 
	$(tc) $(tl) 7 8 -p 2 -b $(extent)

tiles8:
	rm -rf $(td)/08
	$(tc) $(tl) 8 9 -p 2 -b $(extent)

tiles9:
	rm -rf $(td)/09
	$(tc) $(tl) 9 10 -p 2 -b $(extent)

tiles10:
	rm -rf $(td)/10
	$(tc) $(tl) 10 11 -p 2 -b $(extent)

tiles11:
	rm -rf $(td)/11
	$(tc) $(tl) 11 12 -p 2 -b $(extent)

upload:
	cd tilecache && find $(tl) | python ../upload-s3.py

optimize:
	for file in `find tilecache/$(tl) -name "*.png"`;do echo $$file; pngnq -e .png.caca -n 256 $$file; mv $$file.caca $$file; done
