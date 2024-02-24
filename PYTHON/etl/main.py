import pyodbc
import json

# Połączenie z bazą danych SQL Server
conn = pyodbc.connect('Driver={SQL Server Native Client 11.0};'
                      'Server=BLAZEJ-PC;'
                      'Database=HDsoftware;'
                      'Trusted_Connection=yes;')

conn2 = pyodbc.connect('Driver={SQL Server Native Client 11.0};'
                      'Server=BLAZEJ-PC;'
                      'Database=SoftwareDB;'
                      'Trusted_Connection=yes;')

cursor = conn.cursor()

cursor2 = conn2.cursor()

# Ładowanie danych z pliku JSON
with open('dane.json') as f:
    data = json.load(f)

# Iteracja przez dane sprzedawców
for sprzedawca in data['sprzedawcy']:
    # Pobranie ID_podpisania_umowy z bazy danych
    cursor.execute("SELECT ID_podpisania_umowy FROM Podpisanie_umowy_licencyjnej WHERE Numer_umowy = ?", (sprzedawca['id'],))
    id_podpisania_umowy = cursor2.fetchone()[0]

    # Pobranie danych z tabeli Faktury
    cursor2.execute("SELECT Data_wystawienia, Kwota_należności FROM Faktury WHERE Nazwa_firmy = ?", (sprzedawca['nazwa_firmy'],))
    wyniki = cursor2.fetchall()

    # Iteracja przez wyniki faktur
    for row in wyniki:
        data_uzyskania_zysku = row[0]
        cursor2.execute("SELECT ID_daty from Data WHERE Data = ?", data_uzyskania_zysku)
        id_daty = cursor.fetchall()
        kwota_naleznosci = row[1]

        # Obliczenie zysku
        zysk = kwota_naleznosci * (sprzedawca['marza_procentowa'] / 100)

        # Wstawienie danych do tabeli Zyski_miesieczne
        cursor.execute("INSERT INTO Zyski_miesieczne (ID_podpisania_umowy, Data_uzyskania_zysku, Zysk) VALUES (?, ?, ?)",
                       (id_podpisania_umowy, data_uzyskania_zysku, zysk))

# Potwierdzenie transakcji
conn.commit()

# Zamknięcie połączenia
conn.close()
conn2.close()
