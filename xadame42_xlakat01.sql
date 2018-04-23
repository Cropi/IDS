-- Purpose:     IDS project
-- Author(s):   xadame42
--              xlakat01
-- Date:        22.3.2018
-- Last modif.: 25.3.2018 (10:49)

-- DROP TABLES

DROP TABLE Uzivatel CASCADE CONSTRAINTS;
DROP TABLE NavstevovaneSkoly CASCADE CONSTRAINTS;
DROP TABLE Zamestnani CASCADE CONSTRAINTS;
DROP TABLE KontaktniUdaje CASCADE CONSTRAINTS;
DROP TABLE TextovyPrispevek CASCADE CONSTRAINTS;
DROP TABLE Fotka CASCADE CONSTRAINTS;
DROP TABLE Album CASCADE CONSTRAINTS;
DROP TABLE Akce CASCADE CONSTRAINTS;
DROP TABLE Zprava CASCADE CONSTRAINTS;
DROP TABLE Konverzace CASCADE CONSTRAINTS;
DROP TABLE Vztah CASCADE CONSTRAINTS;
DROP TABLE OznaceniVPrispevku CASCADE CONSTRAINTS;
DROP TABLE OznaceniNaFotce CASCADE CONSTRAINTS;
DROP TABLE SoucastiAlba CASCADE CONSTRAINTS;
DROP TABLE UcastNaAkci CASCADE CONSTRAINTS;
DROP TABLE SoucastiKonverzace CASCADE CONSTRAINTS;
-- DROP INDEX IndexVytvoril;
-- DROP TRIGGER AutoIncIDAkce;
-- DROP TRIGGER Kontrola_PSC;
DROP SEQUENCE IDAkce;

-- CREATE TABLES

CREATE TABLE Uzivatel(
    EMAIL VARCHAR2(50) NOT NULL,
    Jmeno VARCHAR2(50) NOT NULL,
    Prijmeni VARCHAR2(50) NOT NULL,
    Adresa VARCHAR2(100) NOT NULL,
    Mesto VARCHAR2(100) NOT NULL,
    PSC VARCHAR2(50) NOT NULL,
    Zeme VARCHAR2(50) NOT NULL
);


CREATE TABLE NavstevovaneSkoly(
    EMAIL VARCHAR2(50) NOT NULL,
    Skola VARCHAR2(50) NOT NULL
);


CREATE TABLE Zamestnani(
    EMAIL VARCHAR2(50) NOT NULL,
    Spolecnost VARCHAR2(50) NOT NULL,
    Pozice VARCHAR2(50) NOT NULL
);


CREATE TABLE KontaktniUdaje(
    EMAIL VARCHAR2(50) NOT NULL,
    Kontakt VARCHAR2(50) NOT NULL
);


CREATE TABLE TextovyPrispevek(
    IDPrispevku INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 1  INCREMENT BY 1) NOT NULL,
    Obsah VARCHAR2(500) NOT NULL,
    CasADatumPublikovani TIMESTAMP NOT NULL,
    MistoPublikovani VARCHAR2(50) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL
);


CREATE TABLE Fotka(
    IDFotky INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 1  INCREMENT BY 1) NOT NULL,
    Obsah VARCHAR2(500) NOT NULL,
    Soubor BLOB NOT NULL,
    CasADatumPublikovani TIMESTAMP NOT NULL,
    MistoPublikovani VARCHAR2(50) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL,
    IDAkce INTEGER -- vyfocena v ramci akce
);


CREATE TABLE Album(
    IDAlba INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 1  INCREMENT BY 1) NOT NULL,
    Nazev VARCHAR2(50) NOT NULL,
    Popis VARCHAR2(100) NOT NULL,
    NastaveniSoukromi VARCHAR2(10) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL, -- vytvoril
    IDFotky INTEGER NOT NULL -- titulni fotka
);


CREATE TABLE Akce(
    IDAkce INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 1  INCREMENT BY 1) NOT NULL,
    Nazev VARCHAR2(50) NOT NULL,
    PopisAkce VARCHAR2(100) NOT NULL,
    CasADatumKonani TIMESTAMP NOT NULL,
    MistoKonani VARCHAR2(50) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL -- vytvoril
);


CREATE TABLE Zprava(
    IDZpravy INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 1  INCREMENT BY 1) NOT NULL,
    Obsah VARCHAR2(500) NOT NULL,
    CasADatumZaslani TIMESTAMP NOT NULL,
    MistoZaslani VARCHAR2(50) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL, -- odesilatel
    IDKonverzace INTEGER NOT NULL
);


CREATE TABLE Konverzace(
    IDKonverzace INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 1  INCREMENT BY 1) NOT NULL,
    Nazev VARCHAR2(50) NOT NULL
);


