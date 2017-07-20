#!/usr/bin/env bash


# import OSM data with imposm3, mapserver-basemaps config
#GOPATH=/home/pi/dev/go/bin
GOPATH=/Users/nicolas/bin/go/bin

#$GOPATH/imposm3 import -appendcache -config imposm3-conf.json -read /media/pi/Sandisk/france-latest.osm.pbf -write -diff
#${GOPATH}/imposm3 import -appendcache -config imposm3-conf.json -read /Volumes/TISSD/geodata/OSM/france-latest.osm.pbf -write -diff
#${GOPATH}/imposm3 import -appendcache -config imposm3-conf.json -read /Volumes/TISSD/geodata/OSM/DROM/drom.osm.pbf -write -diff

#$GOPATH/imposm3 import -config imposm3-conf.json -write -diff

# failed OOM

#optimize
#$GOPATH/imposm3 import -config imposm3-conf.json -optimize
# instantaneous...

# deploy import
#$GOPATH/imposm3 import -mapping imposm3-mapping.json -connection postgis://pi:pi@localhost:5432/osm -deployproduction
#$GOPATH/imposm3 import -mapping imposm3-mapping.json -connection postgis://nicolas:pi@localhost:5439/osm -deployproduction
$GOPATH/imposm3 import -mapping imposm3-mapping.json -connection postgis://nicolas:pi@localhost:5436/osm -deployproduction

# Run diff:
#$GOPATH/imposm3 run -config imposm3-conf.json
#TODO
