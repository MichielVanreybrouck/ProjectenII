# Opdracht 4: Microsoft Deployment Toolkit

## Opdrachtomschrijving

Voor een kantoornetwerk (Windows omgeving) wens je de uitrol van software op de werkstations (clients) te automatiseren. Je wenst ook om de webserver van het bedrijf te automatiseren. Binnen een Windows omgeving kan je dit met "Microsoft Deployment Toolkit (MDT)" op een efficiënte manier uitvoeren. Daar waar nodig kan je gebruik maken van PowerShell, dit zal vooral van toepassing zijn voor de server opdrachten binnen het MDT gedeelte.
Installler een Windwos Server 2016 met daarop de MDT software. Configureer dan binnen MDT 2 settings, 1 Windows Client en 1 Windows Server. Zorg dat ze respectievelijk de volgende software hebben na installatie.

Gebruik MDT, terug te vinden op [https://www.microsoft.com/en-us/download/details.aspx?id=54259](https://www.microsoft.com/en-us/download/details.aspx?id=54259) om volgende software pakketen automatisch op de clients te installeren:
- Windows 10
- Adobe Reader
- Java
- Libre Office
- Alle Windows updates

Zorg dat uw Windwos Server 2016 automatisch geïnstalleerd wordt aan de hand van bovenstaande toolkit.
Je installeert volgende componenten op deze server
- Windows 2016
- ASP.NET
- IIS
- Microsoft SQL Server.
- Zorg dat uw server voorzien is van de laatste updates alvorens te deployen.

Meeer info beschikbaar op onderstaande link 
[https://docs.microsoft.com/nl-be/configmgr/mdt/index](https://docs.microsoft.com/nl-be/configmgr/mdt/index)
## Test-omgeving

Gebruik Virtualbox om deze installaties te doen. Maak geen gebruik van Vagrant. Dit gaat u redelijk veel problemen geven om dit op te zetten. 
Gebruik de toolkit MDT, en daar waar nodig gebruik je PowerSHell om bepaalde roll-outs te doen van de server en eventueel ook de clients.
Elke installatie moet gebeuren via PXE boot.


## Productie-omgeving

De bedoeling is om servers met exact dezelfde configuratie in een productie-omgeving te kunnen opzetten. We denken er aan om dit uit te besteden via een Infrastructure as a Service/public cloud provider .

De volgende Public Cloud providers geven gratis credits via het Github Student Pack:

- [Digital Ocean](https://www.digitalocean.com/)
- [Amazon Web Services Educate](https://aws.amazon.com/education/awseducate/)
- [Azure](https://aka.ms/devtoolsforteaching)

Kies een van deze platformen en reproduceer de testopstelling uit VirtualBox in de cloud. Maak voor monitoring eventueel gebruik van de functionaliteiten van de cloud-omgeving. Als jullie scripts voldoende configureerbaar zijn, is er slechts een minimum aan wijzigingen nodig.

## Acceptatiecriteria

- Er is een proof-of-concept van de automatische uitrol van software binnen een Windows client - serveromgeving.
- De nodige documentatie (lijst software, technische handleidingen, testplannen, testrapporten, ...) zijn aanwezig.

## Deliverables

- Demo tijdens de contactmomenten van de proof-of-concept.
- Op Github:
    - Lastenboek
    - Alle achtergrondinformatie die jullie verzameld hebben om met de opdracht aan de slag te kunnen gaan
    - Gedetailleerde technische handleidingen gericht naar andere teamleden over installatieprocedures en de gebruikte scripts
    - Testplannen en testrapporten
