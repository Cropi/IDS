-- Purpose:     IDS project
-- Author(s):   xadame42
--              xlakat01
-- Date:        22.3.2018
-- Last modif.: 25.3.2018 (10:49)

-- DROP TABLES

DROP TABLE Uzivatel CASCADE CONSTRAINTS;
DROP TABLE NavstevovaneSkoly CASCADE CONSTRAINTS;
DROP TABLE TextovyPrispevek CASCADE CONSTRAINTS;
DROP TABLE Fotka CASCADE CONSTRAINTS;
DROP TABLE Album CASCADE CONSTRAINTS;
DROP TABLE Akce CASCADE CONSTRAINTS;
DROP TABLE Zprava CASCADE CONSTRAINTS;
DROP TABLE Konverzace CASCADE CONSTRAINTS;
DROP TABLE Vztah CASCADE CONSTRAINTS;
DROP TABLE Oznaceni CASCADE CONSTRAINTS;
DROP TABLE SoucastiAlba CASCADE CONSTRAINTS;
DROP TABLE UcastNaAkci CASCADE CONSTRAINTS;
DROP TABLE SoucastiKonverzace CASCADE CONSTRAINTS;

-- CREATE TABLES

CREATE TABLE Uzivatel(
    EMAIL VARCHAR2(50) NOT NULL,
    Jmeno VARCHAR(25) NOT NULL,
    Prijmeni VARCHAR(25) NOT NULL,
    Bydliste VARCHAR(50) NOT NULL, 
    Zamestnani VARCHAR(25) NOT NULL, 
    Kontakt VARCHAR(25) NOT NULL 
);


CREATE TABLE NavstevovaneSkoly(
    EMAIL VARCHAR2(50) NOT NULL,
    Skola VARCHAR2(25) NOT NULL
);


CREATE TABLE TextovyPrispevek(
    IDPrispevku integer GENERATED BY DEFAULT AS IDENTITY (START WITH 1  INCREMENT BY 2) NOT NULL,
    Obsah VARCHAR2(100) NOT NULL,
    CasPublikovani TIMESTAMP NOT NULL,
    DatumPublikovani TIMESTAMP NOT NULL,
    MistoPublikovani VARCHAR(25) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL
);


CREATE TABLE Fotka(
    IDPrispevku integer GENERATED BY DEFAULT AS IDENTITY (START WITH 2  INCREMENT BY 2) NOT NULL,
    Obsah VARCHAR2(100) NOT NULL,
    CasPublikovani TIMESTAMP NOT NULL,
    DatumPublikovani TIMESTAMP NOT NULL,
    MistoPublikovani VARCHAR2(25) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL,
    IDAkce integer NOT NULL
);


CREATE TABLE Album(
    IDAlba integer GENERATED BY DEFAULT AS IDENTITY (START WITH 1  INCREMENT BY 1) NOT NULL,
    Nazev VARCHAR2(25) NOT NULL,
    Popis VARCHAR2(50) NOT NULL,
    NastaveniSoukromi VARCHAR(10) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL,
    IDPrispevku integer NOT NULL
);


CREATE TABLE Akce(
    IDAkce integer GENERATED BY DEFAULT AS IDENTITY (START WITH 1  INCREMENT BY 1) NOT NULL,
    Nazev VARCHAR2(25) NOT NULL,
    PopisAkce VARCHAR2(50) NOT NULL,
    CasKonani TIMESTAMP NOT NULL,
    DatumKonani TIMESTAMP NOT NULL,
    MistoKonani VARCHAR2(25) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL
);


CREATE TABLE Zprava(
    IDZpravy integer GENERATED BY DEFAULT AS IDENTITY (START WITH 1  INCREMENT BY 1) NOT NULL,
    Obsah VARCHAR2(100) NOT NULL,
    CasZaslani TIMESTAMP NOT NULL,
    DatumZaslani TIMESTAMP NOT NULL,
    MistoZaslani VARCHAR2(25) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL,
    IDKonverzace integer NOT NULL
);


