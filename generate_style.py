#!/usr/bin/env python

layer_suffixes = {
   0:0,
   1:1,
   2:2,
   3:3,
   4:4,
   5:5,
   6:6,
   7:7,
   8:8,
   9:9,
   10:10,
   11:11,
   12:12,
   13:13,
   14:14,
   15:15,
   16:16,
   17:17,
   18:18
}

maxscales = {
   0:99999999999,
   1:332808204,
   2:166404102,
   3:83202051,
   4:41601025,
   5:20800512,
   6:10400256,
   7:5200128,
   8:2600064,
   9:1300032,
   10:650016,
   11:325008,
   12:162504,
   13:81252,
   14:40626,
   15:20313,
   16:10156,
   17:5078,
   18:2539
}
minscales = {
   0:332808204,
   1:166404102,
   2:83202051,
   3:41601025,
   4:20800512,
   5:10400256,
   6:5200128,
   7:2600064,
   8:1300032,
   9:650016,
   10:325008,
   11:162504,
   12:81252,
   13:40626,
   14:20313,
   15:10156,
   16:5078,
   17:2539,
   18:0
}

defaults = {
   'dbconnection': {0:'"host=localhost dbname=osm user=osm password=osm port=5432"'},
   'font': {0:'"sc"'},
   'boldfont': {0:'"scb"'},
   'lbl_clr': {0:"0 0 0"},
   'lbl_size': {0:8},
   'lbl_ol_clr':{0:"255 255 255"},
   'lbl_ol_width':{0:2},
   'water_clr': {0:'"#B3C6D4"'},
   'water_font': {0:'"sc"'},
   'water_lbl_size':{0:8},
   'water_lbl_clr':{0:'"#6B94B0"'},
   'water_lbl_ol_clr':{0:'255 255 255'},
   'water_lbl_ol_width':{0:2},
   'road_clr':{0:'"#ffffff"'},
   'bridge_width':{0:0.5,14:1},
   'bridge_clr':{0:'"#888888"'},
   'road_far_clr':'"#aaaaaa"',

};

