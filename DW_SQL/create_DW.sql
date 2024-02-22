use HDsoftware
go

-- Tworzenie tabeli Sprzedawcy
CREATE TABLE Sprzedawcy (
    ID_sprzedawcy INT PRIMARY KEY IDENTITY(1,1),
    Nazwa NVARCHAR(200) UNIQUE NOT NULL
);

-- Tworzenie tabeli Klienci
CREATE TABLE Klienci (
    ID_klienta INT PRIMARY KEY IDENTITY(1,1),
    os_fiz_or_firma BIT,
    Nazwa NVARCHAR(200) UNIQUE NOT NULL
);

-- Tworzenie tabeli Data
CREATE TABLE Data (
    ID_daty INT PRIMARY KEY IDENTITY(1,1),
    Rok INT,
    Miesiac INT CHECK (Miesiac >= 1 AND Miesiac <= 12),
    Dzien INT CHECK (Dzien >= 1 AND Dzien <= 31),
    Data DATE
);

-- Tworzenie tabeli Programy
CREATE TABLE Programy (
    ID_programu INT PRIMARY KEY IDENTITY(1,1),
    Aktualna_wersja VARCHAR(50),
    Platforma NVARCHAR(1000),
    Rodzaj VARCHAR(100),
    Czy_aktywny BIT,
    Nazwa_handlowa NVARCHAR(200),
    Data_zakonczenia_wsparcia INT NOT NULL REFERENCES DATA(ID_daty),
    Data_wydania INT NOT NULL REFERENCES DATA(ID_daty)
);

-- Tworzenie tabeli Junk
CREATE TABLE Junk (
    Junk_id INT PRIMARY KEY IDENTITY(1,1),
    Plan_platnosci VARCHAR(100)
);

-- Tworzenie tabeli Podpisanie_umowy_licencyjnej
CREATE TABLE Podpisanie_umowy_licencyjnej (
    ID_podpisania_umowy INT PRIMARY KEY IDENTITY(1,1),
    Data_zawarcia INT NOT NULL REFERENCES Data(ID_daty),
    Data_wygasniecia INT NOT NULL REFERENCES Data(ID_daty),
    Kwota_platnosci MONEY,
    ID_sprzedawcy INT NOT NULL REFERENCES Sprzedawcy(ID_sprzedawcy),
    ID_klienta INT NOT NULL REFERENCES Klienci(ID_klienta),
    ID_programu INT NOT NULL REFERENCES Programy(ID_programu),
    Junk_id INT NOT NULL REFERENCES Junk(Junk_id),
    Numer_umowy VARCHAR(100)
);



-- Tworzenie tabeli Podpisanie_umowy_dystrybucyjnej
CREATE TABLE Podpisanie_umowy_dystrybucyjnej (
    ID_sprzedawcy INT NOT NULL REFERENCES Sprzedawcy(ID_sprzedawcy),
    Data_zawarcia INT NOT NULL REFERENCES Data(ID_daty),
    Data_wygasniecia INT NOT NULL REFERENCES Data(ID_daty),
    ID_programu INT NOT NULL REFERENCES Programy(ID_programu),
    Numer_umowy VARCHAR(100)
);

-- Tworzenie tabeli Zyski_miesieczne
CREATE TABLE Zyski_miesieczne (
    ID_podpisania_umowy INT NOT NULL REFERENCES Podpisanie_umowy_licencyjnej(ID_podpisania_umowy),
    Data_uzyskania_zysku INT NOT NULL REFERENCES Data(ID_daty),
    Zysk MONEY
);
