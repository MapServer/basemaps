all: TM_WORLD_BORDERS-0.3.shp 10m_admin_0_boundary_lines_land.shp processed_p.shp shoreline_300.shp gadm1_lev2.shp gadm1_lev1.shp gadm1_lev1.shp


processed_p.shp: processed_p.tar.bz2
	tar xmjf processed_p.tar.bz2

shoreline_300.shp: shoreline_300.tar.bz2
	tar xmjf shoreline_300.tar.bz2
	
TM_WORLD_BORDERS-0.3.shp: TM_WORLD_BORDERS-0.3.zip
	unzip TM_WORLD_BORDERS-0.3.zip
	touch TM_WORLD_BORDERS-0.3.shp

10m_admin_0_boundary_lines_land.shp: 10m-admin-0-boundary-lines-land.zip
	unzip 10m-admin-0-boundary-lines-land.zip
	touch 10m_admin_0_boundary_lines_land.shp

gadm1_lev0.shp: gadm_v1_lev0_shp.zip
	unzip gadm_v1_lev0_shp.zip
	touch gadm1_lev0.shp

gadm1_lev1.shp: gadm_v1_lev1_shp.zip
	unzip gadm_v1_lev1_shp.zip
	touch gadm1_lev1.shp

gadm1_lev2.shp: gadm_v1_lev2_shp.zip
	unzip gadm_v1_lev2_shp.zip
	touch gadm1_lev2.shp

processed_p.tar.bz2:
	wget http://tile.openstreetmap.org/processed_p.tar.bz2

10m-admin-0-boundary-lines-land.zip:
	wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/10m-admin-0-boundary-lines-land.zip

shoreline_300.tar.bz2:
	wget http://tile.openstreetmap.org/shoreline_300.tar.bz2

TM_WORLD_BORDERS-0.3.zip:
	wget http://thematicmapping.org/downloads/TM_WORLD_BORDERS-0.3.zip

gadm_v1_lev0_shp.zip:
	wget http://www.gadm.org/data/gadm_v1_lev0_shp.zip

gadm_v1_lev1_shp.zip:
	wget http://www.gadm.org/data/gadm_v1_lev1_shp.zip

gadm_v1_lev2_shp.zip:
	wget http://biogeo.ucdavis.edu/data/gadm/gadm_v1_lev2_shp.zip
