#!/usr/bin/env python
vars= {
         'maxscale': {
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
         },
         'minscale': {
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
         },
         'motorway_clr': {
            0:'"#ffffff"'
         },
         'motorway_width': {
            0:1,
            1:0.5
         },
         'motorway_lbl_clr': {
            0:'"#ffffff"'
         },
         'trunk_clr': {
            0:'"#ffffff"'
         },
         'trunk_width': {
            0:'"#ffffff"'
         },
         'trunk_lbl_clr': {
            0:'"#ffffff"'
         },
         'primary_clr': {
            0:'"#ffffff"'
         },
         'primary_width': {
            0:'"#ffffff"'
         },
         'primary_lbl_clr': {
            0:'"#ffffff"'
         },
         'secondary_clr': {
            0:'"#ffffff"'
         },
         'secondary_width': {
            0:'"#ffffff"'
         },
         'secondary_lbl_clr': {
            0:'"#ffffff"'
         },
         'tertiary_clr': {
            0:'"#ffffff"'
         },
         'tertiary_width': {
            0:'"#ffffff"'
         },
         'tertiary_lbl_clr': {
            0:'"#ffffff"'
         },
         'other_clr': {
            0:'"#ffffff"'
         },
         'other_width': {
            0:'"#ffffff"'
         },
         'other_lbl_clr': {
            0:'"#ffffff"'
         },
         'pedestrian_clr': {
            0:'"#ffffff"'
         },
         'pedestrian_width': {
            0:'"#ffffff"'
         },
         'pedestrian_lbl_clr': {
            0:'"#ffffff"'
         },
         'track_clr': {
            0:'"#ffffff"'
         },
         'track_width': {
            0:'"#ffffff"'
         },
         'track_lbl_clr': {
            0:'"#ffffff"'
         },
         'path_clr': {
            0:'"#ffffff"'
         },
         'path_width': {
            0:'"#ffffff"'
         },
         'path_lbl_clr': {
            0:'"#ffffff"'
         },
         'railway_clr': {
            0:'"#ffffff"'
         },
         'railway_width': {
            0:'"#ffffff"'
         },
         'railway_inner_clr': {
            0:'"#ffffff"'
         },
         'railway_inner_width': {
            0:'"#ffffff"'
         },
         'railway_inner_pattern': {
            0:'"#ffffff"'
         },
         'landusage_data': {
            0:'"geometry from (select geometry ,osm_id, type, name from OSM_PREFIX_landusages \
                where type in (\'forest\',\'residential\')\
                order by z_order asc) as foo using unique osm_id using srid=OSM_SRID"',
            6:'"geometry from (select geometry ,osm_id, type, name from OSM_PREFIX_landusages \
                where type in (\'forest\',\'pedestrian\',\'cemetery\',\'industrial\',\'commercial\',\
                \'brownfield\',\'residential\',\'school\',\'college\',\'university\',\
                \'military\',\'park\',\'golf_course\',\'hospital\',\'parking\')\
                order by z_order asc) as foo using unique osm_id using srid=OSM_SRID"'
         },
         'border_data': {
            0: '"geometry from (select id,geometry,admin_level from osm_boundaries where admin_level<=2)as foo using unique id using srid=4326"',
            6: '"geometry from (select id,geometry,admin_level from osm_boundaries where admin_level<=4)as foo using unique id using srid=4326"',
            7: '"geometry from (select id,geometry,admin_level from osm_boundaries where admin_level<=6)as foo using unique id using srid=4326"',
            10:'"geometry from (select id,geometry,admin_level from osm_boundaries where admin_level<=8)as foo using unique id using srid=4326"'
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
            0:'5'
         },
         'border_2_inner_clr': {
            0:'"#CDCBC6"',
            4:'"#8d8b8d"'
         },
         'border_2_inner_width': {
            0:'0.5',
            4:'1'
         },
         'border_2_inner_pattern': {
            0:''
         },
         'display_border_4': {
            0:0,
            6:1
         },
         'display_border_4_outer': {
            0:0,
            7:1
         },
         'border_4_clr': {
            0:'"#CDCBC6"'
         },
         'border_4_width': {
            0:'5',
            8:'6'
         },
         'border_4_inner_clr': {
            0:'"#8d8b8d"'
         },
         'border_4_inner_width': {
            0:'0.5',
            7:'1'
         },
         'border_4_inner_pattern': {
            0:'',
            7:'PATTERN 2 2 END'
         },
         'display_border_6': {
            0:0,
            7:1
         },
         'display_border_6_outer': {
            0:0,
            8:1
         },
         'border_6_clr': {
            0:'"#CDCBC6"'
         },
         'border_6_width': {
            0:'5',
            13:'7'
         },
         'border_6_inner_clr': {
            0:'"#8d8b8d"'
         },
         'border_6_inner_width': {
            0:'0.5',
            8:1
         },
         'border_6_inner_pattern': {
            0:'',
            8:'PATTERN 2 2 END'
         },
         'display_border_8': {
            0:0,
            11:1
         },
         'display_border_8_outer': {
            0:0,
            13:1
         },
         'border_8_clr': {
            0:'"#CDCBC6"'
         },
         'border_8_width': {
            0:'5'
         },
         'border_8_inner_clr': {
            0:'"#8d8b8d"'
         },
         'border_8_inner_width': {
            0:'0.5',
            14:'1'
         },
         'border_8_inner_pattern': {
            0:'',
            13:'PATTERN 2 2 END'
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