CREATE TABLE Konverzace(
    IDKonverzace integer GENERATED BY DEFAULT AS IDENTITY (START WITH 1  INCREMENT BY 1) NOT NULL,
    Nazev VARCHAR2(25) NOT NULL
);


-- Vztahy
CREATE TABLE Vztah(
    EMAIL1 VARCHAR2(50) NOT NULL,
    EMAIL2 VARCHAR2(50) NOT NULL,
    TypVztahu VARCHAR2(50) NOT NULL
);


CREATE TABLE Oznaceni(
    EMAIL VARCHAR2(50) NOT NULL,
    IDPrispevku integer NOT NULL
);


CREATE TABLE SoucastiAlba(
    IDAlba integer NOT NULL,
    IDPrispevku integer NOT NULL
);


CREATE TABLE UcastNaAkci(
    EMAIL VARCHAR2(50) NOT NULL,
    IDAkce integer NOT NULL
);


CREATE TABLE SoucastiKonverzace(
    EMAIL VARCHAR2(50) NOT NULL,
    IDKonverzace integer NOT NULL
);

-- INSERT PRIMARY KEYS TO TABLES
ALTER TABLE Uzivatel ADD CONSTRAINT PK_EMAIL PRIMARY KEY(EMAIL);
ALTER TABLE NavstevovaneSkoly ADD CONSTRAINT PK_NavstevovaneSkoly PRIMARY KEY(EMAIL, Skola);
ALTER TABLE TextovyPrispevek ADD CONSTRAINT PK_IDPrispevku PRIMARY KEY(IDPrispevku);
ALTER TABLE Fotka ADD CONSTRAINT PK_IDFotky PRIMARY KEY(IDPrispevku);
ALTER TABLE Album ADD CONSTRAINT PK_IDAlba PRIMARY KEY(IDAlba);
ALTER TABLE Akce ADD CONSTRAINT PK_IDAkce PRIMARY KEY(IDAkce);
ALTER TABLE Zprava ADD CONSTRAINT PK_IDZpravy PRIMARY KEY(IDZpravy);
ALTER TABLE Konverzace ADD CONSTRAINT PK_IDKonverzace PRIMARY KEY(IDKonverzace);

ALTER TABLE Vztah ADD CONSTRAINT PK_Vztah PRIMARY KEY(EMAIL1, EMAIL2, TypVztahu);
ALTER TABLE Oznaceni ADD CONSTRAINT PK_Oznaceni PRIMARY KEY(EMAIL, IDPrispevku);
ALTER TABLE SoucastiAlba ADD CONSTRAINT PK_SoucastiAlba PRIMARY KEY(IDAlba, IDPrispevku);
ALTER TABLE UcastNaAkci ADD CONSTRAINT PK_UcastNaAkci PRIMARY KEY(EMAIL, IDAkce);
ALTER TABLE SoucastiKonverzace ADD CONSTRAINT PK_SoucastiKonverzace PRIMARY KEY(EMAIL, IDKonverzace);

