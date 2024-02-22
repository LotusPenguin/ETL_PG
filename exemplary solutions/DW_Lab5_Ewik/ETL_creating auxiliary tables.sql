USE master;
CREATE DATABASE auxiliary;
GO

USE auxiliary;

CREATE TABLE swieta(rok varchar(4), miesiac int, dzien int , swieto VARCHAR(500), wolne BIT, PRIMARY KEY(rok, miesiac, dzien));
CREATE TABLE wakacje(start DATETIME, koniec DATETIME, rodzaj VARCHAR(500), PRIMARY KEY(start,koniec));

USE master;