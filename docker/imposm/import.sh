#!/bin/bash -ex

psql -c 'DROP SCHEMA IF EXISTS import CASCADE;'
psql -c 'DROP SCHEMA IF EXISTS backup CASCADE;'
(cat <<EOF
DO \$\$ DECLARE
    tabname RECORD;
BEGIN
    FOR tabname IN (SELECT * FROM pg_tables WHERE schemaname = 'public' and tablename LIKE 'osm_%')
LOOP
    EXECUTE 'DROP TABLE IF EXISTS public.' || quote_ident(tabname.tablename) || ' CASCADE';
END LOOP;
END \$\$;
EOF
) | psql

OPTIONS="-connection $IMPOSM_CONNECTION"
OPTIONS="$OPTIONS -mapping /settings/basemaps-mapping.json"

cd /data
first_pbf=true
for url in $PBF_FILES; do
    filename=$(basename $url)
    if [ ! -f /data/$filename ]
    then
        curl "$url" -o /data/$filename
    fi
    if [ "$first_pbf" = true ] ; then
        imposm import $OPTIONS -overwritecache -read /data/$filename
    else
        imposm import $OPTIONS -appendcache -read /data/$filename
    fi
    rm -f /data/$filename
    first_pbf=false
done

imposm import $OPTIONS -write
imposm import $OPTIONS --dbschema-production=prod -deployproduction