-- INSERT FOREIGN KEYS TO TABLES
ALTER TABLE NavstevovaneSkoly ADD CONSTRAINT FK_NavstevovaneSkoly FOREIGN KEY (EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE TextovyPrispevek ADD CONSTRAINT FK_EMAIL_TextovehoPrispevku FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Fotka ADD CONSTRAINT FK_EMAIL_Fotky FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Fotka ADD CONSTRAINT FK_Akce_Fotky FOREIGN KEY(IDAkce) REFERENCES Akce(IDAkce);
ALTER TABLE Album ADD CONSTRAINT FK_Email_Alba FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Album ADD CONSTRAINT FK_IDPrispevku_Alba FOREIGN KEY(IDPrispevku) REFERENCES Fotka(IDPrispevku);
ALTER TABLE Akce ADD CONSTRAINT FK_EMAIL_Akci FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Zprava ADD CONSTRAINT FK_EMAIL_Zpravy FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Zprava ADD CONSTRAINT FK_IDKonverzace_Zpravy FOREIGN KEY(IDKonverzace) REFERENCES Konverzace(IDKonverzace);
ALTER TABLE Vztah ADD CONSTRAINT FK_EMAIL_Uzivatela1 FOREIGN KEY(EMAIL1) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Vztah ADD CONSTRAINT FK_EMAIL_Uzivatela2 FOREIGN KEY(EMAIL2) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Oznaceni ADD CONSTRAINT FK_EMAIL_Oznaceni FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Oznaceni ADD CONSTRAINT FK_IDTextovehoPrispevku FOREIGN KEY(IDPrispevku) REFERENCES TextovyPrispevek(IDPrispevku);
ALTER TABLE Oznaceni ADD CONSTRAINT FK_IDFotky FOREIGN KEY(IDPrispevku) REFERENCES Fotka(IDPrispevku);
ALTER TABLE SoucastiAlba ADD CONSTRAINT FK_IDAlbaAlba FOREIGN KEY(IDAlba) REFERENCES Album(IDAlba);
ALTER TABLE SoucastiAlba ADD CONSTRAINT FK_IDPrispevkuAlba FOREIGN KEY(IDPrispevku) REFERENCES Fotka(IDPrispevku);
ALTER TABLE UcastNaAkci ADD CONSTRAINT FK_EMAIL_NaAkci FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE UcastNaAkci ADD CONSTRAINT FK_IDAkce FOREIGN KEY(IDAkce) REFERENCES Akce(IDAkce);
ALTER TABLE SoucastiKonverzace ADD CONSTRAINT FK_EMAIL_Konverzace FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE SoucastiKonverzace ADD CONSTRAINT FK_IDKonverzace_Konverzace FOREIGN KEY(IDKonverzace) REFERENCES Konverzace(IDKonverzace);


-- INSERT VALUES INTO TABLES

INSERT INTO Uzivatel(EMAIL, Jmeno, Prijmeni ,Bydliste, Zamestnani, Kontakt) VALUES('ABCD@gmail.com', 'Attila', 'Lakatos', 'Moon', 'MojaFirma s.r.o.', '+421966966325');
INSERT INTO Uzivatel(EMAIL, Jmeno, Prijmeni ,Bydliste, Zamestnani, Kontakt) VALUES('efgh@gmail.com', 'Hello', 'World', 'Earth', 'IBM s.r.o.', '123456789');
INSERT INTO Akce(Nazev, PopisAkce, CasKonani, DatumKonani, MistoKonani, EMAIL) VALUES('First action', 'Popis first action',TO_TIMESTAMP('20:00', 'HH24:MI'), TO_TIMESTAMP('27-03-2018', 'DD-MM-YYYY'), 'Brno', 'ABCD@gmail.com' );
INSERT INTO TextovyPrispevek(Obsah, CasPublikovani, DatumPublikovani, MistoPublikovani, EMAIL) VALUES ('First TextovyPrispevek', TO_TIMESTAMP('21:25', 'HH24:MI'), TO_TIMESTAMP('04-03-2018', 'DD-MM-YYYY'), 'Brno', 'ABCD@gmail.com' );
INSERT INTO Fotka(Obsah, CasPublikovani, DatumPublikovani, MistoPublikovani, EMAIL, IDAkce) VALUES ('Fotka', TO_TIMESTAMP('21:45', 'HH24:MI'), TO_TIMESTAMP('01-02-2008', 'DD-MM-YYYY'), 'Brno', 'ABCD@gmail.com',  1);


-- SHOW TABLES

SELECT A.EMAIL, A.Nazev FROM Akce A, Fotka F WHERE A.EMAIL = F.EMAIL and A.EMAIL = 'ABCD@gmail.com';
