# Verslag opdracht 2.3

## Stap 1: Aanmaken van VM op Azure

1. Ga naar <https://azure.microsoft.com> en log in
2. Druk op "Portal"
3. Ga naar Virtual Machines
4. Druk op "Add"
    - Kies een subscription
    - Kies een bestaande Resource Group of creër een nieuwe
    - Geef de virtuele machine een naam
    - Kies een Locatie(France Central)
    - Availabillity options mogen leeg blijven
    - Bij image kies je voor "Browse all public and private images" 
    - Zoek naar "Centos8" en kies voor "CentOS-based 8.0 - Gen2" van Rogue Wave Software
    - Azure spot instance mag op no blijven staan
    - Size mag ook blijven staan
    - Voor het Authentication type gebruiken we een password
    - Username TestCent
    - Password: Test123Test123
    - Inbound port rules moeten ssh toelaten
    - Druk op "Review + Create"
    - Alles nakijken en onderaan op create drukken en wachten op de deployemen

## Stap 2: Script runnen

1. Ga bij Virtual Machines naar de net aangemaakte VM en start hem op
2. Zoek naar "Run Command"
3. Druk op "RunShellScript"
4. kopieer "scriptProductie.sh" en plak het in het "Linux Shell Script" vak
5. Druk op "Run"
6. Wacht tot het script is uitgevoerd (Dit kan enkele minuten duren)

## Connecteren met de VM

1. Op azure ga je naar "Overview" en zoek je het public IP Address van de vm
2. Kopieer dit en plak deze in PuTTY bij "IP address" van de ssh verbinding
3. Druk op "Connect" en op "Yes" als PuTTY een sucurity Alert geeft
4. Log in op de vm met je zelf gekozen Username en password
