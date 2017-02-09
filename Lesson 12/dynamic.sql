--SQL 12 Pakiety podprogramów, dynamiczny sql
--1
create or replace 
package KONWERSJA is
	function cells_to_fahr(cels in float) return float;
	function fahr_to_cells(fahr in float) return float;
end KONWERSJA;
/
create or replace package body KONWERSJA is

	function cells_to_fahr(cels in float) return float is
	begin
		return (9/5)*cels + 32;
	end cells_to_fahr;
	
	function fahr_to_cells(fahr in float) return float is
	begin
		return (5/9)*(fahr - 32);
	end fahr_to_cells;
	
end KONWERSJA;
/

select konwersja.fahr_to_cells(212) from dual;
select konwersja.cells_to_fahr(0) from dual;

--2
create or replace
package ZMIENNE is
	vLicznik number;
	procedure ZwiekszLicznik;
	procedure ZmniejszLicznik;
	function PokazLicznik return number;
end ZMIENNE;
/
create or replace package body ZMIENNE is
	
	procedure ZwiekszLicznik is
	begin
		vLicznik:=vLicznik+1;
		dbms_output.put_line('Zwiększono');
	end ZwiekszLicznik;
	
	procedure ZmniejszLicznik is
	begin
		vLicznik:=vLicznik-1;
		dbms_output.put_line('Zmniejszono');
	end ZmniejszLicznik;
	
	function PokazLicznik return number is
	begin
		dbms_output.put_line('Licznik = '||vLicznik);
		return vLicznik;
	end PokazLicznik;
	
begin
	vLicznik:=1;
	dbms_output.put_line('Zainicjalizowano');	
end ZMIENNE;
/

select zmienne.PokazLicznik from dual;
execute zmienne.ZwiekszLicznik;
select zmienne.PokazLicznik from dual;
execute zmienne.ZwiekszLicznik;
select zmienne.PokazLicznik from dual;
execute zmienne.ZmniejszLicznik;
select zmienne.PokazLicznik from dual;

--3 --dynamiczny
create or replace 
procedure IleRekordow(v_relacja in varchar2) is
	polecenie varchar2(100);
	ile number;
begin
	polecenie := 'select count(*) from '||v_relacja;
	execute immediate polecenie into ile;
	dbms_output.put_line('Liczba rekordow relacji '||v_relacja||': '||ile);
end IleRekordow;
/

--4 --dynamiczny
create or replace
package MODYFIKACJE is
	procedure DodajKolumne(v_relacja in varchar2, kolumna in varchar2, typ_wartosci in varchar2);
	procedure UsunKolumne(v_relacja in varchar2, kolumna in varchar2);
	procedure ZmienTypKolumny(v_relacja in varchar2, kolumna in varchar2, typ_wartosci in varchar2, czy_zachowac_dane in boolean);
end MODYFIKACJE;
/
create or replace 
package body MODYFIKACJE is
polecenie varchar2(100);
	
	procedure DodajKolumne(v_relacja in varchar2, kolumna in varchar2, typ_wartosci in varchar2) is
	begin
		polecenie:='alter table '||v_relacja||' add '||kolumna||' '||typ_wartosci;
		execute immediate polecenie;
	end DodajKolumne;
	
	procedure UsunKolumne(v_relacja in varchar2, kolumna in varchar2) is
	begin
		polecenie:='alter table '||v_relacja||' drop column '||kolumna;
		execute immediate polecenie;
	end UsunKolumne;
	
	procedure ZmienTypKolumny(v_relacja in varchar2, kolumna in varchar2, typ_wartosci in varchar2, czy_zachowac_dane in boolean) is
	begin
		if (czy_zachowac_dane=TRUE) then
			polecenie:='update '||v_relacja||' set '||kolumna||'='||NULL);
			execute immediate polecenie;
		end if;
		polecenie:='alter table '||v_relacja||' modify '||kolumna||' '||typ_wartosci;
		execute immediate polecenie;
	end ZmienTypKolumny;
	
end MODYFIKACJE;
/