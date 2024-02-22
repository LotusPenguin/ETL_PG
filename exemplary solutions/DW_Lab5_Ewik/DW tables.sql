USE AKCJE_DW


CREATE TABLE Strazak(
	ID_strazaka INTEGER IDENTITY(1,1) PRIMARY KEY,
	Imie_i_nazwisko varchar(100),
	Dlugosc_stazu varchar(20),
 	Plec char(10) check(Plec in ('Kobieta', 'Mezczyzna')),
	Czy_dane_aktualne bit
);
CREATE TABLE Kierowca(
	ID_kierowcy INTEGER IDENTITY(1,1) PRIMARY KEY,
	Imie_i_nazwisko varchar(100),
);

CREATE TABLE Remiza(
	ID_remizy INTEGER IDENTITY(1,1) PRIMARY KEY,
	Miejscowosc varchar(50),
	Numer int,
);
CREATE TABLE Zespol(
	ID_zespolu INTEGER IDENTITY(1,1) PRIMARY KEY,
	Rodzaj_strazy varchar(10) check(Rodzaj_strazy in ('panstwowa', 'ochotnicza', 'zakladowa'))
);

CREATE TABLE Trasa(
	ID_trasy INTEGER IDENTITY(1,1) PRIMARY KEY,
	Nawierzchnia varchar(20) check(Nawierzchnia in('utwardzona', 'nieutwardzona', 'mieszana'))
);
CREATE TABLE Droga(
	ID_drogi INTEGER IDENTITY(1,1) PRIMARY KEY,
	Nazwa varchar(50),
	Miejscowosc varchar(50),
);

CREATE TABLE Pojazd(
	ID_pojazdu INTEGER IDENTITY(1,1) PRIMARY KEY,
	Masa_wlasna varchar(20),
	Ilosc_drzwi int,
	Przedzial_rocznikowy varchar(20),
	Marka varchar(20)
)

CREATE TABLE Data_(
	ID_daty INTEGER IDENTITY(1,1) PRIMARY KEY,
	rok char(4),
	miesiac varchar(15),
	numer_miesiaca int,
	dzien int,
	dzien_tygodnia varchar(15),
	numer_dnia_tygodnia int,
	wakacje varchar(15),
	swieto varchar(50),
	dzien_roboczy bit
)

CREATE TABLE Czas(
	ID_czasu INTEGER IDENTITY(1,1) PRIMARY KEY,
	Godzina int,
	Przedzial_godzinowy varchar(25),
	Pora_dnia varchar(15)
)


CREATE TABLE Czlonkostwo_w_zespole(
	ID_zespolu int REFERENCES Zespol(ID_zespolu),
	ID_strazaka int REFERENCES Strazak(ID_strazaka)
)

CREATE TABLE Uzyte_drogi(
	ID_trasy int REFERENCES Trasa(ID_trasy),
	ID_drogi int REFERENCES Droga(ID_drogi)
)

CREATE TABLE Dojazd_na_akcje(
	ID_daty_rozpoczecia int REFERENCES Data_(ID_daty),
	ID_daty_zakonczenia int REFERENCES Data_(ID_daty),
	ID_czasu_rozpoczecia int REFERENCES Czas(ID_czasu),
	ID_czasu_zakonczenia int REFERENCES Czas(ID_czasu),
	ID_pojazdu int REFERENCES Pojazd(ID_pojazdu),
	ID_zespolu int REFERENCES Zespol(ID_zespolu),
	ID_kierowcy int REFERENCES Kierowca(ID_kierowcy),
	ID_trasy int REFERENCES Trasa(ID_trasy),
	ID_remizy int REFERENCES Remiza(ID_remizy),
	Czas_zebrania_sie_zespolu int,
	Czas_dojazdu int,
	Dlugosc_pokonanej_trasy float,
	Ilosc_kobiet int,
	Ilosc_mezczyzn int,
	Liczebnosc_zespolu int,
	Srednia_dlugosc_stazu_zespolu float,
	Srednia_predkosc float,
	Czy_nowy_zespol bit
);