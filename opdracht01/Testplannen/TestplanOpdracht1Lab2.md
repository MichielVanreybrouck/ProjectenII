# Lab 2: Een simpel netwerk ontwerpen
##  Test bij stap 1: opzetten van de "Network Topology"
----
### Test 1: Connectie verifiëren doormiddel van commando "ping"
#### Stappenplan:
- Opstarten van beide pc's
- Command line openen op 1 van de pc's
- Het volgende commando invoeren:
> ping 'ip adres computer 1'
- Resultaat verifiëren
#####  Test resultaat positief:
> Reply from **ip_pcA**: bytes=1500 time=30ms TTL=54  
> Reply from **ip_pcA**: bytes=1500 time=30ms TTL=54  
> Reply from **ip_pcA**: bytes=1500 time=29ms TTL=54  
> Reply from **ip_pcA**: bytes=1500 time=30ms TTL=54  
> Reply from **ip_pcA**: bytes=1500 time=31ms TTL=54  
> Ping statistics for **ip_pcA**:  
> Packets: Sent = 5, Received = 5, Lost = 0 (0% loss),  
> Approximate round trip times in milli-seconds:  
> Minimum = 29ms, Maximum = 31ms, Average = 30ms  
##### Test resultaat negatief:
> Pinging **ip_pcA** with 32 bytes of data:  
> Request timed out.  
> Request timed out.  
> Request timed out.  
> Request timed out.  
> Ping statistics for **ip_pcA**:  
> Packets: Sent = 4, Received = 0, Lost = 4 (100% loss),  
>Approximate round trip times in milli-seconds:  
> Minimum = 0ms, Maximum = 0 ms, Avarage = 0ms

### Einde Test
----

##  Testen bij stap 2: Configureren van "PC Hosts"
----
### Test 1: Hostnaam en ip-adres verifiëren
####  Stappenplan:
- Open de terminal op de te testen computer
- Voer het volgende commando in:
> ipconfig /all
- Resultaat verifieëren
##### Test resultaat positief:
- Hostname en ip-adres komen overeen met de gekozen hostname en ip-adres
#####  Test resultaat negatief:
- Hostname en ip-adres komen niet overeen met de gekozen hostename en ip-adres

### Einde 
----

##  Testen bij stap 3: configuren van basische switch instellingen
----
### Test 1: Verifiëren van de geconfigureerde instellingen
#### Stappenplan:
- Verbind met de switch en open de terminal
- Voer volgende commando in
> show running-config
- Resultaten verifiëren
###### Test resultaat positief:
- Deze info wordt weergegeven:
> Hostname *ingestelde hostname*
> enable secret 4 *code*
> no ip domain-lookup
> banner motd *ingevulde banner*
> password *ww*
> login
###### Test resultaat negatief:
- De geconfigureerde instellingen zijn niet terug te vinden

### Einde
---
