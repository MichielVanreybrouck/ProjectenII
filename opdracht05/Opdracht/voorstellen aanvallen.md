# Opdracht 5: demonstratie van een cybersecurity attack

## Benodigdheden

- Kali linux
- HatKey (keylogger)
- Fysieke pc
- XAMPP stack, dit bevat: MySQL, Pearl, PhP, apache
- bWAPP

Eerst installeren we een versie van Kali Linux. Hierna installeren we hierop een XAMPP stack. Dit is gemakkelijk om alles in 1 keer te installeren. Na dat dit gebeurt is installeren we bWAPP. Dit is een website die gemaakt is om de zwakheden op websites te testen. Hierna kunnen we kiezen tussen 1 van de hieronder beschreven aanvallen. We kunnen hier ook kiezen om een aantal aanvallen voor te bereiden.

## Aanval 1: keylogger

We proberen via een keylogger die verpakt zit een een bat file, de wachtwoorden van de agent computer te achterhalen.

## Aanval 2: smurf attack

We proberen aan de hand van een DDOS attack de agent computer te laten crashen. Dit gebeurt door vele ICPM paketten te sturen en zo de agent pc te overladen.

## Aanval 3: man in the middle attack

We proberen de tussenpersoon te zijn en data op te vangen die naar een server wordt verstuurd.

## Aanval 4: cross-site scripting attack

We zoeken een website uit waarbij men script injecties kan uitvoeren. Wanneer deze is gevonden kunnen we javascript code hierin sturen en zo de cookies stelen. Deze kunnen we dan later gebruiken om aan "session hijacking te doen".

## Aanval 5: sql injection attack

We zoeken een website waar we sql injecties kunnen doen. Eenmaal wanneer we deze gevonden hebben kunnen we aan de hand van sql-queries data opvragen.

## Aanval 6: drive-by attack

We plaatsen op een onbeveiligde website een stukje malware (script) in de http of php code. Hier wordt door het script een stukje malware geïnstalleerd. De gebruiker (degene die de website bezoeke hoeft hiervoor geen dingen te installeren).
