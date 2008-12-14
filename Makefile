CPP=cpp
template=osmtemplate.map
theme=osm1.style
includes=landuse.map buildings.map highways.map $(theme)
mapfile=osm.map
all:$(mapfile)

$(mapfile):$(template) $(includes)
	$(CPP) -P -o $(mapfile) $(template) -Dtheme=\"$(theme)\"
	sed -i 's/##.*$$//g' $(mapfile)
	sed -i '/^ *$$/d' $(mapfile)



tl=parisosm
tc=~/src/tilecache-svn/tilecache_seed.py
td=/patate1/SIGDATA/osm/tilecache/$(tl)

tiles: tiles0 tiles1 tiles2 tiles3 tiles4 tiles5 tiles6 tiles7 tiles8 tiles9

tiles0:
	rm -rf $(td)/00
	$(tc) $(tl) 0 1

tiles1:
	rm -rf $(td)/01
	$(tc) $(tl) 1 2

tiles2:
	rm -rf $(td)/02
	$(tc) $(tl) 2 3 "-160000,5900000,670000,6550000"

tiles3:
	rm -rf $(td)/03
	$(tc) $(tl) 3 4 "95000,6100000,420000,6350000"

tiles4:
	rm -rf $(td)/04
	$(tc) $(tl) 4 5 "190000,6180000,340000,6310000"

tiles5:
	rm -rf $(td)/05
	$(tc) $(tl) 5 6 "215000,6215000,300000,6280000"

tiles6:
	rm -rf $(td)/06
	$(tc) $(tl) 6 7 "243000,6236000,278000,6263000"

tiles7:
	rm -rf $(td)/07
	$(tc) $(tl) 7 8 "243000,6236000,278000,6263000"

tiles8:
	rm -rf $(td)/08
	$(tc) $(tl) 8 9 "243000,6236000,278000,6263000"

tiles9:
	rm -rf $(td)/09
	$(tc) $(tl) 9 10 "243000,6236000,278000,6263000"

upload:
	cd tilecache && find $(tl) | python ../upload-s3.py

optimize:
	for file in `find tilecache/$(tl) -name "*.png"`;do echo $$file; pngnq -e .png.caca -n 256 $$file; mv $$file.caca $$file; done
