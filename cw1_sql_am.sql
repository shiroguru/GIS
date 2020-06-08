raster2pgsql.exe -s 3763 -N -32767 -t 100x100 -I -C -M -d C:\Users\adamm\OneDrive\Pulpit\rasters\srtm_1arc_v3.tif rasters.dem | psql -d cw8_gis -h localhost -U postgres -p 5432
raster2pgsql.exe -s 3763 -N -32767 -t 128x128 -I -C -M -d C:\Users\adamm\OneDrive\Pulpit\rasters\Landsat8_L1TP_RGBN.TIF rasters.landsat8 | psql -d cw8_gis -h localhost -U postgres -p 5432

CREATE EXTENSION postgis;
CREATE EXTENSION postgis_raster;
CREATE EXTENSION postgis_topology;
CREATE EXTENSION postgis_sfcgal;
CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION postgis_tiger_geocoder;
CREATE EXTENSION address_standardizer;

//p1
CREATE TABLE schema_name.intersects AS
SELECT a.rast, b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto';
//p1.1
alter table schema_name.intersects
add column rid SERIAL PRIMARY KEY;
//p1.2
CREATE INDEX idx_intersects_rast_gist ON schema_name.intersects
USING gist (ST_ConvexHull(rast));
//p1.3
-- schema::name table_name::name raster_column::name
SELECT AddRasterConstraints('schema_name'::name, 'intersects'::name,'rast'::name);
//p2
CREATE TABLE schema_name.clip AS
SELECT ST_Clip(a.rast, b.geom, true), b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality like 'PORTO';
//p3
CREATE TABLE schema_name.union AS
SELECT ST_Union(ST_Clip(a.rast, b.geom, true))
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast);

//////////////// Rastry
//p1r
CREATE TABLE schema_name.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';
//p2r
DROP TABLE schema_name.porto_parishes; --> drop table porto_parishes first
CREATE TABLE schema_name.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';
//p3r
DROP TABLE schema_name.porto_parishes; --> drop table porto_parishes first
CREATE TABLE schema_name.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1 )
SELECT st_tile(st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)),128,128,true,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

//////////////// Wektoryzowanie
//p1we
create table schema_name.intersection as
SELECT a.rid,(ST_Intersection(b.geom,a.rast)).geom,(ST_Intersection(b.geom,a.rast)).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);
//p2we
CREATE TABLE schema_name.dumppolygons AS
SELECT a.rid,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).geom,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

//////////////// Analiza rastrów
//p1ar
CREATE TABLE schema_name.landsat_nir AS
SELECT rid, ST_Band(rast,4) AS rast
FROM rasters.landsat8;
//p2ar
CREATE TABLE schema_name.paranhos_dem AS
SELECT a.rid,ST_Clip(a.rast, b.geom,true) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);
//p3ar
CREATE TABLE schema_name.paranhos_slope AS
SELECT a.rid,ST_Slope(a.rast,1,'32BF','PERCENTAGE') as rast
FROM schema_name.paranhos_dem AS a;
//p4ar
CREATE TABLE schema_name.paranhos_slope_reclass AS
SELECT a.rid,ST_Reclass(a.rast,1,']0-15]:1, (15-30]:2, (30-9999:3', '32BF',0)
FROM schema_name.paranhos_slope AS a;
//p5ar
SELECT st_summarystats(a.rast) AS stats
FROM schema_name.paranhos_dem AS a;
//p6ar
SELECT st_summarystats(ST_Union(a.rast))
FROM schema_name.paranhos_dem AS a;
//p7ar
WITH t AS (
SELECT st_summarystats(ST_Union(a.rast)) AS stats
FROM schema_name.paranhos_dem AS a
)
SELECT (stats).min,(stats).max,(stats).mean FROM t;
//p8ar
WITH t AS (
SELECT b.parish AS parish, st_summarystats(ST_Union(ST_Clip(a.rast, b.geom,true))) AS stats
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
group by b.parish
)
SELECT parish,(stats).min,(stats).max,(stats).mean FROM t;
//p9ar
SELECT b.name,st_value(a.rast,(ST_Dump(b.geom)).geom)
FROM
rasters.dem a, vectors.places AS b
WHERE ST_Intersects(a.rast,b.geom)
ORDER BY b.name;
//p10ar
create table schema_name.tpi30 as
select ST_TPI(a.rast,1) as rast
from rasters.dem a;

CREATE INDEX idx_tpi30_rast_gist ON schema_name.tpi30
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_name'::name, 'tpi30'::name,'rast'::name);
//p10ar_wersja_2
create table schema_name.tpi30_porto as
SELECT ST_TPI(a.rast,1) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto';

CREATE INDEX idx_tpi30_rast_gist_p ON schema_name.tpi30
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_name'::name, 'tpi30'::name,'rast'::name);

//////////////// Algebra map
//p1am
CREATE TABLE schema_name.porto_ndvi AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, 1,
r.rast, 4,
'([rast2.val] - [rast1.val]) / ([rast2.val] + [rast1.val])::float','32BF'
) AS rast
FROM r;

CREATE INDEX idx_porto_ndvi_rast_gist ON schema_name.porto_ndvi
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_name'::name, 'porto_ndvi'::name,'rast'::name);
//p2am
create or replace function schema_name.ndvi(
value double precision [] [] [],
pos integer [][],
VARIADIC userargs text []
)
RETURNS double precision AS
$$
BEGIN
--RAISE NOTICE 'Pixel Value: %', value [1][1][1];-->For debug purposes
RETURN (value [2][1][1] - value [1][1][1])/(value [2][1][1]+value [1][1][1]); --> NDVI calculation!
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE COST 1000;

CREATE TABLE schema_name.porto_ndvi2 AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, ARRAY[1,4],
'schema_name.ndvi(double precision[], integer[],text[])'::regprocedure, --> This is the function!
'32BF'::text
) AS rast
FROM r;

CREATE INDEX idx_porto_ndvi2_rast_gist ON schema_name.porto_ndvi2
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_name'::name, 'porto_ndvi2'::name,'rast'::name);

//////////////// Eksport
//p1e
SELECT ST_AsTiff(ST_Union(rast))
FROM schema_name.porto_ndvi;

//p2e
SELECT ST_GDALDrivers();

SELECT ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
FROM schema_name.porto_ndvi;

//p3e
CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM schema_name.porto_ndvi;
----------------------------------------------
SELECT lo_export(loid, 'C:\Users\adamm\OneDrive\Pulpit\rasters\raster_am.tiff') --> Save the file in a place where the user postgres have access. In windows a flash drive usualy works fine.
FROM tmp_out;
----------------------------------------------
SELECT lo_unlink(loid)
FROM tmp_out; --> Delete the large object.