-- Vztahy
CREATE TABLE Vztah(
    EMAIL1 VARCHAR2(50) NOT NULL,
    EMAIL2 VARCHAR2(50) NOT NULL,
    TypVztahu VARCHAR2(50) NOT NULL
);


CREATE TABLE OznaceniVPrispevku(
    EMAIL VARCHAR2(50) NOT NULL,
    IDPrispevku INTEGER NOT NULL
);


CREATE TABLE OznaceniNaFotce(
    EMAIL VARCHAR2(50) NOT NULL,
    IDFotky INTEGER NOT NULL
);


CREATE TABLE SoucastiAlba(
    IDAlba INTEGER NOT NULL,
    IDFotky INTEGER NOT NULL
);


CREATE TABLE UcastNaAkci(
    EMAIL VARCHAR2(50) NOT NULL,
    IDAkce INTEGER NOT NULL
);


CREATE TABLE SoucastiKonverzace(
    EMAIL VARCHAR2(50) NOT NULL,
    IDKonverzace INTEGER NOT NULL
);

-- SANITY CHECK
ALTER TABLE Uzivatel ADD CONSTRAINT CHK_EMAIL CHECK (EMAIL LIKE '%_@_%.__%');

-- INSERT PRIMARY KEYS TO TABLES
ALTER TABLE Uzivatel ADD CONSTRAINT PK_EMAIL PRIMARY KEY(EMAIL);
ALTER TABLE NavstevovaneSkoly ADD CONSTRAINT PK_NavstevovaneSkoly PRIMARY KEY(EMAIL, Skola);
ALTER TABLE Zamestnani ADD CONSTRAINT PK_Zamestnani PRIMARY KEY(EMAIL, Spolecnost, Pozice);
ALTER TABLE KontaktniUdaje ADD CONSTRAINT PK_KontaktniUdaje PRIMARY KEY(EMAIL, Kontakt);

ALTER TABLE TextovyPrispevek ADD CONSTRAINT PK_IDPrispevku PRIMARY KEY(IDPrispevku);
ALTER TABLE Fotka ADD CONSTRAINT PK_IDFotky PRIMARY KEY(IDFotky);
ALTER TABLE Album ADD CONSTRAINT PK_IDAlba PRIMARY KEY(IDAlba);
ALTER TABLE Akce ADD CONSTRAINT PK_IDAkce PRIMARY KEY(IDAkce);
ALTER TABLE Zprava ADD CONSTRAINT PK_IDZpravy PRIMARY KEY(IDZpravy);

ALTER TABLE Konverzace ADD CONSTRAINT PK_IDKonverzace PRIMARY KEY(IDKonverzace);
ALTER TABLE Vztah ADD CONSTRAINT PK_Vztah PRIMARY KEY(EMAIL1, EMAIL2, TypVztahu);
ALTER TABLE OznaceniVPrispevku ADD CONSTRAINT PK_OznaceniVPrispevku PRIMARY KEY(EMAIL, IDPrispevku);
ALTER TABLE OznaceniNaFotce ADD CONSTRAINT PK_OznaceniNaFotce PRIMARY KEY(EMAIL, IDFotky);
ALTER TABLE SoucastiAlba ADD CONSTRAINT PK_SoucastiAlba PRIMARY KEY(IDAlba, IDFotky);
ALTER TABLE UcastNaAkci ADD CONSTRAINT PK_UcastNaAkci PRIMARY KEY(EMAIL, IDAkce);
ALTER TABLE SoucastiKonverzace ADD CONSTRAINT PK_SoucastiKonverzace PRIMARY KEY(EMAIL, IDKonverzace);

