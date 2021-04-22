# Verslag Opdracht 1 Lab 2
## Deel 1: opzetten van netwerk topologie
1. Neem 2 switches (2960) en 2 PC's
2. Start alle apparaten op
3. Verbind de 2 switches met elkaar, beide op F0/1
4. Verbind de 2 switches aan de juiste PC
## Deel 2: Configuratie van de PC hosts
1. Op PCA, ga naar config > settings en verander de displat name naar PCA. Doe dit ook voor PCB.
2. Ga vervolgens naar config > interface > FastEthernet0 en verander hier het ip adress naar 192.168.1.10, verander hierbij ook de subnetmask naar 255.255.255.0.
3. Doe dit ook voor PCB maawr gebruik het ip adres  192.168.1.11, verander hierbij ook de subnetmask naar 255.255.255.0.
## Deel 3: Configuratie van de switches
1. Maak een verbinding met een consolekabel vanuit een pc
2. Open op de pc de terminal, nu kan je het volgende waarnemen
> Switch> 
3. Om naar de volgende modus te gaan voer enable in
4. Vervolgens willen we naar de "configuration mode gaan", gebruik hiervoor het volgende commando
> configure terminal
5. Om de hostname te veranderen, voer volgende commando in
> hostname S1
6. We willen geen DNS lookups, hiervoor gebruiken we volgende commando
> no ip domain-lookup
7. Om een wachtwoord in te schakelen gebruiken we volgende set aan commando's
> enable secrect class
> line con 0
> password cisco
> login
> exit
8. Om een banner in te stellen gebruiken we volgend commando
> banner motd # "inhoud van de banner" #
9. Hierna willen we de configuratie opslaan, dit gebeurt als volgt
> copy running-config startup-config
10. Druk hierna op enter


