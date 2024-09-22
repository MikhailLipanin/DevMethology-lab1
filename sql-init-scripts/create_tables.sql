-- Создание базы данных
CREATE DATABASE "DevMethology-lab1";

-- Использование базы данных
\c "DevMethology-lab1";

-- Таблица Colors
CREATE TABLE Colors
(
    ID   BIGINT PRIMARY KEY,
    Name VARCHAR(200) NOT NULL
);

-- Таблица SouvenirMaterials
CREATE TABLE SouvenirMaterials
(
    ID   BIGINT PRIMARY KEY,
    Name VARCHAR(200) NOT NULL
);

-- Таблица ApplicationMetods
CREATE TABLE ApplicationMetods
(
    ID   BIGINT PRIMARY KEY,
    Name VARCHAR(200) NOT NULL
);

-- Таблица ProcurementStatuses
CREATE TABLE ProcurementStatuses
(
    ID   BIGINT PRIMARY KEY,
    Name VARCHAR(200) NOT NULL
);

-- Таблица Providers
CREATE TABLE Providers
(
    ID            BIGINT PRIMARY KEY,
    Name          VARCHAR(200) NOT NULL,
    Email         VARCHAR(200) NOT NULL,
    ContactPerson VARCHAR(200) NOT NULL,
    Comments      VARCHAR(1000)
);

-- Таблица SouvenirsCategories
CREATE TABLE SouvenirsCategories
(
    ID       BIGINT PRIMARY KEY,
    IdParent BIGINT,
    Name     VARCHAR(100) NOT NULL
);

-- Таблица Souvenirs
CREATE TABLE Souvenirs
(
    ID            BIGINT PRIMARY KEY,
    URL           VARCHAR(100)   NOT NULL,
    ShortName     VARCHAR(150)   NOT NULL,
    Name          VARCHAR(200)   NOT NULL,
    Description   VARCHAR(2500)  NOT NULL,
    Rating        SMALLINT       NOT NULL,
    IdCategory    BIGINT         NOT NULL,
    IdColor       BIGINT         NOT NULL,
    Size          VARCHAR(150)   NOT NULL,
    IdMaterial    INT            NOT NULL,
    Weight        DECIMAL(10, 3),
    QTypics       VARCHAR(10),
    PicsSize      VARCHAR(20),
    IdApplicMetod INT            NOT NULL,
    AllCategories VARCHAR(150)   NOT NULL,
    DealerPrice   DECIMAL(10, 2) NOT NULL,
    Price         DECIMAL(10, 2) NOT NULL,
    Comments      VARCHAR(1000),
    FOREIGN KEY (IdCategory) REFERENCES SouvenirsCategories (ID),
    FOREIGN KEY (IdColor) REFERENCES Colors (ID),
    FOREIGN KEY (IdMaterial) REFERENCES SouvenirMaterials (ID),
    FOREIGN KEY (IdApplicMetod) REFERENCES ApplicationMetods (ID)
);

-- Таблица SouvenirProcurements
CREATE TABLE SouvenirProcurements
(
    ID         BIGINT PRIMARY KEY,
    IdProvider BIGINT NOT NULL,
    Data       DATE   NOT NULL,
    IdStatus   INT    NOT NULL,
    FOREIGN KEY (IdProvider) REFERENCES Providers (ID),
    FOREIGN KEY (IdStatus) REFERENCES ProcurementStatuses (ID)
);

-- Таблица ProcurementSouvenirs
CREATE TABLE ProcurementSouvenirs
(
    ID            BIGINT PRIMARY KEY,
    IdSouvenir    BIGINT         NOT NULL,
    IdProcurement BIGINT         NOT NULL,
    Amount        INT            NOT NULL,
    Price         DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (IdSouvenir) REFERENCES Souvenirs (ID),
    FOREIGN KEY (IdProcurement) REFERENCES SouvenirProcurements (ID)
);

-- Таблица SouvenirStores
CREATE TABLE SouvenirStores
(
    ID            BIGINT PRIMARY KEY,
    IdSouvenir    BIGINT NOT NULL,
    IdProcurement BIGINT NOT NULL,
    Amount        INT    NOT NULL,
    Comments      VARCHAR(1000),
    FOREIGN KEY (IdSouvenir) REFERENCES Souvenirs (ID),
    FOREIGN KEY (IdProcurement) REFERENCES SouvenirProcurements (ID)
);