-- INSERT FOREIGN KEYS TO TABLES
ALTER TABLE NavstevovaneSkoly ADD CONSTRAINT FK_NavstevovaneSkoly FOREIGN KEY (EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Zamestnani ADD CONSTRAINT FK_Zamestnani FOREIGN KEY (EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE KontaktniUdaje ADD CONSTRAINT FK_KontaktniUdaje FOREIGN KEY (EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE TextovyPrispevek ADD CONSTRAINT FK_EMAIL_TextovehoPrispevku FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Fotka ADD CONSTRAINT FK_EMAIL_Fotky FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);

ALTER TABLE Fotka ADD CONSTRAINT FK_Akce_Fotky FOREIGN KEY(IDAkce) REFERENCES Akce(IDAkce);
ALTER TABLE Album ADD CONSTRAINT FK_Email_Alba FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Album ADD CONSTRAINT FK_IDPrispevku_Alba FOREIGN KEY(IDFotky) REFERENCES Fotka(IDFotky);
ALTER TABLE Akce ADD CONSTRAINT FK_EMAIL_Akci FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Zprava ADD CONSTRAINT FK_EMAIL_Zpravy FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);

ALTER TABLE Zprava ADD CONSTRAINT FK_IDKonverzace_Zpravy FOREIGN KEY(IDKonverzace) REFERENCES Konverzace(IDKonverzace);
ALTER TABLE Vztah ADD CONSTRAINT FK_EMAIL_Uzivatela1 FOREIGN KEY(EMAIL1) REFERENCES Uzivatel(EMAIL);
ALTER TABLE Vztah ADD CONSTRAINT FK_EMAIL_Uzivatela2 FOREIGN KEY(EMAIL2) REFERENCES Uzivatel(EMAIL);
ALTER TABLE OznaceniVPrispevku ADD CONSTRAINT FK_EMAIL_OznaceniVPrispevku FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE OznaceniVPrispevku ADD CONSTRAINT FK_IDTextovehoPrispevku FOREIGN KEY(IDPrispevku) REFERENCES TextovyPrispevek(IDPrispevku);

ALTER TABLE OznaceniNaFotce ADD CONSTRAINT FK_EMAIL_OznaceniNaFotce FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE OznaceniNaFotce ADD CONSTRAINT FK_IDFotky FOREIGN KEY(IDFotky) REFERENCES Fotka(IDFotky);
ALTER TABLE SoucastiAlba ADD CONSTRAINT FK_IDAlbaAlba FOREIGN KEY(IDAlba) REFERENCES Album(IDAlba);
ALTER TABLE SoucastiAlba ADD CONSTRAINT FK_IDPrispevkuAlba FOREIGN KEY(IDFotky) REFERENCES Fotka(IDFotky);
ALTER TABLE UcastNaAkci ADD CONSTRAINT FK_EMAIL_NaAkci FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);

ALTER TABLE UcastNaAkci ADD CONSTRAINT FK_IDAkce FOREIGN KEY(IDAkce) REFERENCES Akce(IDAkce);
ALTER TABLE SoucastiKonverzace ADD CONSTRAINT FK_EMAIL_Konverzace FOREIGN KEY(EMAIL) REFERENCES Uzivatel(EMAIL);
ALTER TABLE SoucastiKonverzace ADD CONSTRAINT FK_IDKonverzace_Konverzace FOREIGN KEY(IDKonverzace) REFERENCES Konverzace(IDKonverzace);


-- INSERT VALUES INTO TABLES

