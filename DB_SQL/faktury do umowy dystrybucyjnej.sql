USE SoftwareDB;

SELECT F.Numer_faktury, UL.Numer_umowy AS Nr_umowy_licencyjnej, F.Data_wystawienia AS Data_wystawienia_faktury, F.Kwota_należności, UL.Nazwa_programu, UD.Nr_umowy
FROM Dystrybucja D
JOIN Umowy_dystrybucyjne UD ON D.Nr_umowy = UD.Nr_umowy
JOIN Umowy_licencyjne UL ON UD.ID_Sprzedawcy = UL.ID_Sprzedawcy AND UL.Data_zawarcia BETWEEN UD.Data_zawarcia AND UD.Data_wygaśnięcia
JOIN Faktury F ON UL.Numer_umowy = F.Numer_umowy
JOIN Programy P ON P.Nazwa_handlowa = UL.Nazwa_programu AND P.Nazwa_handlowa = D.Nazwa_handlowa
ORDER BY Numer_faktury;
