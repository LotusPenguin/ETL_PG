import json

import pyodbc

import config

# Połączenie z bazą danych SQL Server
dw_connection = pyodbc.connect(config.dw_connection_data)

db_connection = pyodbc.connect(config.db_connection_data)

dw_cursor = dw_connection.cursor()
db_cursor = db_connection.cursor()

# Ładowanie danych z pliku JSON
with open('../../bulks/dane.json') as f:
    data = json.load(f)

# Iteracja przez dane z umów
db_cursor.execute("""
SELECT F.Numer_faktury, UL.Numer_umowy AS Nr_umowy_licencyjnej, F.Data_wystawienia AS Data_wystawienia_faktury, F.Kwota_należności, UL.Nazwa_programu, UD.Nr_umowy
FROM Dystrybucja D
JOIN Umowy_dystrybucyjne UD ON D.Nr_umowy = UD.Nr_umowy
JOIN Umowy_licencyjne UL ON UD.ID_Sprzedawcy = UL.ID_Sprzedawcy AND UL.Data_zawarcia BETWEEN UD.Data_zawarcia AND UD.Data_wygaśnięcia
JOIN Faktury F ON UL.Numer_umowy = F.Numer_umowy
JOIN Programy P ON P.Nazwa_handlowa = UL.Nazwa_programu AND P.Nazwa_handlowa = D.Nazwa_handlowa
""")
wyniki_db = db_cursor.fetchall()

dw_cursor.execute("SELECT ID_podpisania_umowy, Numer_umowy FROM Podpisanie_umowy_licencyjnej")
wyniki_dw = dw_cursor.fetchall()

### DEBUG ###
# print(wyniki)
# print(len(wyniki))
# print(type(wyniki))
# print(type(wyniki[0]))
# print(type(wyniki[0][1]))

# print(data['umowy'])
# print(type(data['umowy']))
# print(type(data['umowy'][0]))

i = 0
for record in wyniki_db:
    i += 1
    stala_kwota = 0
    marza_procentowa = 0
    id_podpisania_umowy = None
    for details_dict in data['umowy']:
        if details_dict['nr_umowy'] == record[5] and details_dict['oprogramowanie'] == record[4]:
            marza_procentowa = details_dict['marza_procentowa']
            stala_kwota = details_dict['stala_kwota']
            break
    kwota_naleznosci = record[3]

    zysk = round((float(kwota_naleznosci) - stala_kwota - (marza_procentowa / 100) * float(kwota_naleznosci)), 2)

    dw_cursor.execute("SELECT ID_daty FROM Data WHERE Data.Data = ?", record[2])
    data_uzyskania_zysku = dw_cursor.fetchone()[0]
    for record_dw in wyniki_dw:
        if record_dw[1] == record[1]:
            id_podpisania_umowy = record_dw[0]
            break

    dw_cursor.execute("INSERT INTO Zyski_miesieczne (ID_podpisania_umowy, Data_uzyskania_zysku, Zysk) VALUES (?, ?, ?)",
                      (id_podpisania_umowy, data_uzyskania_zysku, zysk))
    if i % 100 == 0:
        print(f"Inserted record {i}")

# Potwierdzenie transakcji
dw_connection.commit()

# Zamknięcie połączenia
dw_connection.close()
db_connection.close()
