USE master;
CREATE DATABASE auxiliary;
GO

USE auxiliary;

CREATE TABLE swieta(data DATETIME PRIMARY KEY, swieto VARCHAR(500), wolne BIT);
CREATE TABLE wakacje(start DATETIME, koniec DATETIME, rodzaj VARCHAR(500), PRIMARY KEY(start,koniec));

USE master;
GO