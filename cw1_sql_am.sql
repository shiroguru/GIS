create schema firma;

create role ksiegowosc;
grant usage on schema firma TO ksiegowosc;
grant select on all tables in SCHEMA "firma" TO ksiegowosc;

create table firma.pracownicy(id_pracownika SERIAL,imie varchar(20) not null,nazwisko varchar(40) not null,adres varchar(60) not null,telefon varchar(20) not null);
create table firma.godziny(id_godziny SERIAL,data date not null,liczba_godzin int not null,id_pracownika int not null);
create table firma.pensja_stanowisko(id_pensji serial not null,stanowisko varchar(40) not null,kwota decimal(6,2) not null);
create table firma.premia(id_premii serial not null,rodzaj varchar(40) not null,kwota decimal(6,2) not null);
create table firma.wynagrodzenie(id_wynagrodzenia serial not null,data date not null,id_pracownika int not null,id_godziny int not null,id_pensji int not null,id_premii int not null);

alter table firma.pracownicy add constraint pk_pracownicy primary key (id_pracownika);
alter table firma.godziny add constraint pk_godziny primary key (id_godziny);
alter table firma.pensja_stanowisko add constraint pk_pensji primary key (id_pensji);
alter table firma.premia add constraint pk_premia primary key(id_premii);
alter table firma.wynagrodzenie add constraint pk_wynagrodzenie primary key (id_wynagrodzenia);

create index id_index on firma.pracownicy using btree (nazwisko);

comment on table firma.pracownicy is 'dane o pracownikach';
comment on table firma.godziny is 'informacje o godzinach';
comment on table firma.pensja_stanowisko is 'informacje o stanowiskach i pensjach';
comment on table firma.premia is 'informacje o premiach';
comment on table firma.wynagrodzenie is 'informacje o wynagrodzeniach';

alter table firma.godziny add constraint godziny_pracownicy foreign key (id_pracownika) references firma.pracownicy (id_pracownika) on delete cascade on update cascade;
alter table firma.wynagrodzenie add constraint wynagrodzenie_godziny foreign key (id_godziny) references firma.godziny (id_godziny) on delete cascade on update cascade;
alter table firma.wynagrodzenie add constraint wynagrodzenie_pracownicy foreign key (id_pracownika) references firma.pracownicy (id_pracownika) on delete cascade on update cascade;
alter table firma.wynagrodzenie add constraint wynagrodzenie_pensja_stanowisko foreign key (id_premii) references firma.pensja_stanowisko (id_pensji) on delete cascade on update cascade;
alter table firma.wynagrodzenie add constraint wynagrodzenie_premia foreign key (id_premii) references firma.premia (id_premii) on delete cascade on update cascade;

alter table firma.godziny add miesiac int not null;
alter table firma.godziny add tydzien int not null;
alter table firma.wynagrodzenie alter column "data" type varchar(20);
alter table firma.premia alter column rodzaj drop not null;
alter table firma.wynagrodzenie alter column id_premii drop not null;

insert into firma.pracownicy (imie, nazwisko, adres, telefon) values ('Adam','Madej','Pastelowa 15','878999231');
insert into firma.pracownicy (imie, nazwisko, adres, telefon) values ('Damian','Stoklos','Moniuszki 11','754212233');
insert into firma.pracownicy (imie, nazwisko, adres, telefon) values ('Natalia','Nowak','Sikorskiego 15','343212667');
insert into firma.pracownicy (imie, nazwisko, adres, telefon) values ('Maksymilian','Pukielski','Mickiewicza 234/1','989777333');
insert into firma.pracownicy (imie, nazwisko, adres, telefon) values ('Klaudia','Czopek','Korabnicka 2','434569877');
insert into firma.pracownicy (imie, nazwisko, adres, telefon) values ('Wojciech','Syrek','Franiszkanska 144','665892354');
insert into firma.pracownicy (imie, nazwisko, adres, telefon) values ('Wojciech','Czopek','Gawron 2','232454654');
insert into firma.pracownicy (imie, nazwisko, adres, telefon) values ('Aleksander','Madej','Azory 12','889743223');
insert into firma.pracownicy (imie, nazwisko, adres, telefon) values ('Justyna','Mazurek','Mazowiecka 23','223456756');
insert into firma.pracownicy (imie, nazwisko, adres, telefon) values ('Marcelina','Baranowicz','Sikorskiego 2','878966231');
insert into firma.pracownicy (imie, nazwisko, adres, telefon) values ('Andrzej','Biedak','Wyspianskiego 2','123453987');

