import pyodbc
import json
import config

# Połączenie z bazą danych SQL Server
dw_connection = pyodbc.connect(config.dw_connection_data)

db_connection = pyodbc.connect(config.db_connection_data)

dw_cursor = dw_connection.cursor()
db_cursor = db_connection.cursor()

# Ładowanie danych z pliku JSON
with open('dane.json') as f:
    data = json.load(f)

# Iteracja przez dane z umów
for umowa in data['umowy']:
    db_cursor.execure("SELECT ")



    # # Pobranie ID podpisania umowy dystrybucyjnej
    # dw_cursor.execute("SELECT ID_podpisania_umowy FROM Podpisanie_umowy_dystrybucyjnej WHERE Numer_umowy = ?", (umowa['id'],))
    # id_podpisania_umowy = db_cursor.fetchone()[0]
    #
    # # Pobranie danych z tabeli Faktury
    # db_cursor.execute("SELECT Data_wystawienia, Kwota_należności, Numer_umowy FROM Faktury WHERE Nazwa_firmy = ?", (umowa['nazwa_firmy'],))
    # wyniki = db_cursor.fetchall()
    #
    # # Iteracja przez wyniki faktur
    # for row in wyniki:
    #     data_uzyskania_zysku = row[0]
    #     db_cursor.execute("SELECT ID_daty from Data WHERE Data = ?", data_uzyskania_zysku)
    #     id_daty = dw_cursor.fetchall()
    #     kwota_naleznosci = row[1]
    #
    #     # Obliczenie zysku
    #     zysk = kwota_naleznosci * ( umowa['marza_procentowa'] / 100)
    #
    #     # Wstawienie danych do tabeli Zyski_miesieczne
    #     dw_cursor.execute("INSERT INTO Zyski_miesieczne (ID_podpisania_umowy, Data_uzyskania_zysku, Zysk) VALUES (?, ?, ?)",
    #                       (id_podpisania_umowy, data_uzyskania_zysku, zysk))

# Potwierdzenie transakcji
dw_connection.commit()

# Zamknięcie połączenia
dw_connection.close()
db_connection.close()
