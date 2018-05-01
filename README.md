# IDS Dokumentace

## Převod vztahu generalizace/specializace

![prevod vztahu](erd_social.png)

Pro převod vztahu generalizace/specializace jsme zvolili metodu převedení do dvou tabulek. Tento spůdob jsme zvolili, protože naše specializace jsou disjunktní a také jelikož entita Fotka má vztahy ještě s entitami Album a Akce, a musí do ní být uložen soubor (fotka), tak použitím dvou tabulek zamezíme vytváření prázdných míst.

## EXPLAIN PLAN
Pomocí EXPLAIN PLAN získáme plán jak databáze zpracovává daný dotaz. Demonstrovali jsme na jednoduchém SELECT dotaze. Nejprve jsme spustili EXPLAIN PLAN bez použití indexů, následně jsme nadefinovali index a spustili jsme EXPLAIN PLAN znovu.

Výsledná tabulka bez použití indexů vypadá takto:
![before](before.png)

Výsledná tabulka s použitím indexů:
![after](after.png)

SELECT STATEMENT značí, že se uskutečnil SELECT dotaz. HASH GROUP BY znamená, že se shromážďuje podle hashovacího klíče, dále jsou zde 2x NESTED LOOPS, což znamená, že se spojily 2 tabulky (NATURAL JOIN).
Při používání EXPLAIN PLAN bez indexu máme TABLE ACCESS FULL, což znamená, že naše tabulka obsahuje malý počet řádků, v tomto případě prochází tabulka od začátku bez používání indexů.
V druhé tabulce se vykonával TABLE ACCESS BY INDEX ROWID BATCHED, který značí, že se přistupuje do tabulky přes konkrétní řádek (použil se náš index).
Díky tomu se snížila "cena", ale na druhé straně %CPU se zvětšilo. INDEX UNIQUE SCAN značí přístup k tabulkám přes B-strom.

## Procedury
Podľa zadania projektu sme vytvorili 2 procedury. V každej procedure sme používali kurzor, aby sme boli schopný pracovať s riadkami v databáze a premenná s datovým typom odkazujúcim na riadok tabulky.
Prvá procedura vypíše počet akcii v meste Brno a jeho procentularní vyjádrení na dbms_output. Ošetrili sme i prípad delenia nulou, ktorý sa može nastať tedy, keď informačný systém neobsahuje žiadne akcie. Hodnoty sú zaokrúhlené na 2 desatinne miesta.
Druhá procedura vypíše všetkých uzivatelov, ktori zadali nesprávne kontaktné udaje a statisku o kontaktnich udajov. Náš systém umožňuje zadať rozné kontaktné údaje, akor sú napríklad: telefonné číslo, email, webová stránka, atď a táto procedura detekuje nesprávne zadané hodnoty.

## Triggery
Prvým triggerom vyplívajúcim zo zadania projektu bol trigger na auinkrementáciu primárného klúča. Taktiež sme vytvorili sekvenciu kvoli uchovaniu posleného čísla. Táto procedura bola aplikovaná na sloupec IDAkce z tabulky Akce.

Posledný trigger overoval, zda sú čísla PSČ zadané v správnem tvaru. Trigger sa spúšťa pred ukládaním dat do tabulky.

## Materializovany pohled
Najprv bolo potrebné vytvoriť materializované záznamy, takz. logy obsahujúce zmeny hlavnej tabulky, ktoré slúžia na to, aby bolo možné používať rýchlu obnovu po potvrdení zmien namiesto kompletnej obnovy, ktorá by vyžadovala spúšťať celý dotaz materializovaného pohledu, čo by trvalo dlhšie.
Okrem REFRESH FAST ON COMMIT sme nastavovali i dalsí vlastnost materializovaného pohledu: BUILD IMMEDIATE - po vytvorení sa naplni hodnotami. Nakoniec sme k tomu pridali jednoduchý SELECT dotaz.

## Pridelenie prav
Druhy člen týmu musí zadať SQL príkaz ALTER SESSION SET CURRENT_SCHEMA = prvý_člem_týmu aby vedel pracovat s tabulkami.
Pridelenie pristupových práv sa realizuje pomocou:
* k tabulkám/materializovanému pohledu:  GRANT ALL ON tabulka/materializovany_pohled TO druhý_člen_týmu
* k proceduram:                          GRANT EXECUTE ON procedura TO druhý_člen_týmu
