--SQL Tworzenie tabel DDL
--1
create table projekty2 
(id_projektu number(4,0) constraint "PROJEKTY_PK2" primary key,
opis_projektu varchar2(20) constraint "PROJEKTY_UK2" unique not null,
data_rozpoczecia date default sysdate,
data_zakonczenia date,
constraint "PROJEKTY_DATY_CHK2" check(data_rozpoczecia < data_zakonczenia),
fundusz number(7,2) constraint "PROJEKTY_FUNDUSZ_CHK2" check(fundusz >=0)
); 

describe projekty2;


create table przydzialy2(
id_projektu number(4) constraint "PRZYDZIALY_FK_012" references projekty2(id_projektu) not null,
nr_pracownika number(6) constraint "PRZYDZIALY_FK_022" references pracownicy(id_prac) not null,
od date default sysdate,
do date,
constraint "PRZYDZIALY_DATA_CHK2" check(od < do),
stawka number(7,2) constraint "PRZYDZIALY_STAWKA_CHK2" check(stawka>=0),
rola varchar2(20) constraint "PRZYDZIALY_ROLA_CHK2" check(rola in('KIERUJACY','ANALITYK','PROGRAMISTA')),
constraint "PRZYDZIALY_PK2" primary key(id_projektu, nr_pracownika)
);

describe przydzialy2;

--2
alter table przydzialy2 add(
godzina number(4) check(godzina <= 9999));

--3
comment on table przydzialy2 is 'Informacje o przydziale poszczególnych pracowników do projektów';

comment on table projekty2 is 'Lista projektów prowadzonych przez pracowników';

select * from user_tab_comments ;

--4
select constraint_name, search_condition from user_constraints
where table_name in('PRZYDZIALY2','PROJEKTY2');

--5
alter table projekty2
disable constraint "PROJEKTY_UK2";

--6
alter table projekty2
modify (opis_projektu varchar2(30));
--tutaj ograniczenie unique sie nie usunelo ale bylo disabled (moze to ma znaczenie?)

--7
create table pracownicy_zespoly2 as select
p.nazwisko, 
p.etat as "POSADA", 
12*(p.placa_pod + nvl(p.placa_dod,0)) as "ROCZNA_PLACA",
z.nazwa as "ZESPOL",
z.adres as "ADRES_PRACY"
from pracownicy p join zespoly z on z.id_zesp=p.id_zesp;

--8
alter table projekty2
enable constraint "PROJEKTY_UK2";

--
drop table przydzialy2;
drop table projekty2;
drop table pracownicy_zespoly2;
