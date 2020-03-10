#!/usr/bin/env python
import sys
from optparse import OptionParser
import yaml;


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

# these are the preconfigured styles that can be called when creating the final mapfile,
# e.g. with `make STYLE=google`. This will create an osm-google.map mapfile
style_aliases = {

   # map with no road casing and few colors, suited for using as a basemap when overlaying
   # other layers without risk of confusion between layers.
   "default":"default",

   # a style resembling the google-maps theme
   "google":"default,outlined,google",

   # same style as above, but using data coming from an osm2pgsql schema rather than imposm
   "googleosm2pgsql":"default,outlined,google,osm2pgsql",
   "bing":"default,outlined,bing",
   "michelin":"default,outlined,centerlined,michelin"
}


parser = OptionParser()
parser.add_option("-l", "--level", dest="level", type="int", action="store", default=-1,
                  help="generate file for level n")
parser.add_option("-g", "--global", dest="full", action="store_true", default=False,
                  help="generate global include file")
parser.add_option("-s", "--style",
                  action="store", dest="style", default="default",
                  help="comma separated list of styles to apply (order is important)")

(options, args) = parser.parse_args()

items = []
for namedstyle in style_aliases[options.style].split(','):
   stream = file('styles/' + namedstyle + '.yaml','r')
   items = items + yaml.load(stream).items()

style = dict(items)

if options.full:
   print "###### level 0 ######"
   for k,v in style.iteritems():
      if type(v) is dict:
         print "#define _%s0 %s"%(k,v[0])
      else:
         print "#define _%s0 %s"%(k,v)


   for i in range(1,19):
      print
      print "###### level %d ######"%(i)
      for k,v in style.iteritems():
         if type(v) is dict:
            if not v.has_key(i):
               print "#define _%s%d _%s%d"%(k,i,k,i-1)
            else:
               print "#define _%s%d %s"%(k,i,v[i])
         else:
            print "#define _%s%d %s"%(k,i,v)

if options.level != -1:
   level = options.level
   for k,v in style.iteritems():
      print "#undef _%s"%(k)

   for k,v in style.iteritems():
      print "#define _%s _%s%s"%(k,k,level)
