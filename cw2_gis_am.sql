create table budynki (bud_id serial, bud_geo geometry, bud_naz varchar, bud_wys integer);
create table drogi (dro_id serial, dro_geo geometry, dro_naz varchar);
create table pktinfo (pkt_id serial, pkt_geo geometry, pkt_naz varchar, geo_licz integer);

insert into budynki (bud_id, bud_geo, bud_naz, bud_wys) values (1, ST_GeomFromText('POLYGON((8 4,8 1.5,10.5 1.5,10.5 4,8 4))',-1),'BuildingA',20);
insert into budynki (bud_id, bud_geo, bud_naz, bud_wys) values (2, ST_GeomFromText('POLYGON((4 7,4 5,6 5,6 7,4 7))',-1),'BuildingB',10);
insert into budynki (bud_id, bud_geo, bud_naz, bud_wys) values (3, ST_GeomFromText('POLYGON((3 8,3 6,5 6,5 8,3 8))',-1),'BuildingC',100);
insert into budynki (bud_id, bud_geo, bud_naz, bud_wys) values (4, ST_GeomFromText('POLYGON((9 9,9 8,10 8,10 9, 9 9))',-1),'BuildingD',20);
insert into budynki (bud_id, bud_geo, bud_naz, bud_wys) values (5, ST_GeomFromText('POLYGON((1 2,1 1,2 1,2 2,1 2))',-1),'BuildingF',40);


insert into pktinfo (pkt_id, pkt_geo, pkt_naz, geo_licz) values (1,ST_GeomFromText('POINT(1 3.5)',-1),'G',2);
insert into pktinfo (pkt_id, pkt_geo, pkt_naz, geo_licz) values (2,ST_GeomFromText('POINT(5.5 1.5)',-1),'H',3);
insert into pktinfo (pkt_id, pkt_geo, pkt_naz, geo_licz) values (3,ST_GeomFromText('POINT(9.5 6)',-1),'I',2);
insert into pktinfo (pkt_id, pkt_geo, pkt_naz, geo_licz) values (4,ST_GeomFromText('POINT(6.5 6)',-1),'J',2);
insert into pktinfo (pkt_id, pkt_geo, pkt_naz, geo_licz) values (5,ST_GeomFromText('POINT(6 9.5)',-1),'K',6);

insert into drogi (dro_id, dro_geo, dro_naz) values (1,ST_GeomFromText('LINESTRING(0 4.5,12 4.5)',-1),'RoadX');
insert into drogi (dro_id, dro_geo, dro_naz) values (2,ST_GeomFromText('LINESTRING(7.5 10.5,7.5 0)',-1),'RoadY');

select dro_naz, ST_Length(dro_geo) as drogaLen from drogi where dro_naz='RoadX';
select dro_naz, ST_Length(dro_geo) as drogaLen from drogi where dro_naz='RoadY';
select sum(ST_Length(dro_geo)) from drogi;

select bud_geo, ST_Area(bud_geo) as area, ST_Perimeter(bud_geo) as peri from budynki where bud_naz='BuildingA';

select bud_naz, ST_Area(bud_geo) from budynki order by bud_naz;

select bud_naz, ST_Perimeter(bud_geo) from budynki order by ST_Area(bud_geo) desc limit 2;

select ST_Length(ST_ShortestLine(budynki.bud_geo, pktinfo.pkt_geo)) as ShortestLine from budynki, pktinfo where budynki.bud_naz='BuildingC' and pktinfo.pkt_naz='G';

select ST_Area(ST_Difference(BuildingB.bud_geo,ST_Intersection(BuildingB.bud_geo, ST_Buffer(BuildingC.bud_geo, 0.5, 'join=mitre')))) FROM budynki BuildingB, budynki BuildingC WHERE BuildingB.bud_naz='BuildingB' AND BuildingC.bud_naz='BuildingC';

select budynki.* from budynki, drogi where drogi.dro_naz='RoadX' and ST_Centroid(budynki.bud_geo) |>> drogi.dro_geo;









