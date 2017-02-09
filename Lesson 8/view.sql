--SQL Perspektywy 
--1
create view asystenci2 (id, nazwisko, placa, staż_pracy)
as select
id_prac, nazwisko, placa_pod, 
'lat: ' || extract(year from(sysdate - zatrudniony)year to month)||', miesiecy: ' ||
extract(month from(sysdate-zatrudniony)year to month)
from pracownicy where etat='ASYSTENT';

select * from asystenci2;
drop view asystenci2;

--2
create view place2(id_zesp, srednia, minimum, maximum, fundusz, l_pensji, l_dodatkow) as 
select p.id_zesp, 
avg(p.placa_pod + nvl(p.placa_dod,0)), min(p.placa_pod + nvl(p.placa_dod,0)),
max(p.placa_pod + nvl(p.placa_dod,0)),
sum(p.placa_pod + nvl(p.placa_dod,0)),
count(p.placa_pod),
count(p.placa_dod)
from pracownicy p 
group by p.id_zesp;

select * from place2 order by id_zesp;

--3
select p.nazwisko, p.placa_pod
from place2 p2 join pracownicy p on p.id_zesp = p2.id_zesp
where p.placa_pod + nvl(p.placa_dod, 0) < p2.srednia
order by p.nazwisko;

drop view place2;

--4
create view place_min2(id_prac, nazwisko, etat, placa_pod) as 
select id_prac, nazwisko, etat, placa_pod from pracownicy 
where placa_pod < 700 
with check option constraint za_wysoka_placa;

--5
update place_min2 
set(placa_pod)=800
where nazwisko='HAPKE'

drop view place_min2;

--6
create view prac_szef2(id_prac, id_szefa, pracownik, etat, szef)
as select
p.id_prac, p.id_szefa, p.nazwisko, p.etat, s.id_prac
from pracownicy p left join pracownicy s on p.id_szefa=s.id_prac;

--7
create view zarobki2(id_prac, nazwisko, etat, placa_pod)
as select
p.id_prac, p.nazwisko, p.etat, p.placa_pod
from pracownicy p
where placa_pod < (select s.placa_pod from pracownicy s where s.id_prac=p.id_szefa) 
with check option;

--8
select column_name, updatable, insertable, deletable from user_updatable_columns where table_name='PRAC_SZEF2';

--9
select nazwisko, placa_pod from 
(select * from pracownicy order by placa_pod desc)
where rownum <=3;

--10
--? jakieś to dzikie
