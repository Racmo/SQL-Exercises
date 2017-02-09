--1
select nazwisko, etat, id_zesp
from pracownicy
where id_zesp = 
 (select id_zesp from pracownicy where nazwisko = 'BRZEZINSKI')
order by nazwisko;

--2
select nazwisko, etat, zatrudniony  
from pracownicy  
where zatrudniony = (
	select min(zatrudniony)
        from pracownicy
        where etat='PROFESOR'
        group by etat
) 
and etat='PROFESOR';

--3
select nazwisko, zatrudniony, id_zesp
from pracownicy
where (zatrudniony, id_zesp) in --sprytne :D
(
select max(zatrudniony), id_zesp from pracownicy
group by id_zesp
)
order by zatrudniony;

--4
select id_zesp, nazwa, adres
from zespoly
where id_zesp not in --znowu sprytne
( select distinct id_zesp from pracownicy );

--5
select p1.nazwisko, p1.placa_pod, p1.etat
from pracownicy p1
where placa_pod > 
(select avg(p2.placa_pod) from pracownicy p2
group by p2.etat
having p1.etat = p2.etat);

--6
select p.nazwisko, p.placa_pod from pracownicy p
where p.placa_pod >=
0.75*(select s.placa_pod from pracownicy s
where s.id_prac = p.id_szefa
);

--7
select p.nazwisko from pracownicy p
where etat='PROFESOR' and 
p.id_prac not in(
	select s.id_szefa from pracownicy s 
	where s.etat='STAZYSTA');

--8
select z.id_zesp, z.nazwa, z.adres from zespoly z
where z.id_zesp not in(
	select p.id_zesp from pracownicy p
	group by p.id_zesp
	having p.id_zesp=z.id_zesp);
--drugi sposób:
select z.id_zesp, z.nazwa, z.adres from zespoly z
where not exists(
	select p.id_zesp from pracownicy p
	where p.id_zesp = z.id_zesp);

--9
select p.id_zesp, sum(p.placa_pod) from pracownicy p
having sum(p.placa_pod) =(
	select max(sum(pp.placa_pod)) from pracownicy pp
	group by pp.id_zesp)
group by p.id_zesp;
	
--10
select p.nazwisko, p.placa_pod from pracownicy p 
where 
( select count (*) from pracownicy pp
where pp.placa_pod > p.placa_pod) < 3
order by p.placa_pod desc;

--11
select extract(year from(p.zatrudniony)) as "ROK", count(p.id_prac) from pracownicy p
group by extract(year from(p.zatrudniony))
order by count(p.id_prac) desc;

--12
select extract(year from(p.zatrudniony)) as "ROK", count(p.id_prac) from pracownicy p
group by extract(year from(p.zatrudniony))

having count(p.id_prac) = (
select max(count(pp.id_prac)) from pracownicy pp
group by extract(year from(pp.zatrudniony))
)

order by count(p.id_prac) desc;

--13
select p.nazwisko, p.etat, p.placa_pod, z.nazwa 
from pracownicy p join zespoly z on p.id_zesp = z.id_zesp
where p.placa_pod < (
select avg(x.placa_pod) from pracownicy x 
group by x.etat
having x.etat = p.etat)
order by p.placa_pod desc;

--14
select p.nazwisko, p.etat, p.placa_pod, 
(select avg(x.placa_pod) from pracownicy x 
group by x.etat
having x.etat = p.etat) as "avg sralalala"

from pracownicy p 
where p.placa_pod < (
	select avg(x.placa_pod) from pracownicy x 
	group by x.etat
	having x.etat = p.etat)
order by p.placa_pod desc;

--15 
select p.nazwisko, 
(select count(pp.id_prac) 
from pracownicy pp
where pp.id_szefa = p.id_prac
group by pp.id_szefa) as "PODWLADNI"
from pracownicy p
where etat='PROFESOR' and
p.id_zesp in (
select x.id_zesp from zespoly x where x.adres = 'PIOTROWO 3A');


--16
select p.nazwisko,
(select avg(p2.placa_pod) from pracownicy p2 
group by p2.id_zesp
having p2.id_zesp = p.id_zesp) as "SREDNIA",

(select max(p3.placa_pod) from pracownicy p3) as "MAKSYMALNA"

from pracownicy p 
where p.etat = 'PROFESOR';

--17
select p.nazwisko,
( select z.nazwa from zespoly z 
where p.id_zesp = z.id_zesp)
from pracownicy p;

--18
with 
piotrowo as (select * from zespoly where adres= 'PIOTROWO 3A'),
asystenci as (select * from pracownicy where etat = 'ASYSTENT')
select a.nazwisko, a.etat, p.nazwa, p.adres
from asystenci a natural join piotrowo p;

--19
select nazwisko, id_prac, id_szefa, LEVEL
from pracownicy 
connect by prior id_prac=id_szefa
start with nazwisko='BRZEZINSKI' ;



