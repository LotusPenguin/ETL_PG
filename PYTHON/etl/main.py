import json
import pyodbc
import os
import config
import multiprocessing as mp


def write_to_file(file_name, to_write):
    with open(file_name, "w", encoding="utf-8") as file:
        file.writelines(to_write)


def CreateBulkInsertQuery(tableName, filename):
    return f"""
    USE HDSoftware;
    BULK INSERT dbo.{tableName} 
    FROM '{os.getcwd()}\\{filename}' 
    WITH (FIELDTERMINATOR='|');
    """

def init(args):
    global i
    i = args

embedded_dictionary = {}

def processRecord(record):
    zyski = []
    global i
    with i.get_lock():
        i.value += 1
    marza_procentowa = embedded_dictionary[record[5]][record[4]][0]
    stala_kwota = embedded_dictionary[record[5]][record[4]][1]
    kwota_naleznosci = record[3]

    # for details_dict in data['umowy']:
    #     if details_dict['nr_umowy'] == record[5] and details_dict['oprogramowanie'] == record[4]:
    #         marza_procentowa = details_dict['marza_procentowa']
    #         stala_kwota = details_dict['stala_kwota']
    #         break

    zysk = round((float(kwota_naleznosci) - stala_kwota - (marza_procentowa / 100) * float(kwota_naleznosci)), 2)

    dw_cursor.execute("SELECT ID_daty FROM Data WHERE Data.Data = ? ", record[2])
    data_uzyskania_zysku = dw_cursor.fetchone()[0]
    dw_cursor.execute("SELECT ID_podpisania_umowy FROM Podpisanie_umowy_licencyjnej WHERE Numer_umowy = ?",
                      record[1])
    id_podpisania_umowy = dw_cursor.fetchone()[0]
    # for record_dw in wyniki_dw:
    #     if record_dw[1] == record[1]:
    #         id_podpisania_umowy = record_dw[0]
    #         break
    zysk_z_faktury = str(id_podpisania_umowy) + "|" + str(data_uzyskania_zysku) + "|" + str(zysk)
    zyski.append(zysk_z_faktury)

    # dw_cursor.execute("INSERT INTO Zyski_miesieczne (ID_podpisania_umowy, Data_uzyskania_zysku, Zysk) VALUES (?, ?, ?)",
    #                   (id_podpisania_umowy, data_uzyskania_zysku, zysk))
    if i.value % 1000 == 0:
        print(f"Processed record {i}")
    return zyski

if __name__ == '__main__':

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

    # zyski = []

    ### DEBUG ###
    # print(wyniki)
    # print(len(wyniki))
    # print(type(wyniki))
    # print(type(wyniki[0]))
    # print(type(wyniki[0][1]))

    # print(data['umowy'])
    # print(type(data['umowy']))
    # print(type(data['umowy'][0]))

    # dw_cursor.execute("SELECT ID_podpisania_umowy, Numer_umowy FROM Podpisanie_umowy_licencyjnej")
    # wyniki_dw = dw_cursor.fetchall()

    # {
    #     nr_umowy: {
    #         nazwa_programu: {
    #             marza_procentowa:
    #             stala_kwota:
    #             }
    #     }
    # }

    # Create embedded dictionary
    # embedded_dictionary = {
    #     details_dict['nr_umowy']: {
    #         details_dict['oprogramowanie']: (details_dict['marza_procentowa'], details_dict['stala_kwota'])}
    #     for details_dict in data['umowy']
    # }

    for details_dict in data['umowy']:
        nr_umowy = details_dict['nr_umowy']
        oprogramowanie = details_dict['oprogramowanie']
        marza_procentowa = details_dict['marza_procentowa']
        stala_kwota = details_dict['stala_kwota']

        if nr_umowy not in embedded_dictionary:
            embedded_dictionary[nr_umowy] = {}

        if oprogramowanie not in embedded_dictionary[nr_umowy]:
            embedded_dictionary[nr_umowy][oprogramowanie] = []

        embedded_dictionary[nr_umowy][oprogramowanie].append(marza_procentowa)
        embedded_dictionary[nr_umowy][oprogramowanie].append(stala_kwota)

    # i = 0
    # for record in wyniki_db:

    i = mp.Value('i', 0)

    pool = mp.Pool(initializer=init,initargs=(i,))
    zyski = pool.map_async(processRecord,wyniki_db)
    pool.close()
    pool.join()


    write_to_file("tempfile.bulk", zyski.get())

    merge_query = ("""
    IF (OBJECT_ID('vETLFZyski') IS NOT NULL) DROP VIEW vETLFZyski;
    GO
    
    CREATE VIEW vETLFZyski
    AS
    ID_podpisania_umowy, Data_uzyskania_zysku, Zysk;
    """
                   + CreateBulkInsertQuery("vETLFZyski", "tempfile.bulk") +
                   """
    GO
    
    MERGE INTO Zyski_miesieczne as TT
    USING vETLFZyski as ST
        ON TT.ID_podpisania_umowy = ST.ID_podpisania_umowy
        AND TT.Data_uzyskania_zysku = ST.Data_uzyskania_zysku
            WHEN NOT MATCHED BY TARGET THEN
                    INSERT (ID_podpisania_umowy, Data_uzyskania_zysku, Zysk)
                    VALUES (ST.ID_podpisania_umowy, ST.Data_uzyskania_zysku, ST.Zysk)
            WHEN NOT MATCHED BY SOURCE THEN
                DELETE;
                
    DROP VIEW vETLFZyski;
    """)

    dw_cursor.execute(merge_query)

    os.remove("tempfile.bulk")
    input()

    # Potwierdzenie transakcji
    dw_connection.commit()

    # Zamknięcie połączenia
    dw_connection.close()
    db_connection.close()
