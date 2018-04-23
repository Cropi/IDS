# IDS
## Úvod
## Převod vztahu generalizace/specializace 

![prevod vztahu](https://github.com/Cropi/IDS/blob/master/erd_social.png)

Pro převod vztahu generalizace/specializace jsme zvolili metodu převedení do dvou tabulek. Tento spůdob jsme zvolili, protože naše specializace jsou disjunktní a také jelikož entita Fotka má vztahy ještě s entitami Album a Akce, a musí do ní být uložen soubor (fotka), tak použitím dvou tabulek zamezíme vytváření prázdných míst.

## EXPLAIN PLAN
Pomocí EXPLAIN PLAN získáme plán jak databáze zpracovává daný dotaz. Demonstrovali jsme na jednoduchém SELECT dotaze. Nejprve jsme spustili EXPLAIN PLAN bez použití indexů, následně jsme nadefinovali index a spustili jsme EXPLAIN PLAN znovu.

Výsledná tabulka bez použití indexů vypadá takto:
![before](https://github.com/Cropi/IDS/blob/master/before.png)

Výsledná tabulka s použitím indexů:
![after](https://github.com/Cropi/IDS/blob/master/after.png)

SELECT STATEMENT značí, že se uskutečnil SELECT dotaz. HASH GROUP BY znamená, že se shromážďuje podle hashovacího klíče, dále jsou zde 2x NESTED LOOPS, což znamená, že se spojily 2 tabulky (NATURAL JOIN).
Při používání EXPLAIN PLAN bez indexu máme TABLE ACCESS FULL, což znamená, že naše tabulka obsahuje malý počet řádků, v tomto případě prochází tabulka od začátku bez používání indexů.
V druhé tabulce se vykonával TABLE ACCESS BY INDEX ROWID BATCHED, který značí, že se přistupuje do tabulky přes konkrétní řádek (použil se náš index).
Díky tomu se snížila "cena", ale na druhé straně %CPU se zvětšilo. INDEX UNIQUE SCAN značí přístup k tabulkám přes B-strom.
