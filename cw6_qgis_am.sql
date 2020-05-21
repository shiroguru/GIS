-- //zadanie 1
Filtry:
"VEGDESC"='Deciduous';
"VEGDESC"='Evergreen';
"VEGDESC"='Mixed Trees';
SQL:
select sum(st_area(geometry)) from trees where trees.VEGDESC='Mixed Trees';

-- //zadanie 2
osobne pliki: zad2_deci, zad2_ever i zad2_mixed

-- //zadanie 3
select sum(st_length(railroads.geometry)) from regions, railroads where regions.name_2='Matanuska-Susitna';

-- //zadanie 4
select avg(airports.elev) from airports where airports.use='Military';
select count( * ) from airports where airports.use='Military';
Filtr:
use='Military' and elev>1400
Jedno - przefiltrowane i usunięte w trybie edycji

-- //zadanie 5
select * from popp, regions where regions.NAME_2='Bristol Bay' and popp.F_CODEDESC='Building' and contains(regions.geometry, popp.geometry);
select count(*) from popp, regions where popp.F_CODEDESC='Building' and regions.NAME_2='Bristol Bay' and contains(regions.geometry, popp.geometry);

-- //zadanie 6
select count(*)  from zad6_przecina;

-- //zadanie 7
select count(*)  from zad7_wezel;

-- //zadanie 8


-- //zadanie 9
select( select count(*) from zad9_wierzcholki) - ( select count(*) from zad9_wierzcholki_uproszcz);
select( select st_area(geometry) from swamp) - ( select st_area(geometry) from zad9_uproszczone); //pole uproszczone wzroslo o ponad 50k
