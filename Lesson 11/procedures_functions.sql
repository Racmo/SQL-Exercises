--11 Procedury i funkcje składowane
--1
set serveroutput on;

create or replace procedure 
podwyzka3(v_id_zesp in pracownicy.id_zesp%TYPE,
			v_procent in number default 15) is
begin
	update pracownicy
	set placa_pod=placa_pod*(1 + v_procent/100)
	where id_zesp=v_id_zesp;
end podwyzka3;
/

execute podwyzka3(10,10);

--2
set serveroutput on;

-- create or replace procedure 
-- podwyzka3(v_id_zesp in pracownicy.id_zesp%TYPE,
			-- v_procent in number default 15) is
-- begin
	-- if v_id_zesp not in (select id_zesp from pracownicy) then raise_application_error(-20001, 'Brak zespolu o podanym numerze');
	-- end if;
	-- update pracownicy
	-- set placa_pod=placa_pod*(1 + v_procent/100)
	-- where id_zesp=v_id_zesp;
-- end podwyzka3;
-- /

create or replace procedure 
podwyzka3(v_id_zesp in pracownicy.id_zesp%TYPE,
			v_procent in number default 15) is
test zespoly.id_zesp%TYPE;
begin
	select id_zesp into test from zespoly where id_zesp=v_id_zesp;
	update pracownicy
	set placa_pod=placa_pod*(1 + v_procent/100)
	where id_zesp=v_id_zesp;
exception
when no_data_found then raise_application_error(-20001, 'Brak zespolu o podanym nr');
end podwyzka3;

execute podwyzka3(100,25);

--3
create or replace procedure
liczba_pracownikow2(v_nazwa in zespoly.nazwa%TYPE,
					liczba out number) is
begin
	select count(p.id_prac) into liczba 
	from pracownicy p join zespoly z on z.id_zesp=p.id_zesp
	where z.nazwa=v_nazwa;
	
exception
	when no_data_found then dbms_output.put_line('Nieprawidlowa nazwa zespolu');
end liczba_pracownikow2;


--4 -- nie kompiluje się :(
create or replace procedure
nowy_pracownik2(
v_nazwisko in pracownicy.nazwisko%TYPE,
v_nazwa_zesp in zespoly.nazwa%TYPE),
v_nazw_szefa in pracownicy.nazwisko%TYPE,
v_placa_pod in pracownicy.placa_pod%TYPE,
v_data in pracownicy.zatrudniony%TYPE default sysdate,
v_etat in pracownicy.etat%TYPE default 'STAZYSTA') is

szefID pracownicy.id_szefa%TYPE;
zespID zespoly.id_zesp%TYPE;
begin
	select id_prac into szefID from pracownicy where nazwisko=v_nazw_szefa;
	select id_zesp into zespID from zespoly where nazwa=v_nazwa_zesp;
	
	insert into pracownicy(id_prac, nazwisko, id_zesp, id_szefa, placa_pod, zatrudniony, etat)
	values (myseq.NEXTVAL,v_nazwisko, zespID, szefID, v_placa_pod, v_data, v_etat);
	
exception 
	when no_data_found then
	dbms_output('Nie ma takiego szefa lub nie ma takiego zespolu');	
end nowy_pracownik2;

--5
create
function placa_netto2(brutto in pracownicy.placa_pod%TYPE, podatek in number default 20) return pracownicy.placa_pod%TYPE is
begin
	return brutto*(1+podatek/100);
end placa_netto2;

--6 --silnia iteracyjnie
create 
function silnia(n in number) return number is
sil number:=1;
begin
	if(n<0) then dbms_output.put_line('Liczba ujemna');
	else 
		for i in 1 .. n loop
			sil:=sil*i;
		end loop;
	end if;
	return sil;
end silnia;

select silnia(8) from dual;

--7 --silnia rekurencujnie
create or replace
function silnia_reku(n in number) return number is
sil number:=1;
begin
	if(n<0) then dbms_output.put_line('Liczba ujemna');
	else 
		if(n=0) then return 1;
		else return (n*silnia_reku(n-1));
		end if;
	end if;
	
end silnia_reku;

select silnia_reku(10) from dual;

--8
create or replace
function staz(data in pracownicy.zatrudniony%TYPE) return number is
begin
	return extract(year from(sysdate)) - extract(year from(data));
end staz;

select nazwisko, zatrudniony, staz(zatrudniony) from pracownicy;
