INSERT INTO Uzivatel(EMAIL, Jmeno, Prijmeni, Adresa, Mesto, PSC, Zeme) VALUES('ABCD@gmail.com', 'Attila', 'Lakatos', 'Craterstreet 65', 'Moonopolis', '66666', 'Moon');
INSERT INTO Zamestnani(EMAIL, Spolecnost, Pozice) VALUES('ABCD@gmail.com', 'MojaFirma s.r.o.', 'Uklizecka');
INSERT INTO Akce(Nazev, PopisAkce, CasADatumKonani, MistoKonani, EMAIL) VALUES('Imagine Dragons concert', 'Popis Imagine Dragons concert', TO_TIMESTAMP('20:00 27-03-2018', 'HH24:MI DD-MM-YYYY'), 'Brno', 'ABCD@gmail.com' );
INSERT INTO TextovyPrispevek(Obsah, CasADatumPublikovani, MistoPublikovani, EMAIL) VALUES ('First TextovyPrispevek', TO_TIMESTAMP('21:25 04-03-2018', 'HH24:MI DD-MM-YYYY'), 'Brno', 'ABCD@gmail.com' );
INSERT INTO Fotka(Obsah, Soubor, CasADatumPublikovani, MistoPublikovani, EMAIL) VALUES ('Fotka', RAWTOHEX('Test'), TO_TIMESTAMP('21:45 01-02-2008', 'HH24:MI DD-MM-YYYY'), 'Brno', 'ABCD@gmail.com');
INSERT INTO Uzivatel(EMAIL, Jmeno, Prijmeni, Adresa, Mesto, PSC, Zeme) VALUES('jane.doe@fakemail.com', 'Jane', 'Doe', 'Notastreet 32', 'London', '78865', 'United Kingdom');
INSERT INTO Uzivatel(EMAIL, Jmeno, Prijmeni, Adresa, Mesto, PSC, Zeme) VALUES('greg.strongman@fakemail.com', 'Gregor', 'Strongman', 'Paperstreet 17', 'New York City', '89223', 'New York');
INSERT INTO NavstevovaneSkoly(EMAIL, Skola) VALUES('greg.strongman@fakemail.com', 'Harvard');
INSERT INTO NavstevovaneSkoly(EMAIL, Skola) VALUES('greg.strongman@fakemail.com', 'Yale');
INSERT INTO NavstevovaneSkoly(EMAIL, Skola) VALUES('greg.strongman@fakemail.com', 'Oxford');
INSERT INTO Zamestnani(EMAIL, Spolecnost, Pozice) VALUES('greg.strongman@fakemail.com', 'The Boring Company', 'Secret stuff');
INSERT INTO KontaktniUdaje(EMAIL, Kontakt) VALUES('greg.strongman@fakemail.com', 'gregbomb.tumblr.com');
INSERT INTO KontaktniUdaje(EMAIL, Kontakt) VALUES('greg.strongman@fakemail.com', 'gregsite.com');
INSERT INTO TextovyPrispevek(Obsah, CasADatumPublikovani, MistoPublikovani, EMAIL) VALUES('So this is the next big thing? Looks dead in here...', TO_TIMESTAMP('20:00 31-03-2018', 'HH24:MI DD-MM-YYYY'), 'Washington', 'greg.strongman@fakemail.com');
INSERT INTO Fotka(Obsah, Soubor, CasADatumPublikovani, MistoPublikovani, EMAIL) VALUES('Just me', RAWTOHEX('Test'), TO_TIMESTAMP('20:00 31-03-2018', 'HH24:MI DD-MM-YYYY'), 'Washington', 'greg.strongman@fakemail.com');
INSERT INTO Fotka(Obsah, Soubor, CasADatumPublikovani, MistoPublikovani, EMAIL) VALUES('Me and my pugs', RAWTOHEX('Test'), TO_TIMESTAMP('20:00 31-03-2018', 'HH24:MI DD-MM-YYYY'), 'Washington', 'greg.strongman@fakemail.com');
INSERT INTO Album(Nazev, Popis, NastaveniSoukromi, EMAIL, IDFotky) VALUES('Traveling', 'Around the world, around the world...', 'Public', 'greg.strongman@fakemail.com', 1);
INSERT INTO Akce(Nazev, PopisAkce, CasADatumKonani, MistoKonani, EMAIL) VALUES('Ukulele Party', 'Only for ukulele enthusiasts', TO_TIMESTAMP('21:25 01-04-2018', 'HH24:MI DD-MM-YYYY'), 'Miami Beach', 'greg.strongman@fakemail.com');
INSERT INTO Akce(Nazev, PopisAkce, CasADatumKonani, MistoKonani, EMAIL) VALUES('Graduation ceremony', 'Graduated at VUT FIT', TO_TIMESTAMP('14:00 03-04-2018', 'HH24:MI DD-MM-YYYY'), 'Brno', 'greg.strongman@fakemail.com');
INSERT INTO Konverzace(Nazev) VALUES('Smalltalk');
INSERT INTO Konverzace(Nazev) VALUES('ProjectGroup');
INSERT INTO SoucastiKonverzace(EMAIL, IDKonverzace) VALUES('greg.strongman@fakemail.com', 2);
INSERT INTO SoucastiKonverzace(EMAIL, IDKonverzace) VALUES('ABCD@gmail.com', 2);
INSERT INTO Zprava(Obsah, CasADatumZaslani, MistoZaslani, EMAIL, IDKonverzace) VALUES('Hello, how old are you?', TO_TIMESTAMP('18:00 24-01-2018', 'HH24:MI DD-MM-YYYY'), 'Praha', 'greg.strongman@fakemail.com', 2);
INSERT INTO Zprava(Obsah, CasADatumZaslani, MistoZaslani, EMAIL, IDKonverzace) VALUES('Hi, I am 16 and you?', TO_TIMESTAMP('18:01 24-01-2018', 'HH24:MI DD-MM-YYYY'), 'Olomouc', 'ABCD@gmail.com', 2);
INSERT INTO Zprava(Obsah, CasADatumZaslani, MistoZaslani, EMAIL, IDKonverzace) VALUES('Hello Jane! Long time no see', TO_TIMESTAMP('20:00 31-03-2018', 'HH24:MI DD-MM-YYYY'), 'London', 'greg.strongman@fakemail.com', 1);
INSERT INTO Zprava(Obsah, CasADatumZaslani, MistoZaslani, EMAIL, IDKonverzace) VALUES('Hello Greg! How are you', TO_TIMESTAMP('20:01 31-03-2018', 'HH24:MI DD-MM-YYYY'), 'Berlin', 'jane.doe@fakemail.com', 1);
INSERT INTO Zprava(Obsah, CasADatumZaslani, MistoZaslani, EMAIL, IDKonverzace) VALUES('I am fine thanks, and you?', TO_TIMESTAMP('20:02 31-03-2018', 'HH24:MI DD-MM-YYYY'), 'London', 'greg.strongman@fakemail.com', 1);
INSERT INTO Zprava(Obsah, CasADatumZaslani, MistoZaslani, EMAIL, IDKonverzace) VALUES('Me too :)', TO_TIMESTAMP('20:03 31-03-2018', 'HH24:MI DD-MM-YYYY'), 'Berlin', 'jane.doe@fakemail.com', 1);
INSERT INTO OznaceniVPrispevku(EMAIL, IDPrispevku) VALUES('greg.strongman@fakemail.com', 2);
INSERT INTO OznaceniNaFotce(EMAIL, IDFotky) VALUES('greg.strongman@fakemail.com', 1);
INSERT INTO SoucastiAlba(IDAlba, IDFotky) VALUES(1, 1);
INSERT INTO SoucastiAlba(IDAlba, IDFotky) VALUES(1, 2);
INSERT INTO UcastNaAkci(EMAIL, IDAkce) VALUES('greg.strongman@fakemail.com', 1);
INSERT INTO UcastNaAkci(EMAIL, IDAkce) VALUES('ABCD@gmail.com', 1);
INSERT INTO UcastNaAkci(EMAIL, IDAkce) VALUES('ABCD@gmail.com', 2);
INSERT INTO SoucastiKonverzace(EMAIL, IDKonverzace) VALUES('greg.strongman@fakemail.com', 1);
INSERT INTO NavstevovaneSkoly(EMAIL, Skola) VALUES('jane.doe@fakemail.com', 'MIT');
INSERT INTO Zamestnani(EMAIL, Spolecnost, Pozice) VALUES('jane.doe@fakemail.com', 'Very colorful socks inc.', 'Manager');
INSERT INTO KontaktniUdaje(EMAIL, Kontakt) VALUES('jane.doe@fakemail.com', 'twitter.com/janedoe');
INSERT INTO KontaktniUdaje(EMAIL, Kontakt) VALUES('jane.doe@fakemail.com', '00421910543632');
INSERT INTO TextovyPrispevek(Obsah, CasADatumPublikovani, MistoPublikovani, EMAIL) VALUES('How do I delete my account from this horrible website?', TO_TIMESTAMP('20:00 31-03-2018', 'HH24:MI DD-MM-YYYY'), 'Manchester', 'jane.doe@fakemail.com');
INSERT INTO Fotka(Obsah, Soubor, CasADatumPublikovani, MistoPublikovani, EMAIL) VALUES('Raining in London, how surprising', RAWTOHEX('Test'), TO_TIMESTAMP('20:00 31-03-2018', 'HH24:MI DD-MM-YYYY'), 'London', 'jane.doe@fakemail.com');
INSERT INTO Album(Nazev, Popis, NastaveniSoukromi, EMAIL, IDFotky) VALUES('Beauty of UK', 'Long live the queen', 'Public', 'jane.doe@fakemail.com', 3);
INSERT INTO SoucastiAlba(IDAlba, IDFotky) VALUES(2, 3);
INSERT INTO SoucastiKonverzace(EMAIL, IDKonverzace) VALUES('jane.doe@fakemail.com', 1);
INSERT INTO Vztah(EMAIL1, EMAIL2, TypVztahu) VALUES('greg.strongman@fakemail.com', 'jane.doe@fakemail.com', 'Friends');
INSERT INTO Vztah(EMAIL1, EMAIL2, TypVztahu) VALUES('greg.strongman@fakemail.com', 'jane.doe@fakemail.com', 'Its complicated');
INSERT INTO Uzivatel(EMAIL, Jmeno, Prijmeni, Adresa, Mesto, PSC, Zeme) VALUES('donjohn@fakemail.com', 'John', 'Spielberg', 'Central Park', 'New York City', '89223', 'New York');
INSERT INTO Uzivatel(EMAIL, Jmeno, Prijmeni, Adresa, Mesto, PSC, Zeme) VALUES('marge@fakemail.com', 'Margarita', 'Strawman', 'Shortstreet 5', 'London', '55514', 'United Kingdom');
INSERT INTO Uzivatel(EMAIL, Jmeno, Prijmeni, Adresa, Mesto, PSC, Zeme) VALUES('sharkbiscuit@fakemail.com', 'Jerry', 'Smith', 'Streetystreet 11', 'Sydney', '99587', 'Australia');
INSERT INTO SoucastiKonverzace(EMAIL, IDKonverzace) VALUES('marge@fakemail.com', 1);
INSERT INTO SoucastiKonverzace(EMAIL, IDKonverzace) VALUES('sharkbiscuit@fakemail.com', 1);

