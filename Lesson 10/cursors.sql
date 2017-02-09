--SQL Kursory
--1
declare 
cursor  asystenci is
select nazwisko, zatrudniony from pracownicy where 
etat = 'ASYSTENT';
c_nazwisko pracownicy.nazwisko%TYPE;
c_zatrudniony pracownicy.zatrudniony%TYPE;

begin
open asystenci;
loop
fetch asystenci into c_nazwisko, c_zatrudniony;
exit when asystenci%notfound;
dbms_output.put_line(c_nazwisko||' pracuje od '||c_zatrudniony);
end loop;
close asystenci;
end;

--2 -w petli for dla kursora nie trzeba go otwierac i zamykać!
declare 
cursor naj_zar is select * from pracownicy order by placa_pod desc;
c_nazwisko pracownicy.nazwisko%TYPE;
begin
for i in naj_zar loop
   dbms_output.put_line(naj_zar%rowcount||': '||i.nazwisko);
   exit when naj_zar%rowcount=3;
end loop;
end;

--3
declare 
cursor podwyzka is select * from pracownicy where to_char(zatrudniony, 'Dy')='Pn' for update of placa_pod;
begin
  for c in podwyzka loop
    update pracownicy
    set placa_pod=1.2*placa_pod
    where current of podwyzka;
  end loop;
end;

select nazwisko, placa_pod from pracownicy
where to_char(zatrudniony, 'Dy')='Pn';

--4
declare 
cursor superpodwyzka is select nazwa, placa_pod from pracownicy join zespoly on z.id_zesp=p.id_zesp
for update of placa_pod;
begin
  for c in superpodwyzka loop
    if(c.nazwa='ALGORYTMY') then
      update pracownicy set placa_dod=nvl(placa_dod,0)+100
      where current of superpodwyzka;
    elsif(c.nazwa='ADMINISTRACJA') then
      update pracownicy set placa_dod=nvl(placa_dod,0)+150
      where current of superpodwyzka;
    elsif (c.etat='STAZYSTA') then
      delete from pracownicy where current of superpodwyzka;
end if;
  end loop;
end;

--5
declare
cursor etaty(v_etat pracownicy.etat%TYPE) is select nazwisko from pracownicy where etat=v_etat;
etat_zmienna pracownicy.etat%TYPE;
begin
  etat_zmienna:='&Podaj_etat';
  for c in etaty(etat_zmienna)loop
    dbms_output.put_line(c.nazwisko);
  end loop;
end;

--6
declare
cursor pracownik(e pracownicy.etat%TYPE) is select nazwisko, placa_pod, placa_dod from pracownicy where etat=e;
cursor etaty is select etat, avg(placa_pod) as srednia from pracownicy group by etat;
ile float;
temp float;
begin
  for e in etaty loop
     ile:=0;
     dbms_output.put_line('Etat: '||e.etat);
     for p in pracownik(e.etat) loop
		temp:=p.placa_pod+nvl(p.placa_dod,0);
		dbms_output.put_line(pracownik%rowcount||' '||p.nazwisko||', pensja: '||temp);
		ile:=ile+1;
     end loop;
     dbms_output.put_line('Liczba pracownikow: '||ile);
     dbms_output.put_line('Srednia na etacie: '||e.srednia);
  end loop;
end;

--7

--8 bez kursora 
select distinct etat, 
cursor(select nazwisko, placa_pod from pracownicy q where q.etat=p.etat), 
avg(placa_pod) 
from pracownicy p group by etat;


