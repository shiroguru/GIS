create table airportsnew (name varchar(60), geometry blob, elev double))
insert into airportsnew select name, geometry, elev from airports
select mbrmaxy(geometry), name, elev from airportsnew limit 1
select mbrminy(geometry), name, elev from airportsnew limit 1
insert into airportsnew(name, geometry, elev) values('airportb', (0.5*distance ((select Geometry FROM airportsNew 
where name='noatak'),(select geometry from airportsnew 
where name='nikolski as') )), (select avg(elev) from airportsnew
where name="nikolski as" or name="noatak"));
select sum(area(intersection(tundra.geometry, trees.geometry))) as "tundra",
sum(area(intersection(swamp.geometry, trees.geometry))) as "bagna", vegdesc
from swamp, trees, tundra
group by vegdesc;

