--SQL Joiny

--1
select p.nazwisko, p.etat, p.id_zesp, z.nazwa
from pracownicy p join zespoly z on p.id_zesp = z.id_zesp
order by nazwisko;

--2
select p.nazwisko, p.etat, p.id_zesp, z.nazwa
from pracownicy p join zespoly z on p.id_zesp = z.id_zesp
order by nazwisko;

--3
select p.nazwisko, z.adres, z.nazwa 
from pracownicy p join zespoly z on p.id_zesp = z.id_zesp
where p.placa_pod > 400
order by nazwisko;

--4
select p.nazwisko, p.placa_pod, p.etat, e.nazwa as "KAT_PLAC", e.placa_min as "PLAC_MIN", e.placa_max as "PLAC_MAX"
from pracownicy p join etaty e on p.etat = e.nazwa
order by nazwisko; 

--5
select p.nazwisko, p.placa_pod, p.etat, e.nazwa as "KAT_PLAC", e.placa_min, e.placa_max 
from pracownicy p join etaty e on p.placa_pod between e.placa_min and e.placa_max
where e.nazwa = 'SEKRETARKA'
order by p.placa_pod DESC;

--6
select p.nazwisko, p.etat, p.placa_pod, e.nazwa as "KAT_PLAC", z.nazwa
from pracownicy p join etaty e on p.etat = e.nazwa
join zespoly z on p.id_zesp = z.id_zesp
where not p.etat = 'ASYSTENT'
order by p.placa_pod DESC;

--7
select p.nazwisko, p.etat, 12*(p.placa_pod+nvl(p.placa_dod, 0)), z.nazwa, e.nazwa as "KAT_PLAC"
from pracownicy p join zespoly z on p.id_zesp = z.id_zesp
join etaty e on p.etat = e.nazwa
where p.etat in('ASYSTENT', 'ADIUNKT') and 12*(p.placa_pod+nvl(p.placa_dod,0)) > 5500
order by p.nazwisko;

--8
select pp.nazwisko, pp.id_prac, ps.nazwisko as "SZEF", ps.id_prac as "ID_SZEFA"
from pracownicy pp join pracownicy ps on ps.id_prac = pp.id_szefa
order by pp.nazwisko;

--9
select pp.nazwisko, pp.id_prac, ps.nazwisko as "SZEF", ps.id_prac as "ID_SZEFA"
from pracownicy pp left join pracownicy ps on ps.id_prac = pp.id_szefa
order by pp.nazwisko;

--10
-- Uwaga: count(p.id_prac) a nie count(*)!
select  z.nazwa, count(p.id_prac) as "LICZBA", avg(p.placa_pod) as "PLACA"
from pracownicy p right join zespoly z on p.id_zesp = z.id_zesp
group by z.nazwa
order by z.nazwa; 

--11
select p.nazwisko, count(pp.id_prac) as "LICZBA"
from pracownicy p join pracownicy pp on p.id_prac = pp.id_szefa
group by p.nazwisko
having not count(pp.id_prac) = 0
order by count(pp.id_prac) DESC;

--12
select p.nazwisko, p.zatrudniony, s.nazwisko, s.zatrudniony, 
extract(year from(p.zatrudniony - s.zatrudniony) year to month) as "LATA"
from pracownicy p join pracownicy s on p.id_szefa=s.id_prac
where extract (year from(p.zatrudniony - s.zatrudniony)year to month) < 10
order by p.zatrudniony;


--Operatory zbiorowe
--13
select etat from pracownicy
where extract(year from(zatrudniony)) = '1992'
group by etat

intersect --czesc wspolna zbiorow

select etat from pracownicy
where extract(year from(zatrudniony)) = '1993'
group by etat;

--14
select id_zesp from zespoly

minus 

select id_zesp from pracownicy;

--15
select nazwisko, placa_pod, 
(case 
	when placa_pod < 480 then 'Poniżej 480 złotych'
	when placa_pod = 480 then 'Dokładnie 480 złotych'
	else 'Powyżej 480 złotych' 
end) as "PROG"
from pracownicy
order by placa_pod;










