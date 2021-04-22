# Reset Cisco router 
1. Verbind jouw computer met de router via een console kabel. 

2. Maak verbinding via putty met de router. 

3. De correcte instellingen zijn:

    *Baud: 9600
    *Data bits: 8
    *Parity: No
    *Stop bits: 1
    *Flow Control: None


5. Start de router opnieuw op en gebruik de break toets om de opstartsequentie te onderbreken. Vaak is de break combinatie ctrl + break toest op jouw computertoetsenbord. 

6. Type `confreg 0x2142`.  De NVRAM zal niet uitgelezen worden en de huidige configuratie dus niet geladen.
7. Typ `reset` om de router te resetten. Antwoord met no op de vragen. 

8. Typ `copy start run`.  Dit laadt de startup-configuratie in het geheugen. Als je nu typt `show run config`, dan komt de routerconfiguratie. 

8. Verander de secret met `enable secret new_password`

9. Verander het register terug naar 0x2102:

    *`config-register 0x2102`
    *Wanneer de router nu opnieuw start, dan zal de vorige configuratie behouden blijven met het nieuwe ingestelde wachtwoord.
    *Typ `copy run start`
    *Herstart de router door `reload`in te geven bij het enable prompt.

# Reset Cisco switch

1. Zet een terminal emulation verbinding op met de console poort van de switch.
2. Gebruik volgende terminal instellingen:
    * Bits per second (baud): 9600
    * Data bits: 8
    * Parity: none
    * Stop bits: 1
    * Flow control: Xon/Xoff
3. Zet de switch uit en trek de stekker uit het stopcontact.
4. Zet de switch terug aan terwijl je op de 'mode' knop ingedrukt houdt. 
5. Voer het `flash_init` commando uit. 
6. Voer het `load_helper` commando uit. 
7. Voer het `dir flash:` commando uit, let op het dubbel punt.
8. Voer `rename flash:config.text flash:config.old` uit om het configuratiebestand te hernoemen.
9. Voer het `boot` commando uit.
10. Systeem zal vragen om inital configuration uit te voeren. Weiger dit met `n`.
11. Typ `en` om in de enabled mode te gaan.
12. Geef `rename flash:config.old flash:config.text` in.
13. Geef `copy flash:config.text system:running-config` in om config file in memory te kopiëren. 
14. Geef `conf ter` in. Gebruik nu de gebruikelijke commando's om nieuwe wachtwoorden in te stellen. 
15. Schrijf naar het configuration file met `write memory`. 
