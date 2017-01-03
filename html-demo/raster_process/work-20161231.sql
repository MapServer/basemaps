-- 31 dec 2016:
-- generate ramps from data

select min(price::float/surface::float), max(price::float/surface::float),
  avg(price::float/surface::float), min(st_z(geom)), max(st_z(geom))
from price_font;

-- 5 classes avec meme distribution
-- histogramme
-- count(*) / numclasses.

select id, st_z(geom)
from price_font;

with tmp as (
    select min(st_z(geom)), max(st_z(geom)), avg(st_z(geom))
    from price_font
) select width_bucket(st_z(geom), min, max, 5), count(*)
from price_font, tmp
group by 1
order by 1;

-- SQL histogram (from http://tapoueh.org/blog/2014/02/21-PostgreSQL-histogram) nice :)
with drb_stats as (
    select min(st_z(geom)) as min,
           max(st_z(geom)) as max
    from price_font
),
    histogram as (
      select width_bucket(st_z(geom), min, max, 9) as bucket,
             int4range(min(st_z(geom)::int), max(st_z(geom)::int), '[]') as range,
             count(*) as freq
      from price_font, drb_stats
      group by bucket
      order by bucket
  )
select bucket, range, freq,
  repeat('*', (freq::float / max(freq) over() * 30)::int) as bar
from histogram;


with tmp as (
    SELECT
      id,
      st_z(geom),
      ntile(4)
      OVER (
        ORDER BY st_z(geom))
    FROM price_font
) select id, ntile, count(*)
from tmp
GROUP BY 1;

-- values of classes:
with tmp as (
  SELECT id, st_z(geom) as val, row_number() over (order by st_z(geom)) as rn,
    (count(*) over()) as cnt
  FROM price_font
) select id, val, rn
from tmp t
where rn in(1) or (rn % floor(cnt/4)::int = 0);

SELECT
  id,
  st_z(geom),
  last_value(ntile(4))
  OVER (
    ORDER BY st_z(geom))
FROM price_font;

-- -- 01 janvier 2017:
-- add price_m2 col to price_font.
alter table price_font add COLUMN price_m2 int;
update price_font set price_m2 = price/surface;
VACUUM ANALYSE price_font;

with tmp as (
    select min(st_z(geom)), max(st_z(geom))
    from price_font
)
select array_to_json(
           array_agg(
               array[
               st_y(st_transform(geom, 4326)),
               st_x(st_transform(geom, 4326)),
               (st_z(geom) - t.min)/(t.max -t.min)
               ]
           )
       ) as price_json
from price_font b, tmp t;
