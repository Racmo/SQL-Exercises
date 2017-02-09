--SQL modyfikacja danych DML
--1
insert into projekty(id_projektu, opis_projektu, data_rozpoczecia, data_zakonczenia, fundusz)
values (2, 'Sieci kręgosłupowe', to_date('2000/11/12','yyyy/mm/dd'),null,19000);

--2
insert into przydzialy(id_projektu, nr_pracownika, od, do, stawka, rola, godziny)
values
(1, 170, to_date('1999/04/10', 'yyyy/mm/dd'), to_date('1999/05/10','yyyy/mm/dd'), 1000, 'KIERUJACY', 20);

insert into przydzialy(id_projektu, nr_pracownika, od, do, stawka, rola, godziny)
values
(1, 140, to_date('2000/12/01', 'yyyy/mm/dd'), null, 1500, 'ANALITYK', 40);

select * from przydzialy;

--3
update przydzialy 
set stawka=1200
where nr_pracownika=170;

--4
update projekty
set data_zakonczenia=to_date('2001/12/31','yyyy/mm/dd'),
    fundusz = 19000
where opis_projektu='Indeksy bitmapowe';

--5

--6
delete from projekty
where id_projektu not in
(select id_projektu from przydzialy); 

--7
update pracownicy x
set x.placa_pod = x.placa_pod + 0.1*(select avg(p.placa_pod) from pracownicy p group by p.id_zesp having p.id_zesp=x.id_zesp)

--8
update pracownicy p
set p.placa_pod = (select avg(placa_pod) from pracownicy)
where p.placa_pod = (select min(placa_pod) from pracownicy);

--9
update pracownicy p
set
p.placa_dod = 
(select avg(placa_pod) from pracownicy group by id_szefa 
having id_szefa = 
(select id_prac from pracownicy where nazwisko='MORZY'))
where p.id_zesp=20;

--10
update 
(select p.placa_pod, z.nazwa 
from pracownicy p join zespoly z on z.id_zesp = p.id_zesp)
set placa_pod=1.25*placa_pod
where nazwa = 'SYSTEMY ROZPROSZONE';

--11
delete from
(select p.nazwisko as pracownik, s.nazwisko as szef from pracownicy p join pracownicy s on p.id_szefa=s.id_prac)
where szef='MORZY';

--Sekwencje
--13
create sequence myseq2 start with 300
increment by 10;

--14
insert into pracownicy
(id_prac, nazwisko, etat)
values
(myseq.nextval, 'Trąbczyński', 'STAZYSTA');

--15
update pracownicy 
set placa_pod=myseq.currval
where nazwisko='Trąbczyński';

--16
delete from pracownicy
where nazwisko='Trąbczyński';

--17
create sequence cos start with 300
increment by 10 maxvalue 320;

select cos.nextval from dual; --300
select cos.nextval from dual; --310
select cos.nextval from dual; --320
select cos.nextval from dual; --błąd
