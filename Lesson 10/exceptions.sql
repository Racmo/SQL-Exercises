--SQL Wyjątki
--1
declare
cursor etaty(v_etat pracownicy.etat%TYPE) is select nazwisko from pracownicy where etat=v_etat;
etat_zmienna pracownicy.etat%TYPE;
test pracownicy.etat%TYPE;
begin
  etat_zmienna:='&Podaj_etat';
  select distinct etat into test from pracownicy where etat=etat_zmienna;
  for c in etaty(etat_zmienna)loop
    dbms_output.put_line(c.nazwisko);
  end loop;
  
exception 
when no_data_found then
	dbms_output.put_line('Niepoprawna nazwa etatu!');
end;

--2
declare 
cursor prof is select * from pracownicy where etat='PROFESOR'
for update of placa_pod;
podwyzka pracownicy.placa_pod%TYPE;
begin
	for c in prof loop
		select 0.1*sum(p.placa_pod) into podwyzka
		from pracownicy p where c.id_prac = p.id_szefa;
		if c.placa_pod + podwyzka > 2000 then raise_application_error(-20010, 'Pensja po podwyzce przekracza 2000 zł!')
		end if;
		update pracownicy 
		set placa_pod=placa_pod+podwyzka
		where current of prof;	
	end loop;
end;

--3
declare
prac pracownicy%rowtype;
begin
	prac.id_prac:='&Podaj_id_prac';
	prac.nazwisko:='&Podaj_nazwisko';
	prac.id_zesp:='&Podaj_id_zesp';
	prac.placa_pod:='&Podaj_placa_pod';
	
	insert into pracownicy(id_prac,nazwisko,id_zesp,placa_pod)
	values (prac.id_prac,prac.nazwisko,prac.id_zesp,prac.placa_pod);
exception
	when others then
		if sqlcode=-1 then dbms_output.put_line('Id dubluje istniejace id w tab pracownicy! '||sqlcode);
		elsif sqlcode=-1400 then dbms_output.put_line('Brak id! '||sqlcode);
		elsif sqlcode=-2290 then dbms_output.put_line('Płaca mniejsza niz 101! '||sqlcode);
		elsif sqlcode=-2291 then dbms_output.put_line('Nie ma zespolu z takim id_zesp! '||sqlcode);
		else dbms_output.put_line('Inny błąd '||sqlcode);
		end if;
end;

--4
declare
nazw pracownicy.nazwisko%TYPE;

my_exc exception;
pragma exception_init(my_exc, -2292);
ile_prac number(5);

begin
	nazw:='&Podaj_nazwisko';
	
	select nvl(count(nazwisko),0) into ile_prac from pracownicy where nazwisko=nazw
	group by nazwisko;
	
        if ile_prac>1 then raise_application_error(-20030, 'Niejednoznaczne wskazanie pracownika');
	end if;
	
	delete from pracownicy where nazwisko=nazw;
	
exception when my_exc then
	dbms_output.put_line('Szef nie do ruszenia!');	
when no_data_found then
raise_application_error(-20020, 'Nie istnieje taki pracownik!');
end;






