-- 3rd part of the project
-- SELECT (A JOIN B) 1st
-- Vypise navstevovane skoly uzivatele Gregor Strongman
SELECT Skola
FROM Uzivatel NATURAL JOIN NavstevovaneSkoly
WHERE Jmeno = 'Gregor' AND Prijmeni='Strongman';


-- SELECT (A JOIN B) 2nd
-- Vypise email, jmeno, prijmeni uzivatelu, kteri publikovali alespon jeden TextovyPrispevek mezi 02.03.2018 a 05.03.2018
SELECT DISTINCT EMAIL, Jmeno, Prijmeni
FROM Uzivatel NATURAL JOIN TextovyPrispevek
WHERE CasADatumPublikovani BETWEEN '02-MAR-18' AND '05-MAR-18';


-- SELECT (A JOIN B JOIN C)
-- Vypise vsechny uzivatele (a nazvy akci), kteri se zucastnili na nejake akci v Brne
SELECT DISTINCT Jmeno, Prijmeni, Nazev
FROM  Uzivatel NATURAL JOIN UcastNaAkci U INNER JOIN Akce A ON U.IDAkce = A.IDAkce
WHERE MistoKonani = 'Brno';


-- SELECT GROUP BY + AGR 1st
-- Kolik akci vytvorili jednotlivi klienti?
SELECT Jmeno, Prijmeni, COUNT(IDAkce) as PocetVytvorenychAkci
FROM Uzivatel NATURAL JOIN Akce
GROUP BY Jmeno, Prijmeni
ORDER BY PocetVytvorenychAkci DESC;


