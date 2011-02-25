all: world_bnd_m.shp 10m_populated_places.shp 10m_admin_0_boundary_lines_land.shp 110m_admin_0_boundary_lines.shp processed_p.shp shoreline_300.shp

processed_p.shp: processed_p.tar.bz2
	tar xmjf processed_p.tar.bz2

shoreline_300.shp: shoreline_300.tar.bz2
	tar xmjf shoreline_300.tar.bz2
	
world_bnd_m.shp: world_boundaries-spherical.tgz
	tar xmzf world_boundaries-spherical.tgz && mv world_boundaries/* . && rm -rf world_boundaries

10m_populated_places.shp: 10m-populated-places.zip
	unzip 10m-populated-places.zip
	touch 10m_populated_places.shp

110m_admin_0_boundary_lines.shp: 110m-admin-0-boundary-lines.zip
	unzip 110m-admin-0-boundary-lines.zip
	touch 110m_admin_0_boundary_lines.shp

10m_admin_0_boundary_lines_land.shp: 10m-admin-0-boundary-lines-land.zip
	unzip 10m-admin-0-boundary-lines-land.zip
	touch 10m_admin_0_boundary_lines_land.shp

processed_p.tar.bz2:
	wget http://tile.openstreetmap.org/processed_p.tar.bz2

world_boundaries-spherical.tgz:
	wget http://tile.openstreetmap.org/world_boundaries-spherical.tgz

10m-populated-places.zip:
	wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/10m-populated-places.zip

10m-admin-0-boundary-lines-land.zip:
	wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/10m-admin-0-boundary-lines-land.zip

110m-admin-0-boundary-lines.zip:
	wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/110m-admin-0-boundary-lines.zip

shoreline_300.tar.bz2:
	wget http://tile.openstreetmap.org/shoreline_300.tar.bz2