vars= {
   'layer_suffix':layer_suffixes,
   'maxscale':maxscales,
   'minscale':minscales,
   'db_connection': defaults['dbconnection'],
   'ocean_clr': defaults['water_clr'],
   'land_clr': {
      0:'"#E8E6E1"'
   },
   'display_landusage': {
      0:0,
      4:1
   },
   'transport_clr': {
      0:'200 200 200'
   },
   'forest_clr': {
      0:'"#C2D1B2"'
   },
   'residential_clr': {
      0:'"#E3DED4"'
   },
   'industrial_clr': {
      0:'"#d1d1d1"'
   },
   'hospital_clr': {
      0:'"#E6C8C3"'
   },
   'education_clr': {
      0:'"#DED1AB"'
   },
   'sports_clr': {
      0:'"#DED1AB"'
   },
   'cemetery_clr': {
      0:'"#d1d1d1"'
   },
   'park_clr': {
      0:'"#C2D1B2"'
   },
   'waterarea_clr':defaults['water_clr'],
   'river_clr':defaults['water_clr'],
   'stream_clr':defaults['water_clr'],
   'canal_clr':defaults['water_clr'],

   'display_admin': {
      0:0,
      7:0
   },
   'admin_clr': {
      0:'"#333333"'
   },
   'admin_width': {
      0:0.75
   },
   'admin_data': {
      0:"data/depts",
      11:"data/communes"
   },

   'display_canal_lbl' : {0:0, 12:1},
   'canal_font': defaults['water_font'],
   'canal_lbl_size': defaults['water_lbl_size'],
   'canal_lbl_clr': defaults['water_lbl_clr'],
   'canal_lbl_ol_clr': defaults['water_lbl_ol_clr'],
   'canal_lbl_ol_width': defaults['water_lbl_ol_width'],

   'display_stream_lbl' : {0:0, 13:1},
   'stream_font': defaults['water_font'],
   'stream_lbl_size': defaults['water_lbl_size'],
   'stream_lbl_clr': defaults['water_lbl_clr'],
   'stream_lbl_ol_clr': defaults['water_lbl_ol_clr'],
   'stream_lbl_ol_width': defaults['water_lbl_ol_width'],

   'display_river_lbl' : {0:0, 10:1},
   'river_font': defaults['water_font'],
   'river_lbl_size': defaults['water_lbl_size'],
   'river_lbl_clr': defaults['water_lbl_clr'],
   'river_lbl_ol_clr': defaults['water_lbl_ol_clr'],
   'river_lbl_ol_width': defaults['water_lbl_ol_width'],

   'display_waterarea_lbl' : {0:0, 6:1},
   'waterarea_font': defaults['water_font'],
   'waterarea_lbl_size': defaults['water_lbl_size'],
   'waterarea_lbl_clr': defaults['water_lbl_clr'],
   'waterarea_lbl_ol_clr': defaults['water_lbl_ol_clr'],
   'waterarea_lbl_ol_width': defaults['water_lbl_ol_width'],

   'display_industrial_lbl' : {0:0, 11:1},
   'industrial_font': defaults['font'],
   'industrial_lbl_size': defaults['lbl_size'],
   'industrial_lbl_clr': defaults['lbl_clr'],
   'industrial_lbl_ol_clr': defaults['lbl_ol_clr'],
   'industrial_lbl_ol_width': defaults['lbl_ol_width'],

   'display_residential_lbl' : {0:0, 12:1},
   'residential_font': defaults['font'],
   'residential_lbl_size': defaults['lbl_size'],
   'residential_lbl_clr': defaults['lbl_clr'],
   'residential_lbl_ol_clr': defaults['lbl_ol_clr'],
   'residential_lbl_ol_width': defaults['lbl_ol_width'],

   'display_park_lbl' : {0:0, 11:1},
   'park_font': defaults['font'],
   'park_lbl_size': defaults['lbl_size'],
   'park_lbl_clr': defaults['lbl_clr'],
   'park_lbl_ol_clr': defaults['lbl_ol_clr'],
   'park_lbl_ol_width': defaults['lbl_ol_width'],

   'display_hospital_lbl' : {0:0, 12:1},
   'hospital_font': defaults['font'],
   'hospital_lbl_size': defaults['lbl_size'],
   'hospital_lbl_clr': defaults['lbl_clr'],
   'hospital_lbl_ol_clr': defaults['lbl_ol_clr'],
   'hospital_lbl_ol_width': defaults['lbl_ol_width'],

   'display_education_lbl' : {0:0, 12:1},
   'education_font': defaults['font'],
   'education_lbl_size': defaults['lbl_size'],
   'education_lbl_clr': defaults['lbl_clr'],
   'education_lbl_ol_clr': defaults['lbl_ol_clr'],
   'education_lbl_ol_width': defaults['lbl_ol_width'],
   
   'display_sports_lbl' : {0:0, 12:1},
   'sports_font': defaults['font'],
   'sports_lbl_size': defaults['lbl_size'],
   'sports_lbl_clr': defaults['lbl_clr'],
   'sports_lbl_ol_clr': defaults['lbl_ol_clr'],
   'sports_lbl_ol_width': defaults['lbl_ol_width'],

   'display_pedestrian_lbl' : {0:0, 12:1},
   'pedestrian_font': defaults['font'],
   'pedestrian_lbl_size': defaults['lbl_size'],
   'pedestrian_lbl_clr': defaults['lbl_clr'],
   'pedestrian_lbl_ol_clr': defaults['lbl_ol_clr'],
   'pedestrian_lbl_ol_width': defaults['lbl_ol_width'],

   'display_cemetery_lbl' : {0:0, 12:1},
   'cemetery_font': defaults['font'],
   'cemetery_lbl_size': defaults['lbl_size'],
   'cemetery_lbl_clr': defaults['lbl_clr'],
   'cemetery_lbl_ol_clr': defaults['lbl_ol_clr'],
   'cemetery_lbl_ol_width': defaults['lbl_ol_width'],

   'display_transport_lbl' : {0:0, 12:1},
   'transport_font': defaults['font'],
   'transport_lbl_size': defaults['lbl_size'],
   'transport_lbl_clr': defaults['lbl_clr'],
   'transport_lbl_ol_clr': defaults['lbl_ol_clr'],
   'transport_lbl_ol_width': defaults['lbl_ol_width'],
   
   'land_data': {
      0:'"data/TM_WORLD_BORDERS-0.3.shp"',
      3:'"data/shoreline_300"',
      7:'"data/processed_p"'
   },
   'land_epsg': {
      0:'"+init=epsg:4326"',
      3:'"+init=epsg:900913"',
   },
   'display_bridges': {
      0:0,
      14:1
   },
   'motorway_bridge_clr':defaults['bridge_clr'],
   'motorway_bridge_width':defaults['bridge_width'],
   'trunk_bridge_clr':defaults['bridge_clr'],
   'trunk_bridge_width':defaults['bridge_width'],
   'primary_bridge_clr':defaults['bridge_clr'],
   'primary_bridge_width':defaults['bridge_width'],
   'secondary_bridge_clr':defaults['bridge_clr'],
   'secondary_bridge_width':defaults['bridge_width'],
   'tertiary_bridge_clr':defaults['bridge_clr'],
   'tertiary_bridge_width':defaults['bridge_width'],
   'other_bridge_clr':defaults['bridge_clr'],
   'other_bridge_width':defaults['bridge_width'],
   'pedestrian_bridge_clr':defaults['bridge_clr'],
   'pedestrian_bridge_width':defaults['bridge_width'],

   'roads_data': {
      0:'"geometry from (select osm_id,geometry,name,ref,type,tunnel,bridge from OSM_PREFIX_roads_gen0 order by z_order asc, st_length(geometry) asc) as foo using unique osm_id using srid=OSM_SRID"',
      6:'"geometry from (select osm_id,geometry,name,ref,type,tunnel,bridge from OSM_PREFIX_roads_gen1 order by z_order asc, st_length(geometry) asc) as foo using unique osm_id using srid=OSM_SRID"',
      9:'"geometry from (select osm_id,geometry,name,ref,type,tunnel,bridge from OSM_PREFIX_roads order by z_order asc, st_length(geometry) asc) as foo using unique osm_id using srid=OSM_SRID"',
   },
   'tunnel_opacity': {
      0:40
   },
   'display_roads_tunnels': {
      0:0,
      14:1
   },
   'display_highways': {
      0:0,
      5:1
   },
   'display_motorways': {
      0:0,
      5:1
   },
   'display_trunks': {
      0:0,
      5:1
   },
   'motorway_clr': defaults['road_clr'],
   'motorway_width': {
      0:0.5,
      8:1,
      9:2,
      10:3,
      12:4,
      14:5,
      15:6,
      16:8,
      17:9,
      18:10
   },
   'label_motorways': {
      0:0,
      10:1
   },
   'motorway_font': defaults['boldfont'],
   'motorway_lbl_size': {
      0:7,
      14:8
   },
   'motorway_lbl_clr': {
      0:'"#555555"'
   },
   'trunk_clr': defaults['road_clr'],
   'trunk_width': {
      0:0.5,
      8:1,
      9:2,
      10:3,
      12:4,
      14:5,
      15:6,
      16:8,
      17:9,
      18:10
   },
   'label_trunks': {
      0:0,
      10:1
   },
   'trunk_font': defaults['boldfont'],
   'trunk_lbl_size': {
      0:7,
      14:8
   },
   'trunk_lbl_clr': {
      0:'"#555555"'
   },
   'display_primaries': {
      0:0,
      8:1
   },
   'primary_clr': {
      0:'-1 -1 -1',
      8:defaults['road_far_clr'],
      9:'"#ffffff"'
   },
   'primary_width': {
      0:0.5,
      9:0.75,
      10:1,
      11:1.5,
      12:2,
      13:2.5,
      14:3,
      15:4,
      16:7,
      17:8,
      18:9
   },
   'label_primaries': {
      0:0,
      13:1
   },
   'primary_font': defaults['font'],
   'primary_lbl_size': {
      0:0,
      13:7,
      15:8
   },
   'primary_lbl_clr': {
      0:'"#333333"'
   },
   'primary_lbl_ol_clr': {
      0:'255 255 255'
   },
   'display_secondaries': {
      0:0,
      9:1
   },
   'secondary_clr': {
      0:defaults['road_far_clr'],
      10:'"#ffffff"'
   },
   'secondary_width': {
      0:0,
      9:0.5,
      10:0.75,
      11:1,
      12:1.5,
      13:2,
      14:2.5,
      15:3.5,
      16:6,
      17:7,
      18:8
   },
   'label_secondaries': {
      0:0,
      13:1
   },
   'secondary_font': defaults['font'],
   'secondary_lbl_size': {
      0:0,
      13:7,
      15:8
   },
   'secondary_lbl_clr': {
      0:'"#333333"'
   },
   'secondary_lbl_ol_clr': {
      0:'255 255 255'
   },

   'display_trunk_links': {
      0:0,
      9:1
   },
   'display_motorway_links': {
      0:0,
      9:1
   },

   
   'display_tertiaries': {
      0:0,
      10:1
   },
   'tertiary_clr': {
      0:defaults['road_far_clr'],
      13:'"#ffffff"'
   },
   'tertiary_width': {
      0:0,
      10:0.5,
      11:0.75,
      12:1,
      13:1.5,
      14:2,
      15:2.5,
      16:5,
      17:6,
      18:7
   },
   'label_tertiaries': {
      0:0,
      15:1
   },
   'tertiary_font': defaults['font'],
   'tertiary_lbl_size': {
      0:0,
      15:7,
      16:8,
   },
   'tertiary_lbl_clr': {
      0:'"#333333"'
   },
   'tertiary_lbl_ol_clr': {
      0:'255 255 255'
   },

   'display_other_roads': {
      0:0,
      11:1
   },
   'other_clr': {
      0:defaults['road_far_clr'],
      15:'"#ffffff"'
   },
   'other_width': {
      0:0,
      11:0.5,
      13:0.75,
      14:1,
      15:2,
      16:4,
      17:5,
      18:6,
   },
   'label_other_roads': {
      0:0,
      15:1
   },
   'other_font': defaults['font'],
   'other_lbl_size': {
      0:0,
      15:7,
      16:8,
   },
   'other_lbl_clr': {
      0:'"#333333"'
   },
   'other_lbl_ol_clr': {
      0:'255 255 255'
   },
   
   'display_pedestrian': {
      0:0,
      12:1
   },
   'pedestrian_clr': {
      0:'"#f2f2ed"',
   },
   'pedestrian_width': {
      0:0,
      11:0.5,
      12:0.75,
      13:1,
      14:1.5,
      15:2,
      16:2.5,
      17:3,
      18:3.5,
   },
   'label_pedestrian': {
      0:0,
      15:1
   },
   'pedestrian_font': defaults['font'],
   'pedestrian_lbl_size': {
      0:0,
      15:7,
      16:8
   },
   'pedestrian_lbl_clr': {
      0:'"#333333"'
   },
   'pedestrian_lbl_ol_clr': {
      0:'255 255 255'
   },
   
   'display_tracks': {
      0:0,
      12:1
   },

   'track_clr': {
      0:defaults['road_far_clr'],
      15:'"#ffffff"',
   },
   'track_width': {
      0:0,
      11:0.5,
      12:0.75,
      15:1,
   },
   'track_pattern': {
      0: '2 2',
      15: '2 3'
   },
   'label_track': {
      0:0,
      15:1
   },
   'track_font': defaults['font'],
   'track_lbl_size': {
      0:0,
      15:7,
      16:8
   },
   'track_lbl_clr': {
      0:'"#333333"'
   },
   'track_lbl_ol_clr': {
      0:'255 255 255'
   },

   'display_footways': {
      0:0,
      15:1
   },
   'footway_clr': {
      0:defaults['road_far_clr'],
      15:'"#ffffff"',
   },
   'footway_width': {
      0:0,
      15:1,
   },
   'footway_pattern': {
      0:'2 3'
   },
   
   'railway_clr': {
      0:'"#777777"'
   },
   'railway_width': {
      0:0.5,
      10:1
   },
   'railway_pattern': {
      0:'2 2'
   },
   'railway_tunnel_opacity': {
      0:40
   },
   'railways_data': {
      0:'"geometry from (select geometry, osm_id, tunnel from OSM_PREFIX_railways where type=\'rail\') as foo using unique osm_id using srid=OSM_SRID"'
   },
   'display_railways': {
      0:0,
      8:1
   },
   'waterarea_data': {
      0: '"geometry from (select geometry,osm_id ,name,type from OSM_PREFIX_waterareas_gen0) as foo using unique osm_id using srid=OSM_SRID"',
      9: '"geometry from (select geometry,osm_id ,name,type from OSM_PREFIX_waterareas_gen1) as foo using unique osm_id using srid=OSM_SRID"',
      12: '"geometry from (select geometry,osm_id ,name,type from OSM_PREFIX_waterareas) as foo using unique osm_id using srid=OSM_SRID"'
   },
   'landusage_data': {
      0:'"geometry from (select geometry ,osm_id, type, name from OSM_PREFIX_landusages_gen0 \
      where type in (\'forest\',\'residential\',\'park\')\
      order by z_order asc) as foo using unique osm_id using srid=OSM_SRID"',
      10:'"geometry from (select geometry ,osm_id, type, name from OSM_PREFIX_landusages_gen1 \
      where type in (\'forest\',\'pedestrian\',\'cemetery\',\'industrial\',\'commercial\',\
      \'brownfield\',\'residential\',\'school\',\'college\',\'university\',\
      \'military\',\'park\',\'golf_course\',\'hospital\',\'parking\',\'stadium\',\'sports_center\',\
      \'pitch\') order by z_order asc) as foo using unique osm_id using srid=OSM_SRID"',
      13:'"geometry from (select geometry ,osm_id, type, name from OSM_PREFIX_landusages \
      where type in (\'forest\',\'pedestrian\',\'cemetery\',\'industrial\',\'commercial\',\
      \'brownfield\',\'residential\',\'school\',\'college\',\'university\',\
      \'military\',\'park\',\'golf_course\',\'hospital\',\'parking\',\'stadium\',\'sports_center\',\
      \'pitch\') order by z_order asc) as foo using unique osm_id using srid=OSM_SRID"'
   },
   'border_data': {
      0: '"data/boundaries.shp"'
   },
   'border_epsg': {
      0: '"+init=epsg:4326"'
   },
   'display_border_2': {
      0:1
   },
   'display_border_2_outer': {
      0:0,
      6:1
   },
   'border_2_clr': {
      0:'"#CDCBC6"'
   },
   'border_2_width': {
      0:5,
      10:7,
      12:8,
      14:9,
   },
   'border_2_inner_clr': {
      0:'"#CDCBC6"',
      4:'"#7d7b7d"'
   },
   'border_2_inner_width': {
      0:'0.5',
      7:'1'
   },
   'border_2_inner_pattern': {
      0:'',
      6:'PATTERN 4 3 1 3 END'
   },
   #         'display_border_4': {
   #            0:0,
   #            6:1
   #         },
   #         'display_border_4_outer': {
   #            0:0,
   #            7:1
   #         },
   #         'border_4_clr': {
   #            0:'"#CDCBC6"'
   #         },
   #         'border_4_width': {
   #            0:'5',
   #            8:'6'
   #         },
   #         'border_4_inner_clr': {
   #            0:'"#8d8b8d"'
   #         },
   #         'border_4_inner_width': {
   #            0:'0.5',
   #            7:'1'
   #         },
   #         'border_4_inner_pattern': {
   #            0:'',
   #            7:'PATTERN 2 2 END'
   #         },
   #         'display_border_6': {
   #            0:0,
   #            7:1
   #         },
   #         'display_border_6_outer': {
   #            0:0,
   #            9:1
   #         },
   #         'border_6_clr': {
   #            0:'"#CDCBC6"'
   #         },
   #         'border_6_width': {
   #            0:'5',
   #            13:'7'
   #         },
   #         'border_6_inner_clr': {
   #            0:'"#8d8b8d"'
   #         },
   #         'border_6_inner_width': {
   #            0:'0.5',
   #            9:1
   #         },
   #         'border_6_inner_pattern': {
   #            0:'',
   #            9:'PATTERN 2 2 END'
   #         },
   #         'display_border_8': {
   #            0:0,
   #            11:1
   #         },
   #         'display_border_8_outer': {
   #            0:0,
   #            13:1
   #         },
   #         'border_8_clr': {
   #            0:'"#CDCBC6"'
   #         },
   #         'border_8_width': {
   #            0:'5'
   #         },
   #         'border_8_inner_clr': {
   #            0:'"#8d8b8d"'
   #         },
   #         'border_8_inner_width': {
   #            0:'0.5',
   #            14:'1'
   #         },
   #         'border_8_inner_pattern': {
   #            0:'',
   #            13:'PATTERN 2 2 END'
   #         },
   'display_waterways': {
      0:0,
      6:1
   },
   'river_width': {
      0:0,
      6:0.15,
      7:0.25,
      8:0.5,
      9:1,
      11:2,
      13:3,
      15:4,
      16:5,
      17:6,
      18:7
   },
   'stream_width': {
      0:0,
      10:0.5,
      12:1,
      14:2
   },
   'canal_width': {
      0:0,
      10:0.5,
      12:1,
      14:2
   },
   'waterways_data': {
      0:'"geometry from (select geometry, osm_id, type, name from OSM_PREFIX_waterways where type=\'river\') as foo using unique osm_id using srid=OSM_SRID"',
      10:'"geometry from (select geometry, osm_id, type, name from OSM_PREFIX_waterways) as foo using unique osm_id using srid=OSM_SRID"'
   },
   'display_buildings': {
      0: 0,
      15:1
   },
   'building_clr': {
      0:'"#bbbbbb"'
   },
   'building_ol_clr': {
      0:'"#333333"'
   },
   'building_ol_width': {
      0:0,
      16:0.1,
      17:0.5
   },
   'building_font': defaults['font'],
   'building_lbl_clr': defaults['lbl_clr'],
   'building_lbl_size': {
      0:7,
      16:8
   },
   'building_lbl_ol_clr': defaults['lbl_ol_clr'],
   'building_lbl_ol_width': { 0: 1 },
   'label_buildings': {
      0: 0,
      15: 1
   },

   'display_aeroways': {
      0:0,
      10:1
   },
   'runway_clr': {
      0:"180 180 180"
   },
   'runway_width': {
      0:1,
      11:2,
      12:3,
      13:5,
      14:7,
      15:11,
      16:15,
      17:19,
      18:23
   },
   'runway_center_clr': {
      0:'80 80 80'
   },
   'runway_center_width': {
      0:0,
      15:1
   },
   'runway_center_pattern' : {
      0:'2 2'
   },
   'taxiway_width': {
      0:0,
      10:0.2,
      13:1,
      14:1.5,
      15:2,
      16:3,
      17:4,
      18:5
   },
   'taxiway_clr': {
      0:"180 180 180"
   },
   'places_data': {
      0: '"geometry from (select * from OSM_PREFIX_places where type in (\'country\',\'continent\') and name is not NULL order by population asc nulls first) as foo using unique osm_id using srid=OSM_SRID"',
      3: '"geometry from (select * from OSM_PREFIX_places where type in (\'country\',\'continent\',\'city\') and name is not NULL order by population asc nulls first) as foo using unique osm_id using srid=OSM_SRID"',
      8: '"geometry from (select * from OSM_PREFIX_places where type in (\'city\',\'town\') and name is not NULL order by population asc nulls first) as foo using unique osm_id using srid=OSM_SRID"',
      11: '"geometry from (select * from OSM_PREFIX_places where type in (\'city\',\'town\',\'village\') and name is not NULL order by population asc nulls first) as foo using unique osm_id using srid=OSM_SRID"',
      13: '"geometry from (select * from OSM_PREFIX_places where name is not NULL order by population asc nulls first) as foo using unique osm_id using srid=OSM_SRID"',
   },
   'display_capitals': {
      0:0,
   },
   'display_capital_symbol': {
      0:1,
      10:0
   },
   'capital_lbl_size': {
      0:0,
      3:7,
      5:8,
      8:9,
      10:10,
      13:11,
      15:12

   },
   'capital_size': {
      0:6
   },
   'capital_fg_size': {
      0:2
   },
   'capital_ol_clr': {
      0:'"#000000"'
   },
   'capital_fg_clr': {
      0:"0 0 0"
   },
   'capital_clr': {
      0:"255 0 0"
   },
   'capital_font': defaults['font'],
   'capital_lbl_clr': defaults['lbl_clr'],
   'capital_lbl_ol_clr': defaults['lbl_ol_clr'],
   'capital_lbl_ol_width':defaults['lbl_ol_width'],
   'display_continents': {
      0:1,
      3:0
   },
   'continent_lbl_size': {
      0:7,
      2:8
   },
   'continent_lbl_clr': {
      0:"100 100 100"
   },
   'continent_lbl_ol_width': {
      0:"1"
   },
   'continent_lbl_ol_clr': {
      0:"-1 -1 -1"
   },
   'continent_font': {
      0:"scb"
   },
   'display_countries': {
      0:0,
      2:1,
      8:0
   },
   'country_lbl_size': {
      0:7,
      3:8
   },
   'country_lbl_clr': {
      0: "100 100 100"
   },
   'country_lbl_ol_width': {
      0:"1"
   },
   'country_lbl_ol_clr': {
      0:"255 255 255"
   },
   'country_font': {
      0:"scb"
   },
   'display_cities': {
      0:0,
      3:1,
      16:0
   },
   'display_city_symbol': {
      0:1,
      10:0
   },
   'city_lbl_size': {
      0:0,
      3:7,
      5:8,
      7:9,
      10:10,
      11:11,
      13:12,
      15:13
   },
   'city_size': {
      0:1,
      8:3,
      10:4
   },
   'city_ol_clr': {
      0:'"#000000"'
   },
   'city_clr': {
      0:"200 200 200",
      8:"255 255 255"
   },
   'city_font': defaults['font'],
   'city_lbl_clr': {
      0:'"#444444"',
      8:'0 0 0'
   },
   'city_lbl_ol_clr': defaults['lbl_ol_clr'],
   'city_lbl_ol_width': {
      0:2,
      10:3
   },
   
   'display_towns': {
      0:0,
      8:1
   },
   'display_town_symbol': {
      0:1,
      12:0
   },
   'town_font': defaults['font'],
   'town_lbl_clr': {
      0:'"#666666"',
      11:'0 0 0'
   },
   'town_lbl_ol_clr': defaults['lbl_ol_clr'],
   'town_lbl_ol_width':defaults['lbl_ol_width'],
   'town_lbl_size': {
      0:0,
      8:8,
      10:9,
      12:10,
      15:11
   },
   'town_size': {
      0:0,
      8:2,
      10:3
   },
   'town_ol_clr': {
      0:'"#000000"'
   },
   'town_clr': {
      0:'200 200 200'
   },
   'village_font': defaults['font'],
   'village_lbl_clr': {
      0:'"#444444"',
      13:'0 0 0'
   },
   'village_lbl_ol_clr': defaults['lbl_ol_clr'],
   'village_lbl_ol_width':defaults['lbl_ol_width'],
   'display_villages': {
      0:0,
      11:1
   },
   'display_village_symbol': {
      0:1,
      14:0
   },
   'village_lbl_size': {
      0:0,
      10:8,
      13:9,
      15:10
   },
   'village_size': {
      0:0,
      11:2,
      13:3
   },
   'village_ol_clr': {
      0:'"#000000"'
   },
   'village_clr': {
      0:"200 200 200"
   },


   'hamlet_font': defaults['font'],
   'hamlet_lbl_clr': {
      0:'"#444444"',
      15:'0 0 0'
   },
   'hamlet_lbl_ol_clr': defaults['lbl_ol_clr'],
   'hamlet_lbl_ol_width': defaults['lbl_ol_width'],
   'display_hamlets': {
      0:0,
      13:1
   },
   'display_hamlet_symbol': {
      0:1,
   },
   'hamlet_lbl_size': {
      0:0,
      13:8,
      15:9,
   },
   'hamlet_size': {
      0:3
   },
   'hamlet_ol_clr': {
      0:'"#000000"'
   },
   'hamlet_clr': {
      0:"200 200 200"
   }

}

import sys

if sys.argv[1] == "-s":
   print "###### level 0 ######"
   for k,v in vars.iteritems():
      print "#define _%s0 %s"%(k,v[0])

   for i in range(1,19):
      print
      print "###### level %d ######"%(i)
      for k,v in vars.iteritems():
         if not v.has_key(i):
            print "#define _%s%d _%s%d"%(k,i,k,i-1)
         else:
            print "#define _%s%d %s"%(k,i,v[i])

if sys.argv[1] == "-l":
   level = sys.argv[2]
   for k,v in vars.iteritems():
      print "#undef _%s"%(k)

   for k,v in vars.iteritems():
      print "#define _%s _%s%s"%(k,k,level)