insert into firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) values ('2020-04-01','160','1',extract(month from date '2020-04-01'),extract(week from date '2020-04-01'));
insert into firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) values ('2019-04-02','168','2',extract(month from date '2019-04-02'),extract(week from date '2019-04-02'));
insert into firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) values ('2019-04-01','170','3',extract(month from date '2019-04-01'),extract(week from date '2019-04-01'));
insert into firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) values ('2019-04-01','160','4',extract(month from date '2019-04-01'),extract(week from date '2019-04-01'));
insert into firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) values ('2019-04-10','178','5',extract(month from date '2019-04-10'),extract(week from date '2019-04-10'));
insert into firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) values ('2019-04-03','158','6',extract(month from date '2019-04-03'),extract(week from date '2019-04-03'));
insert into firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) values ('2019-04-12','90','7',extract(month from date '2019-04-12'),extract(week from date '2019-04-12'));
insert into firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) values ('2019-04-02','160','8',extract(month from date '2019-04-02'),extract(week from date '2019-04-02'));
insert into firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) values ('2019-04-01','160','9',extract(month from date '2019-04-01'),extract(week from date '2019-04-01'));
insert into firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) values ('2019-04-10','160','10',extract(month from date '2019-04-10'),extract(week from date '2019-04-10'));
insert into firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) values ('2019-04-10','100','11',extract(month from date '2019-04-10'),extract(week from date '2019-04-10'));

insert into firma.pensja_stanowisko (stanowisko, kwota) values ('SOC Specialist',6000);
insert into firma.pensja_stanowisko (stanowisko, kwota) values ('IAM Specialist',5000);
insert into firma.pensja_stanowisko (stanowisko, kwota) values ('Physical Security Specialist',5000);
insert into firma.pensja_stanowisko (stanowisko, kwota) values ('Big Data Specialist',8000);
insert into firma.pensja_stanowisko (stanowisko, kwota) values ('HR Specialist',6000);
insert into firma.pensja_stanowisko (stanowisko, kwota) values ('Project Manager',9000);
insert into firma.pensja_stanowisko (stanowisko, kwota) values ('Praktykant',1500);
insert into firma.pensja_stanowisko (stanowisko, kwota) values ('Dyrektor Departamentu',9500);
insert into firma.pensja_stanowisko (stanowisko, kwota) values ('Project Coordinator',6000);
insert into firma.pensja_stanowisko (stanowisko, kwota) values ('Java Programmer',9000);

insert into firma.premia (rodzaj,kwota) values ('uznaniowa','500');
insert into firma.premia (rodzaj,kwota) values ('uznaniowa','1000');
insert into firma.premia (rodzaj,kwota) values ('uznaniowa','5000');
insert into firma.premia (rodzaj,kwota) values ('caloroczna','5000');
insert into firma.premia (rodzaj,kwota) values ('caloroczna','7000');
insert into firma.premia (rodzaj,kwota) values ('caloroczna','9000');
insert into firma.premia (rodzaj,kwota) values ('regulaminowa','1000');
insert into firma.premia (rodzaj,kwota) values ('regulaminowa','2000');
insert into firma.premia (rodzaj,kwota) values ('regulaminowa','3000');
insert into firma.premia (rodzaj,kwota) values ('motywacyjna','5000');
insert into firma.premia (rodzaj,kwota) values ('brak','0');

insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-22','1','1','3','9');
insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-22','2','2','3','9');
insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-42','3','3','1','2');
insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-42','4','4','2','2');
insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-42','5','5','10','5');
insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-42','5','5','10','5');
insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-26','6','6','7','4');
insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-26','7','7','9','4');
insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-28','8','8','6','1');
insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-28','9','9','5','8');
insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-28','10','10','5','9');
insert into firma.wynagrodzenie (data,id_pracownika,id_godziny,id_pensji,id_premii) values ('2019-03-30','11','11','7','11');

