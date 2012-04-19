# Copyright 2011 Omniscale (http://omniscale.com)
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from imposm.mapping import (
    Options,
    Points, LineStrings, Polygons,
    String, Bool, Integer, OneOfInt,
    set_default_name_type, LocalizedName,
    WayZOrder, ZOrder, Direction,
    GeneralizedTable, UnionView,
    PseudoArea, meter_to_mapunit, sqr_meter_to_mapunit,
)

# # internal configuration options
# # uncomment to make changes to the default values
# import imposm.config
# 
# # import relations with missing rings
# imposm.config.import_partial_relations = False
# 
# # select relation builder: union or contains
# imposm.config.relation_builder = 'contains'
# 
# # log relation that take longer than x seconds
# imposm.config.imposm_multipolygon_report = 60
# 
# # skip relations with more rings (0 skip nothing)
# imposm.config.imposm_multipolygon_max_ring = 0
# 
# # split ways that are longer than x nodes (0 to split nothing)
# imposm_linestring_max_length = 50


# set_default_name_type(LocalizedName(['name:en', 'int_name', 'name']))

db_conf = Options(
    # db='osm',
    host='localhost',
    port=5432,
    user='osm',
    password='osm',
    sslmode='allow',
    prefix='osm_new_',
    proj='epsg:3857',
)

class Highway(LineStrings):
    fields = (
        ('tunnel', Bool()),
        ('bridge', Bool()),
        ('oneway', Direction()),
        ('ref', String()),
        ('z_order', WayZOrder()),
    )
    field_filter = (
        ('area', Bool()),
    )

places = Points(
    name = 'places',
    mapping = {
        'place': (
            'country',
            'state',
            'region',
            'county',
            'city',
            'town',
            'village',
            'hamlet',
            'suburb',
            'locality',
        ),
    },
    fields = (
        ('z_order', ZOrder([
            'country',
            'state',
            'region',
            'county',
            'city',
            'town',
            'village',
            'hamlet',
            'suburb',
            'locality',
        ])),
        ('population', Integer()),
    ),
)

admin = Polygons(
    name = 'admin',
    mapping = {
        'boundary': (
            'administrative',
        ),
    },
    fields = (
        ('admin_level', OneOfInt('1 2 3 4 5 6'.split())),
    ),
)

roads = Highway(
    name = 'roads',
    mapping = {
        'highway': (
            'motorway',
            'motorway_link',
            'trunk',
            'trunk_link',
            'primary',
            'primary_link',
            'secondary',
            'secondary_link',
            'tertiary',
            'road',
            'path',
            'track',
            'service',
            'footway',
            'bridleway',
            'cycleway',
            'steps',
            'pedestrian',
            'living_street',
            'unclassified',
            'residential',
        ),
    }
)

buildings = Polygons(
    name = 'buildings',
    mapping = {
        'building': (
            '__any__',
    )}
)

transport_points = Points(
    name = 'transport_points',
    fields = (
        ('ref', String()),
    ),
    mapping = {
        'highway': (
            'motorway_junction',
            'turning_circle',
            'bus_stop',
        ),
        'railway': (
            'station',
            'halt',
            'tram_stop',
            'crossing',
            'level_crossing',
            'subway_entrance',
        ),
        'aeroway': (
            'aerodome',
            'terminal',
            'helipad',
            'gate',
    )}
)

railways = LineStrings(
    name = 'railways',
    fields = (
        ('tunnel', Bool()),
        ('bridge', Bool()),
        # ('ref', String()),
        ('z_order', WayZOrder()),
    ),
    mapping = {
        'railway': (
            'rail',
            'tram',
            'light_rail',
            'subway',
            'narrow_gauge',
            'preserved',
            'funicular',
            'monorail',
    )}
)

waterways = LineStrings(
    name = 'waterways',
    mapping = {
        'waterway': (
            'stream',
            'river',
            'canal',
            'drain',
    )},
    field_filter = (
        ('tunnel', Bool()),
    ),
)

waterareas = Polygons(
    name = 'waterareas',
    mapping = {
        'waterway': ('riverbank',),
        'natural': ('water',),
        'landuse': ('basin', 'reservoir'),
})

aeroways = LineStrings(
    name = 'aeroways',
    mapping = {
        'aeroway': (
            'runway',
            'taxiway',
    )}
)

transport_areas = Polygons(
    name = 'transport_areas',
    mapping = {
        'railway': (
            'station',
        ),
        'aeroway': (
            'aerodome',
            'terminal',
            'helipad',
            'apron',
        ),
})

