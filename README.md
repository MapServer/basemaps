# Mapserver OSM basemaps

- this package uses a python script and the c preprocessor to build a
complete mapfile from a set of templates and styling information.

- use the branch corresponding to your mapserver version, e.g.
 - branch-6-2 for mapserver versions 6.2.X
 - master for development (unreleased) mapserver versions

- the build process uses the gcc preprocessor extensively, you should have it installed on your
system. On linux, check that the 'cpp' command is present. On OSX, the provided 'cpp' program is a shell
wrapper that is not suitable: the Makefile is coded to call 'cpp-4.2', which you can change in case
you have another version installed.

- The mapfiles rely on the database schema as created by a recent version of imposm. Until recently
imposm did not create the landusages_gen and waterareas_gen tables. Since 2.3.0 this is not the case anymore.
If you do not have the generalized tables, you can change the landusage_data and waterareas_data entries in
generate_style.py so that it queries the non-generalized
tables on the lower zoom levels (this will be slower for the lower zoom levels).

- The generated mapfile can also be made to query an osm database created with osm2pgsql rather than imposm.
This setup is not recommended as it will be much slower. To use the osm2pgsql schema, you should add the 'osm2pgsql'
entry to the list of styles for an entry of style_aliases near the end of generate_style.py, e.g:
   "bingosm2pgsql":"default,outlined,bing,osm2pgsql"

then run `make STYLE=bingosm2pgsql` to create the osm-bingosm2pgsql.map

- Most configuration and tweaks should be done in generate_style.py.
documentation as to how to edit generate_style.py to adapt the rendering has yet to be done, but is simple.
check https://github.com/mapserver/basemaps/wiki/Tweaking-Map-Styles for a preliminary tutorial.