-- SELECT EXISTS
-- Kteri uzivatele jsou soucasti konverzace 'Smalltalk', ale nejsou v zadne jine?
SELECT DISTINCT Jmeno, Prijmeni, Adresa, Mesto ,PSC, Zeme
FROM Uzivatel U, SoucastiKonverzace S, Konverzace K
WHERE U.EMAIL = S.EMAIL AND S.IDKonverzace = K.IDKonverzace AND Nazev='Smalltalk' AND
    NOT EXISTS(SELECT * FROM Konverzace K NATURAL JOIN SoucastiKonverzace S WHERE S.EMAIL = U.EMAIL AND K.Nazev <> 'Smalltalk');


-- SELECT IN
-- Kteri klienti byli oznaceni v Textovem prispevku ve meste 'Washington'?
SELECT * FROM Uzivatel WHERE EMAIL IN
    (SELECT EMAIL FROM OznaceniVPrispevku where IDPrispevku IN
        (SELECT IDPrispevku FROM TextovyPrispevek WHERE MistoPublikovani='Washington'));

-- ------------------------------------ --
-- LAST PART OF THE PROJECT STARTS HERE --
-- ------------------------------------ --


CREATE SEQUENCE IDAkce START WITH 50 INCREMENT BY 1;
-- Trigger na auto inkrementaciu cisel Akcii pri vkladani do tabulky
CREATE OR REPLACE TRIGGER AutoIncIDAkce
    BEFORE INSERT ON Akce
    FOR EACH ROW
BEGIN
    :NEW.IDAkce := IDAkce.nextval;
END;
/

INSERT INTO Akce(Nazev, PopisAkce, CasADatumKonani, MistoKonani, EMAIL) VALUES('IDS-4', '4th parth of the project', TO_TIMESTAMP('23:59 01-05-2018', 'HH24:MI DD-MM-YYYY'), 'Brno', 'greg.strongman@fakemail.com');
INSERT INTO Akce(Nazev, PopisAkce, CasADatumKonani, MistoKonani, EMAIL) VALUES('IDS-5', 'Last parth of the project', TO_TIMESTAMP('23:59 01-05-2018', 'HH24:MI DD-MM-YYYY'), 'Brno', 'greg.strongman@fakemail.com');
INSERT INTO Akce(Nazev, PopisAkce, CasADatumKonani, MistoKonani, EMAIL) VALUES('IDS-3', '3rd parth of the project', TO_TIMESTAMP('23:59 15-04-2018', 'HH24:MI DD-MM-YYYY'), 'Brno', 'greg.strongman@fakemail.com');

SELECT *
FROM Akce
WHERE IDAkce BETWEEN 50 AND 70;


-- Trigger na kontrolu PSC
CREATE OR REPLACE TRIGGER Kontrola_PSC
    BEFORE INSERT OR UPDATE OF PSC on Uzivatel
    FOR EACH ROW
DECLARE
    PSC Uzivatel.PSC%TYPE;
BEGIN
    IF (LENGTH(PSC) <> 5)
        THEN raise_application_error(-1, 'PSC je ve spatnem formatu(000 00 - 999 99)');
    END IF;

    IF (PSC < 0 OR PSC > 99999)
        THEN raise_application_error(-2, 'PSC je ve spatnem formatu(000 00 - 999 99)');
    END IF;
END;
/


-- Procedura, ktera vypise pocet akcii v meste Brno a jeho procentularni vyjadreni
CREATE OR REPLACE PROCEDURE Aktualne_Akce(HledaneMisto IN VARCHAR2)
IS
    CURSOR AktAkce IS SELECT * FROM Akce;
    AktualniAkce AktAkce%ROWTYPE;
    PocetVsetkychAkcii NUMBER;
    PocetHladanychAkci NUMBER;
