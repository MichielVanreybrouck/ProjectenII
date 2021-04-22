   # Cheatsheet Cisco Commands
| Command | Task |
|:--------|:-------|
| `enable` | Switch van user EXEC mode naar privileged EXEC mode |
| `disable`| Switch terug van privileged EXEC mode naar user EXEC mode |
| `configure terminal`| Switch naar global configuration mode |
| `exit` | Ga terug naar de privileged EXEC mode |
| `end` (of CTRL + Z) | Switch van gelijk welke sub-configuratie terug naar de privileged  EXEC mode.|
| TAB | Autofill wanneer je bv “en” typt zal hij “enable” voorstellen |
| `?` | Help commando. Kan een lijst weergeven van alle beschikbare commands in een bepaalde mode of kan helpen om een command aan te vullen als je maar een deel kent. |
| `hostname “NAAM”` | Stelt de naam van een switch in. (kan enkel in privileged EXEC mode). |
| `enable secret “WACHTWOORD”` | Stelt wachtwoord voor switch in. |
| `line con 0` | Configureer console line. |
| `password “WACHTWOORD”` | Stelt wachtwoord in van Console Line. |
| `service password-encryption` | Wachtwoord encrypteren (enable secret is al standaard encrypted maar de “password” command niet. |
| `banner motd #TEKST#` | Message of the day weergeven voor juridische redenen en onbevoegde toegang. |
| `Vty  0 15` | Virtual terminal instellen (na deze command kan je een password voor de virtual terminal instellen). |
| `show running-config` | De startup configuratie weergeven. |
| `copy running-config startup-config` | Kopiëert de instellingen van de running-config naar de startup-config zodat de instellingen blijven behouden de volgende keer dat je de console opstart. |
| `erase startup-config` | Verwijderd de gesavede startup configuration file. |
| `reload` | Zet apparaat naar terug naar zijn laatst gesavede config. |
| `interface vlan1` | Een interface instellen (voor op afstand configuraties te doen, dit moet je altijd doen voor je via console een ip adres instelt). |
| `ip address XXX.XXX.XX.X(ip adres) 255.255.255.0 (subnet mask)` | Een IP adres geven aan een interface. |
| `ipv6 address` | Idem maar dan voor ipv6. |
| `ipv6 address XXXXXXXXX link-local` | Link-local ipv6 adres configureren. |
| `ip default-gateway XXX.XXX.XXX.XXX` | Ip adres default gateway configureren. |
| `no shutdown` | Een ip adres activeren (Standaard staat dit altijd op SHUTDOWN!). |
| `show ip route` | Toont de routeringstabel van de IPv4 routing van de router. |
| `no ip route` | Schakelt de route uit. |
| `show ipv6 route` | Toont routeringstabel van ipv6 routing. |
| `show ip arp` | De ARP tabel weergeven (in Windows command prompt arp -a). |
| `show interfaces` | Geeft karakteristieken  van alle interfaces van de router weer. |
| `show ip interface brief` | Een (kort) overzicht krijgen van alle IP adressen van je interfaces. |
| `show ipv6 interface brief` | Idem hierboven maar voor ipv6 (je krijgt bij IPv6 adressen van interfaces altijd 2 ipv6 adressen te zien. 1ste is link-local address, 2e is global unicast address). |
| `show version` | Toont de versie van het besturingssysteem van de router. |
| `Show Clock` | Toont de huidige tijd/datum. |
| `Tracert` | Stuurt een heleboel pakketjes van punt A naar punt B en geeft meer informatie over de route van A naar B. Meer informatie dan ping. |
| `ping ipv4 adres` of `ping ipv6 adres` | Pingt het gekozen adres.
| `no ip domain lookup` | Voorkomt dat foute commando’s via DNS opgezocht worden. |
| `debug ip routing` | Toont je berichten/info wanneer je nieuwe apparaten toevoegt aan de routing table. |

Auteur: Quinten De Bruyne
