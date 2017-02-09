--SQL Język PL/SQL
SET SERVEROUTPUT ON;
--1
declare 
v_tekst varchar2(20) := 'Witaj świecie!';
v_liczba float := 1000.456;
begin
dbms_output.put_line('Zmienna v_tekst: '||v_tekst);
dbms_output.put_line('Zmienna v_liczba: '|| v_liczba);
end;

--2
declare 
v_tekst varchar2(40) := 'Witaj świecie!';
v_liczba number(22,4) := 1000.456;
begin
v_tekst:=v_tekst||'Witaj nowy dniu!';
v_liczba:=v_liczba+power(10,15);
dbms_output.put_line('Zmienna v_tekst: '||v_tekst);
dbms_output.put_line('Zmienna v_liczba: '|| v_liczba);
end;

--3
declare
a float := &Podaj_a;
b float := &Podaj_b;
c float;
begin
c:=a+b;
dbms_output.put_line( a||' + '||b||' = '||c);
end;

--4
declare
pi constant float:=3.14;
obw float;
pow float;
r float := &Promień_koła;
begin
obw:=2*pi*r;
pow:=pi*power(r,2);
dbms_output.put_line('Obwód koła o promieniu '||r||' wynosi: '||obw);
dbms_output.put_line('Pole koła o promieniu '||r||' wynosi: '||pow);
end;

--5
declare 
v_nazwisko pracownicy.nazwisko%TYPE;
v_etat pracownicy.etat%TYPE;
begin
select nazwisko, etat into v_nazwisko, v_etat 
from pracownicy where placa_pod = (
select max(placa_pod) from pracownicy);
dbms_output.put_line('Najlepiej zarabia: '||v_nazwisko);
dbms_output.put_line('Na stanowisku: '||v_etat);
end;

--6
declare 
r_prac pracownicy%ROWTYPE;
begin
select * into r_prac 
from pracownicy where placa_pod = (
select max(placa_pod) from pracownicy);
dbms_output.put_line('Najlepiej zarabia: '||r_prac.nazwisko);
dbms_output.put_line('Na stanowisku: '||r_prac.etat);
end;

--7
declare
subtype PIENIADZE is float;
kasa_slowinskiego PIENIADZE;
begin
select 12*(placa_pod+nvl(placa_dod,0)) into kasa_slowinskiego from pracownicy where nazwisko='SLOWINSKI';
dbms_output.put_line('Pracownik Słowiński zarabia rocznie '||kasa_slowinskiego);
end;

--8
set serveroutput on;
declare 
wybor CHAR;
wynik varchar2(20);
begin
wybor:=&wybor;
if wybor='1' then
   select to_char(sysdate, 'dd-mm-yyyy') into wynik from dual;
else 
   select to_char(sysdate, 'HH24:MI:SS') into wynik from dual;
end if;
dbms_output.put_line(wynik);
end;

--9
declare 
wybor CHAR;
wynik varchar2(20);
begin
wybor:=&wybor;
case wybor
   when '1' then select to_char(sysdate, 'dd-mm-yyyy') into wynik from dual;
   when '2' then select to_char(sysdate, 'HH24:MI:SS') into wynik from dual;
end case;
dbms_output.put_line(wynik);
end;

--10
declare 
x varchar(5);
begin
loop
  x:= to_char(sysdate, 'ss');
  exit when x='25';
end loop;
dbms_output.put_line('Koniec programu');
end;

--11
declare 
n number(4);
wynik number(10):=1;
begin
n:=&Podaj_n;
for i in 1 .. n loop
  wynik:=wynik*i;
end loop;
dbms_output.put_line(n||'! = '||wynik);
end;

--12
declare
	a date;
begin
	a:=to_date('13/01/2001', 'dd/mm/yyyy');
	loop
		if (to_char(a,'dy') = 'Pt') then
			dbms_output.put_line(a);
		end if;
		
		a:=add_months(a,1);
		exit when (to_char(a,'yyyy') = '2101' );
	end loop;
end;