BEGIN
    PocetVsetkychAkcii := 0;
    PocetHladanychAkci := 0;
    OPEN AktAkce;
    LOOP
        FETCH AktAkce INTO AktualniAkce;
        EXIT WHEN AktAkce%NOTFOUND;

        IF (AktualniAkce.MistoKonani IS NOT NULL) THEN
            PocetVsetkychAkcii := PocetVsetkychAkcii + 1;
        END IF;

        IF (AktualniAkce.MistoKonani LIKE HledaneMisto) THEN
            PocetHladanychAkci := PocetHladanychAkci + 1;
        END IF;
    END LOOP;
    CLOSE AktAkce;

    dbms_output.put_line('Pocet akcii v meste ' || HledaneMisto || ' je: ' || PocetHladanychAkci);
    dbms_output.put_line('Procentularni vyjadreni akcii v meste Brno je: ' || ROUND((PocetHladanychAkci / PocetVsetkychAkcii)*100, 2));
    dbms_output.put_line('Pocet vsetkych akcii je: ' || PocetVsetkychAkcii);

EXCEPTION
    WHEN ZERO_DIVIDE THEN
        dbms_output.put_line('Pocet vsetkych akcii je 0.');
END;
/

-- Ukazka procedury 1
exec Aktualne_Akce('Brno');


-- Procedura, ktera vypise vsechny uzivatele, kteri zadali nespravne kontaktni udaje a statisku o kontaktnich udajov
CREATE OR REPLACE PROCEDURE PrehledKontaktnichUdaju
IS
    CURSOR Kontakt IS SELECT * FROM KontaktniUdaje;
    SeznamKontaktu Kontakt%ROWTYPE;
    PocetEmailov NUMBER;
    PocetTelefonnichCisel NUMBER;
    PocetAccountov NUMBER; -- Facebook, Twitter...
    PocetNespravneZadanich NUMBER;
    PocetWebovychStranek NUMBER;
BEGIN
    PocetEmailov := 0;
    PocetTelefonnichCisel := 0;
    PocetAccountov := 0;
    PocetNespravneZadanich := 0;
    PocetWebovychStranek := 0;

    OPEN Kontakt;
    LOOP
        FETCH Kontakt INTO SeznamKontaktu;
        EXIT WHEN Kontakt%NOTFOUND;

        IF (SeznamKontaktu.Kontakt LIKE '%_@_%.__%') THEN
            PocetEmailov := PocetEmailov + 1;
        ELSE
            IF (LENGTH(SeznamKontaktu.Kontakt) = 14 AND (SeznamKontaktu.Kontakt LIKE '0%' OR SeznamKontaktu.Kontakt LIKE '+%')) THEN
                PocetTelefonnichCisel := PocetTelefonnichCisel + 1;
            ELSE
                IF (SUBSTR(SeznamKontaktu.Kontakt, 0, 13) = 'facebook.com/' OR SUBSTR(SeznamKontaktu.Kontakt, 0, 12) = 'twitter.com/') THEN
                    IF ((SeznamKontaktu.Kontakt LIKE 'facebook.com/%' AND LENGTH(SeznamKontaktu.Kontakt) > 13) OR (SeznamKontaktu.Kontakt LIKE 'twitter.com/%' AND LENGTH(SeznamKontaktu.Kontakt) > 12)) THEN
                        PocetAccountov := PocetAccountov + 1;
                    ELSE
                        PocetNespravneZadanich := PocetNespravneZadanich + 1;
                        dbms_output.put_line('Uzivatel s emailem: ' || SeznamKontaktu.EMAIL || ' zadal nespravne kontaktni udaje: ' || SeznamKontaktu.Kontakt);
                    END IF;
                ELSE
                    IF (SeznamKontaktu.Kontakt LIKE '_%.__%') THEN
                        PocetWebovychStranek := PocetWebovychStranek + 1;
                    ELSE
                        dbms_output.put_line('Uzivatel s emailem: ' || SeznamKontaktu.EMAIL || ' zadal nespravne kontaktni udaje: ' || SeznamKontaktu.Kontakt);
                        PocetNespravneZadanich := PocetNespravneZadanich + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END LOOP;

    CLOSE Kontakt;

    dbms_output.put_line('Pocet kontaktnich emailov: ' || PocetEmailov);
    dbms_output.put_line('Pocet telefonnich cisel: ' || PocetTelefonnichCisel);
    dbms_output.put_line('Pocet accountov: ' || PocetAccountov);
    dbms_output.put_line('Pocet webovych stranek: ' || PocetWebovychStranek);
    dbms_output.put_line('Pocet nespravne zadanich kont.' || PocetNespravneZadanich);
END;
/


-- Ukazka: Zadame 3 nespravne kontaktni udaje a ukazeme, ze nasa procedura detekuje
INSERT INTO KontaktniUdaje(EMAIL, Kontakt) VALUES('greg.strongman@fakemail.com', '+42093642365'); -- o 1 cislo menej
INSERT INTO KontaktniUdaje(EMAIL, Kontakt) VALUES('ABCD@gmail.com', 'failedtestcom'); -- zde chybi tecka pred 'com'
INSERT INTO KontaktniUdaje(EMAIL, Kontakt) VALUES('jane.doe@fakemail.com', 'facebook.com/'); -- za facebook.com/ procedura ocekava este jmeno uzivatela

