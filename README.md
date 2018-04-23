# IDS
## Úvod
## Převod vztahu generalizace/specializace 

![prevod vztahu](https://github.com/Cropi/IDS/blob/master/erd_social.png)

Pro převod vztahu generalizace/specializace jsme zvolili metodu převedení do dvou tabulek. Tento spůdob jsme zvolili, protože naše specializace jsou disjunktní a také jelikož entita Fotka má vztahy ještě s entitami Album a Akce, a musí do ní být uložen soubor (fotka), tak použitím dvou tabulek zamezíme vytváření prázdných míst.