select id_pracownika, nazwisko from firma.pracownicy;
select wynagrodzenie.id_pracownika from firma.wynagrodzenie inner join firma.pensja_stanowisko on pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji inner join firma.premia on premia.id_premii = wynagrodzenie.id_premii where premia.kwota+pensja_stanowisko.kwota>2000;
select wynagrodzenie.id_pracownika from firma.wynagrodzenie inner join firma.pensja_stanowisko on pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji inner join firma.premia on premia.id_premii = wynagrodzenie.id_premii where premia.kwota and pensja_stanowisko.kwota>2000;
select imie,nazwisko,adres,telefon from firma.pracownicy where imie like 'J%';
select imie,nazwisko,adres,telefon from firma.pracownicy where nazwisko like 'M%' and imie like 'A%';
select pracownicy.imie, pracownicy.nazwisko, case when godziny.liczba_godzin<160 then 0 else godziny.liczba_godzin-160 end as "nadgodziny" from firma.pracownicy inner join firma.godziny godziny on pracownicy.id_pracownika = godziny.id_pracownika;
select pracownicy.imie, pracownicy.nazwisko from firma.pracownicy inner join firma.wynagrodzenie on wynagrodzenie.id_pracownika = pracownicy.id_pracownika inner join firma.pensja_stanowisko on wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji where pensja_stanowisko.kwota >= 1500 and pensja_stanowisko.kwota <= 3000;
select pracownicy.imie, pracownicy.nazwisko from firma.pracownicy inner join firma.godziny on pracownicy.id_pracownika = godziny.id_pracownika inner join firma.wynagrodzenie on pracownicy.id_pracownika = wynagrodzenie.id_pracownika inner join firma.premia on wynagrodzenie.id_premii = premia.id_premii where premia.kwota = 0 and godziny.liczba_godzin > 160;
select pracownicy.*, pensja_stanowisko.kwota from firma.pracownicy inner join firma.wynagrodzenie on pracownicy.id_pracownika = wynagrodzenie.id_pracownika inner join firma.pensja_stanowisko on pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji order by pensja_stanowisko.kwota;
select pracownicy.*, pensja_stanowisko.kwota+premia.kwota as "pensja i premia" from firma.pracownicy inner join firma.wynagrodzenie on pracownicy.id_pracownika = wynagrodzenie.id_pracownika inner join firma.pensja_stanowisko on pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji inner join firma.premia on premia.id_premii = wynagrodzenie.id_premii order by pensja_stanowisko.kwota+premia.kwota desc;
select pensja_stanowisko.stanowisko, count(pensja_stanowisko.stanowisko) from firma.pensja_stanowisko inner join firma.wynagrodzenie on pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji inner join firma.pracownicy on pracownicy.id_pracownika = wynagrodzenie.id_pracownika group by pensja_stanowisko.stanowisko;
select pensja_stanowisko.stanowisko, avg(pensja_stanowisko.kwota+premia.kwota), min(pensja_stanowisko.kwota+premia.kwota), max(pensja_stanowisko.kwota+premia.kwota) from firma.pensja_stanowisko inner join firma.wynagrodzenie on pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji inner join firma.premia on premia.id_premii = wynagrodzenie.id_premii where pensja_stanowisko.stanowisko = 'HR Specialist' group by pensja_stanowisko.stanowisko;
select sum(pensja_stanowisko.kwota+premia.kwota) as "Suma wszystkich wynagrodzeń" from firma.wynagrodzenie inner join firma.pensja_stanowisko on wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji inner join firma.premia on wynagrodzenie.id_premii = premia.id_premii;
select pensja_stanowisko.stanowisko, sum(pensja_stanowisko.kwota+premia.kwota) as "Kwota za poszczegolne stanowiska" from firma.wynagrodzenie inner join firma.pensja_stanowisko on wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji inner join firma.premia on wynagrodzenie.id_premii = premia.id_premii group by pensja_stanowisko.stanowisko;
select pensja_stanowisko.stanowisko, count(premia.kwota>0) as "Ilosc premii" from firma.pensja_stanowisko inner join firma.wynagrodzenie on pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji inner join firma.premia on premia.id_premii = wynagrodzenie.id_premii where premia.kwota > 0 group by pensja_stanowisko.stanowisko;
delete from firma.pracownicy using firma.wynagrodzenie, firma.pensja_stanowisko where pracownicy.id_pracownika = wynagrodzenie.id_pracownika and pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji and pensja_stanowisko.kwota < 1600;
update firma.pracownicy set telefon=concat('(+48) ', telefon);
update firma.pracownicy set telefon=concat(substring(telefon, 1, 9), '-', substring(telefon, 10, 3), '-', substring(telefon, 13, 3));
select imie, upper(nazwisko) as "nazwisko", adres, telefon from firma.pracownicy where length(nazwisko) = (select max(length(nazwisko)) from firma.pracownicy);
select md5(pracownicy.imie) as "imie", md5(pracownicy.nazwisko) as "nazwisko", md5(pracownicy.adres) as "adres", md5(pracownicy.telefon) as "telefon", md5(cast(pensja_stanowisko.kwota as varchar(20))) as "pensja" from firma.pracownicy inner join firma.wynagrodzenie on wynagrodzenie.id_pracownika = pracownicy.id_pracownika inner join firma.pensja_stanowisko on pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji;
select concat('Pracownik ', pracownicy.imie, ' ', pracownicy.nazwisko, ', w dniu ', wynagrodzenie."data", ' otrzymał pensję całkowitą na kwotę ', pensja_stanowisko.kwota+premia.kwota,'zł, gdzie wynagrodzenie zasadnicze wynosiło: ', pensja_stanowisko.kwota, 'zł, premia: ', premia.kwota, 'zł.') as "raport" from firma.pracownicy inner join firma.wynagrodzenie on pracownicy.id_pracownika = wynagrodzenie.id_pracownika inner join firma.pensja_stanowisko on pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji inner join firma.premia on premia.id_premii = wynagrodzenie.id_premii;