landusages = Polygons(
    name = 'landusages',
    fields = (
        ('area', PseudoArea()),
        ('z_order', ZOrder([
            'pedestrian',
            'footway',
            'playground',
            'park',
            'forest',
            'cemetery',
            'farmyard',
            'farm',
            'farmland',
            'wood',
            'meadow',
            'grass',
            'village_green',
            'recreation_ground',
            'garden',
            'sports_centre',
            'pitch',
            'common',
            'allotments',
            'golf_course',
            'university',
            'school',
            'college',
            'library',
            'fuel',
            'parking',
            'nature_reserve',
            'cinema',
            'theatre',
            'place_of_worship',
            'hospital',
            'scrub',
            'quarry',
            'residential',
            'retail',
            'commercial',
            'industrial',
            'railway',
            'land',
        ])),
    ),
    mapping = {
        'landuse': (
            'park',
            'forest',
            'residential',
            'retail',
            'commercial',
            'industrial',
            'railway',
            'cemetery',
            'grass',
            'farmyard',
            'farm',
            'farmland',
            'wood',
            'meadow',
            'village_green',
            'recreation_ground',
            'allotments',
            'quarry',
        ),
        'leisure': (
            'park',
            'garden',
            'playground',
            'golf_course',
            'sports_centre',
            'pitch',
            'stadium',
            'common',
            'nature_reserve',
        ),
        'natural': (
            'wood',
            'land',
            'scrub',
        ),
        'highway': (
            'pedestrian',
            'footway',
        ),
        'amenity': (
            'university',
            'school',
            'college',
            'library',
            'fuel',
            'parking',
            'cinema',
            'theatre',
            'place_of_worship',
            'hospital',
        ),
})

amenities = Points(
    name='amenities',
    mapping = {
        'amenity': (
            'university',
            'school',
            'library',
            'fuel',
            'hospital',
            'fire_station',
            'police',
            'townhall',
        ),
})

roads_gen1 = GeneralizedTable(
    name = 'roads_gen1',
    tolerance = meter_to_mapunit(50.0),
    origin = roads,
    where = "type in ('motorway','trunk','primary','secondary','tertiary')",
)
roads_gen0 = GeneralizedTable(
    name = 'roads_gen0',
    tolerance = meter_to_mapunit(200.0),
    origin = roads_gen1,
    where = "type in ('motorway','trunk','primary')",
)

railways_gen1 = GeneralizedTable(
    name = 'railways_gen1',
    tolerance = meter_to_mapunit(50.0),
    origin = railways,
)
railways_gen0 = GeneralizedTable(
    name = 'railways_gen0',
    tolerance = meter_to_mapunit(200.0),
    origin = railways_gen1,
)

landusages_gen00 = GeneralizedTable(
    name = 'landusages_gen00',
    tolerance = meter_to_mapunit(500.0),
    origin = landusages,
    where = "type='forest' and ST_Area(geometry)>%f" % sqr_meter_to_mapunit(10000000),
)

landusages_gen0 = GeneralizedTable(
    name = 'landusages_gen0',
    tolerance = meter_to_mapunit(200.0),
    origin = landusages,
    where = "type='forest' and ST_Area(geometry)>%f" % sqr_meter_to_mapunit(5000000),
)

landusages_gen1 = GeneralizedTable(
    name = 'landusages_gen1',
    tolerance = meter_to_mapunit(50.0),
    origin = landusages,
    where = "ST_Area(geometry)>%f" % sqr_meter_to_mapunit(100000),
)

waterways_gen0 = GeneralizedTable(
    name = 'waterways_gen0',
    tolerance = meter_to_mapunit(200.0),
    origin = waterways,
    where = "type='river'",
)

waterways_gen1 = GeneralizedTable(
    name = 'waterways_gen1',
    tolerance = meter_to_mapunit(50.0),
    origin = waterways,
)

waterareas_gen0 = GeneralizedTable(
    name = 'waterareas_gen0',
    tolerance = meter_to_mapunit(200.0),
    origin = waterareas,
    where = "ST_Area(geometry)>%f" % sqr_meter_to_mapunit(500000),
)

waterareas_gen1 = GeneralizedTable(
    name = 'waterareas_gen1',
    tolerance = meter_to_mapunit(50.0),
    origin = waterareas,
    where = "ST_Area(geometry)>%f" % sqr_meter_to_mapunit(50000),
)