-- Ukazka procedury 2
exec PrehledKontaktnichUdaju;



/* Priklad na EXPLAIN PLAN A CREATE INDEX
DROP INDEX IndexAkce;

EXPLAIN PLAN FOR SELECT A.Nazev, COUNT(U.EMAIL) as PocetUcastnikov FROM UcastNaAkci U INNER JOIN Akce A ON U.IDAkce = A.IDAkce GROUP BY A.Nazev;
SELECT plan_table_output FROM TABLE(dbms_xplan.display());

CREATE INDEX IndexAkce ON UcastNaAkci(IDAkce);


EXPLAIN PLAN FOR SELECT A.Nazev, COUNT(U.EMAIL) as PocetUcastnikov FROM UcastNaAkci U INNER JOIN Akce A ON U.IDAkce = A.IDAkce GROUP BY A.Nazev;
SELECT plan_table_output FROM TABLE(dbms_xplan.display());
*/

-- Priklad na EXPLAIN PLAN A CREATE INDEX
-- Vysledkem z tychto dvoch tabulek je ze sloupec TABLE ACESS FULL se zmeni na TABLE ACESS BY INDEX ROWID BATCHED => Je zrejme, ze system pouzil nas CREATE INDEX a zatizeni systemu se zmensil
EXPLAIN PLAN FOR SELECT U.Jmeno, U. Prijmeni, COUNT(A.Nazev) FROM Uzivatel U NATURAL JOIN Akce A WHERE Nazev = 'Imagine Dragons concert' GROUP BY Jmeno, Prijmeni;
SELECT plan_table_output FROM TABLE(dbms_xplan.display());

CREATE INDEX IndexVytvoril ON Akce(Nazev);

EXPLAIN PLAN FOR SELECT U.Jmeno, U. Prijmeni, COUNT(A.Nazev) FROM Uzivatel U NATURAL JOIN Akce A WHERE Nazev = 'Imagine Dragons concert' GROUP BY Jmeno, Prijmeni;
SELECT plan_table_output FROM TABLE(dbms_xplan.display());



-- Definice pristupovych prav k databazovym objektum pro druheho clena tymu
GRANT ALL ON Uzivatel TO xadame42;
GRANT ALL ON NavstevovaneSkoly TO xadame42;
GRANT ALL ON Zamestnani TO xadame42;
GRANT ALL ON KontaktniUdaje TO xadame42;
GRANT ALL ON TextovyPrispevek TO xadame42;
GRANT ALL ON Fotka TO xadame42;
GRANT ALL ON Album TO xadame42;
GRANT ALL ON Akce TO xadame42;
GRANT ALL ON Zprava TO xadame42;
GRANT ALL ON Konverzace TO xadame42;
GRANT ALL ON Vztah TO xadame42;
GRANT ALL ON OznaceniVPrispevku TO xadame42;
GRANT ALL ON OznaceniNaFotce TO xadame42;
GRANT ALL ON SoucastiAlba TO xadame42;
GRANT ALL ON UcastNaAkci TO xadame42;
GRANT ALL ON SoucastiKonverzace TO xadame42;

GRANT EXECUTE ON PrehledKontaktnichUdaju TO xadame42;
GRANT EXECUTE ON Aktualne_Akce TO xadame42;




-- Ukazka na Materializovany prehled
DROP MATERIALIZED VIEW MaterializovanyPohledTest;
CREATE MATERIALIZED VIEW LOG ON Uzivatel WITH PRIMARY KEY, ROWID(Jmeno) INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW MaterializovanyPohledTest BUILD IMMEDIATE REFRESH FAST ON COMMIT AS SELECT * FROM xlakat01.Uzivatel WHERE Jmeno='Test_Materialized_View';
GRANT ALL ON MaterializovanyPohledTest TO xadame42;

-- Tabulka este neobsahuje ani jeden radek s Jmenem 'Test_Materialized_View'
SELECT * FROM Uzivatel WHERE Jmeno='Test_Materialized_View';
SELECT * FROM MaterializovanyPohledTest;

-- Vlozime Uzivatel s Jmenem 'Test_Materialized_View'
INSERT INTO xlakat01.Uzivatel(EMAIL, Jmeno, Prijmeni, Adresa, Mesto, PSC, Zeme) VALUES('Test_Mat@gmail.com', 'Test_Materialized_View', 'Nothing', 'Craterstreet 65', 'Moonopolis', '94612', 'Moon');

-- MaterializovanyPohledTest bude obsahovat 'Test_Materialized_View' len po COMMITu
SELECT * FROM Uzivatel WHERE Jmeno='Test_Materialized_View';
SELECT * FROM MaterializovanyPohledTest;

COMMIT;

SELECT * FROM Uzivatel WHERE Jmeno='Test_Materialized_View';
SELECT * FROM MaterializovanyPohledTest;
--
