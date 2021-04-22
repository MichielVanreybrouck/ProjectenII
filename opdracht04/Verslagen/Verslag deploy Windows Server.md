# Verslag creëeren image bestand ten einde de automatische uitrol van een Windows server

## 1. Opzetten Windows Server 2019

Indien je deze Windows Server al had geïnstalleerd en geconfigureerd voor de capture en deploy van de Windows 10 client, kan je dit deel overslaan.

1. Download een *Windows Server 2019* evaluation image via de website van Microsoft.
2. Installeer dit in een virtuele machine in VirtualBox. Controleer ook eventjes of *Microsoft deployment toolkit* reeds geïnstalleerd is. Dit is normaal gezien het geval. Indien dit niet zo is dien je dit nog zelf
te installeren. 
3. Installeer *Microsoft Assessment and Deployment Kit (ADK)* op Windows Server 2019 via [deze link](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install).
4. We zullen gebruik maken van *Windows Preïnstallation Environment*. Dit is een kleine, lichte versie van Windows, speciaal ontworpen om clients of servers te deployen. [Download de add-on voor ADK.](https://go.microsoft.com/fwlink/?linkid=2087112)
5. Installeer Virtualbox guest additions en doe dit zowel op je host als guest. Bij guest doe je dit door bovenaan op menu te klikken en vervolgens insert Guest Additions image cd. Nu zal deze gemount worden als schijf. 
6. Stel het gebruik van een shared folder in. Dit kan je doen bij de instellingen van je VM. Zorg ervoor dat de optie read-only niet geselecteerd is. 
7. Maak een nieuwe virtuele machine aan in Virtual Box. Kies voor een Windows 10 en laat de default instellingen staan. Zorg dat er slechts één netwerkadapter actief is bij de instellingen en deze geconfigureerd staat op intern netwerk.
8. Voeg aan de Windows Server een tweede netwerkadapter toe. Selecteer ook hier intern netwerk. 
9. Tot slot zorgen we ook dat de boot order van de client vm juist ingesteld staat. Eerst de harde schijf, als tweede via het netwerk. Dit omdat we Windows 10 vanop de Windows Server over het netwerk zullen deployen. Doe dit bij de instellingen van de VM > Systeem > moederbord > opstartvolgorde.
10. Ook belangrijk is dat je er voor zorgt de je genoeg opslaggeheugen aan deze Windows Server geeft, ga zeker voor 50 GB, dynamisch gealloceerd. 
10. Windows Deployment Services kan enkel functioneren als de Active Directory Domain Services, DNS en DHCP server van je Windows Server functioneren. Je zal dus deze drie rollen moeten installeren. Je kan dit doen bij *Server Manager* > *Add roles or features*.
11. Na de installatie hiervan, zal Windows Server aangeven de configuratie te doen, doe dit. Herstart deze service hierna nog eens.
12. Stel het IP adres van de adapter die verbonden is met het internetwerk van VirtualBox, en dus **niet** de NAT interface, in op *192.168.1.10* met mask *255.255.255.0*. Dit is normaal de tweede interface. Laat de default gateway leeg en aangezien we zelf de DNS server zijn vul je het loopback adres *127.0.0.1* in.
13. Je zal ook een DHCP scope moeten definiëren. Doe dit in *Server manager* > *tools* > *DHCP* > *naam van je server* > rechtermuisknop klikken op IPv4 > *New scope*.
14. Definieer de scope als volgt:
       * Range IPv4 adressen: 192.168.1.31 tot en met 192.168.1.130 
       * Subnetmasker: 255.255.255.0
       * Leaseduur 8 dagen
       * Configureer ook DHCP options met (yes configure options now)
       * IPv4 adres van de router 192.168.1.10 (ipv4 van deze server)
       * Domain: example.com (gebruik dezelfde domainname als diegene je daarnet gekozen hebt bij de ADDS)
       * IPv4 adres van de DNS: 192.168.1.10 (ipv4 van deze server)
       * Geen IPadressen toevoegen bij het WINserver venster
       * Activeer de aangemaakte scope
1. Klik rechtermuisknop op de naam van je server > *Authorize*.

15. Installeer tot slot nog de WSUS. Windows Server Update Services zorgt ervoor dat je de clients die je uitrolt kunnen voorzien worden van de laatste nieuwste Windows updates. Dit kan je als Role toevoegen in de *Server manager*
16. Volg de wizard en geef een pad in waar WSUS gebruik van kan maken.
17. Als de installatie van WSUS role voltooid is, klik op het gele notificatie tekentje in server manager om de post deployment configuration te doen.
18. Nu kunnen we de configuratie voor deze rol doen door terug naar *Server manager* te gaan > *Tools* > *Windows Server Updates Services*.
    * Laat bij de eerste vensters van de wizard de default keuzes staan.
    * Klik op *Start connecting* bij het venster *Connect to upstream server*. Dit kan eventjes duren, geen paniek. 
    * Kies bij de talen enkel Dutch en English
    * Bij *Products* kies je voor alle 3 de opties van Windows Server 2019 en vink je in het volgende venster ook *Critical updates, definition updates, security updates, upgrades* aan.
    * Bij *Configure sync schedule* kies synchronize manually. Kies tot slot voor *begin initial synchronization*
    * Eens de synchronistatie voltooid is, moet je in WSUS (via tools) de updates *approven*. Als de updates niet verschijnen zorg er dan voor dat de Approval op *Any except declined* en de Status op *Any* staat en dan op *Refresh* drukken
## 2. Aanmaken van een Windows Server reference image met behulp van Microsoft Deployment Toolkit op Windows Server.
### 2.1 Instellen van de deployment share.

1. Open de Deployment Workbench.
2.  Creëer een nieuwe share. Rechter muisknop > Create new deployment share. Kies vervolgens een locatie en naam. Zorg ook dat je straks het UNC path nog weet.
1. Download een Windows 10 image en mount deze op een drive van de Windows Server.
2. Klap de zojuist gecreëerde deployment share uit. Klik vervolgens rechter muisknop op *Operating Systems* > *Import operating system*.
3. Volg de wizard; kies voor *full set of source files* en selecteer dat drive waarop je het .iso bestand zonet op gemount hebt. 
4. Onder *Operating systems* zie je nu het Windows Server besturingssysteem staan. 
5. We willen zo veel mogelijk automatiseren en bij het installeren van de referentie machine zo weinig mogelijk wizards doorlopen. Daarom zullen we de *Rules* van de Deployment share moeten wijzigen. Dit kan door rechtermuisknop te klikken op de naam van de share in deployment workbench > properties. Ga naar het tabblad *Rules* en verander de inhoudt door het volgende: 
```
[Settings]
Priority=Default

[Default]
OSInstall=Y
SkipAppsOnUpgrade=YES
SkipAdminPassword=YES
SkipProductKey=YES
SkipComputerName=YES
SkipDomainMembership=YES
SkipUserData=YES
UserDataLocation=AUTO
SkipLocaleSelection=YES
SkipTaskSequence=YES
TaskSequenceID=1
DeploymentType=NEWCOMPUTER
SkipTimeZone=YES
SkipApplications=YES
SkipBitLocker=YES
SkipSummary=YES
SkipBDDWelcome=YES
SkipRoles=YES
DoCapture=YES
SkipFinalSummary=NO
UILanguage=0813:00000813
InputLocale=0813:00000813
SystemLocale=0813:00000813
UserLocale=0813:00000813
KeyboardLocale=0813:00000813
DoNotCreateExtraPartition = YES
TimeZoneName=Romance Standard Time 
WSUSServer=http://WIN-3HS2EJOHAUA:8530
```
en de Bootstrap.ini naar het volgende:
```
[Settings]
Priority=Default

[Default]
DeployRoot=\\WIN-3HS2EJOHAUA\DeploymentShare$
UserID=Administrator
UserDomain=example.com
SkipBDDWelcome=YES
UserPassword=Vagrant123
KeyboardLocale=0813:00000813
```

### 2.2 Microsoft SQL Server installeren
We zullen gebruik maken van een configuration file om SQL Server te installeren. Dit configuratiebestand kunnen we bekomen door de wizard te doorlopen zonder effectief te installeren.

1. Download de .iso voor Microsoft SQL Server. Ik gebruik 2016, maar hogere versies zouden ook moeten werken. 
2. Mount dit bestand op een drive van een Windows computer. Dit kan door rechtermuisknop te klikken op het bestand en *Mount* te kiezen. 
3. Ga naar de drive die zonet gemount werd en dubbelklik op *setup.exe*.
4. De wizard opent zich. Klik in de linkerkollom op *Installation* en kies vervolgens voor *New SQL Server stand-alone installation or add features to an existing installation*.
5. Laat de default *Specify a free edition: Evaluation* staan en klik *Next*.
6. Accepteer de licensievoorwaarden en op het volgende scherm vink je *Use Microsoft Update to check for updates* aan.
7. Het volgende venstertje vraagt eventueel om een nieuwe update uit te voeren. Doe dit.
8. Bij de features mag je de bovenste van de *Instance features* selecteren: *Database Engine Services*.
8. Bij *Instance configuration* mag je de defaults laten staan en doorgaan naar het volgende scherm. 
9. Ook de *Service Accounts* mogen blijven wat ze zijn. 
10. Het volgende venster geeft een overzicht van wat er geïnstalleerd zal worden. Klik niet op *Next*, aangezien we SQL Server niet op deze computer willen installeren maar enkel geïnteresseerd zijn in het configuratiebestand. Onderaan zie je de locatie van dit bestand.
11. Kopieer dit bestand naar een andere locatie en pas nog enkele dingen aan:
	- ` UIMODE="Normal" ` mag in comment gezet worden door ; gevolgd door een spatie er voor te plaatsen.
	- Verander de Quiet parameter naar `QUIET="True"`
	- Verander de systeem administrator naar `SQLSYSADMINACCOUNTS="Administrator"`
	- Ga automatisch akkoord met de licentievoorwaarden door `IACCEPTROPENLICENSETERMS="True"`
3. Kopieer de inhoud van de drive die je zojuist gemount hebt met het disk image van Microsoft SQL Server naar een nieuwe directory met de naam *SQL Server* op de Windows Server waar Deployment Toolkit op geïnstalleerd is. Kopieer ook de zojuist bewerkte configuratie bestand in de root van deze map.
12. Ga naar de Deploymeent Workbench op Windows Server en klikrechtermuisknop op Applications in de deployment share en kies voor *New Application* 
12. Kies voor de default *Application with source files* en klik *Next*.
12. Vul de naam van de applicatie in: SQL Server en browse in het volgende venster naar de directory met inhoudt van de .iso en het configuratiebestand.
13. Klik tweemaal op volgende. Nu wordt er gevraagd naar het commando voor de silent install. Geef hier `setup.exe /ConfigurationFile=ConfigurationFile.ini /IAcceptSQLServerLicenseTerms=True` in en laat de *Working directory* ongewijzigd. 


### 2.3 Het instellen van de *task sequence*
1. Klik op rechtermuisknop *Task Sequences* in de deployment share en kies voor *Create new task sequence*.
1. Vul een task sequence ID in en een naam. Klik op next en laat de default *Standard Server Task Sequence* staan.
1. Vul de velden van volgende vensters in. Kies ervoor om later een product key in te geven en de admin credentials nu niet te bepalen. We zouden nu over een task sequence beschikken.
1. In het volgende venstertje kies je voor het operating system dat je zonet hebt geïmporteerd.
1. Klik rechtermuisknop op de net aangemaakte task sequence in de deployment share. Kies voor *Properties* en ga naar het *Task Sequence* tab. Hier zie je welke taken zullen overlopen bij het deployen van de machine alsook in welke volgorde dit zal verlopen. 
1. In de folder *State Restore* zal je de taak *Install Applications* zien. Hier klik je op *Browse* en voeg je de eerder toegevoegde applicatie toe. 
1. We willen ervoor zorgen dat we de laatste updates van Windows installeren. Hiervoor klik je op *Windows Update (Pre-application Installation)* en ga je naar het tabblad *Options*. Hier vink je het selectievakje voor *disable this step* uit opdat deze stap toch zou uitgevoerd worden. 
1. Doe hetzelfde als de stap hierboven bij de stap *Windows update (Post-Application Installation)*, net na het installeren van de applicaties.
1. Selecteer vervolgens *Install applications*. Vervolgens klik je bovenaan op de knop *Add* > *Roles* > *Install roles and features*. 
1. Nu vink je bij *Roles* het vakje voor *Webserver (IIS)* aan. Bij *Features* vink je * .NET Framework 4.7 features* aan. 

**Alles is nu klaar om ons .wim bestand te genereren om dit dan te deployen via Windows Deployment Services. Klik rechtermuisknop op de naam van de deployment share in de workbench en kies voor *Update Deployment Share*. In de wizard kies je de onderste optie om alle bestanden opnieuw te genereren.**

### 2.4 Windows Deployment Services
Je kan de installatie en configuratie overslaan indien je dit reeds gedaan hebt voor een Windows Client.
1. Installeer de *Windows Deployment Services rol* in je Windows Server 2019 VM
   *Server manager* > *Add roles and features* 
2. Selecteer *Windows deployment services* in tools en installeer de rol. Click op *Servers* > *Naam van je server* > *configure server*
4. Laat de proxy instellingen onveranderd. Bij OS settings mag je als Organization *example* gebruiken.
5. Selecteer de optie om te responden op alle clients, zowel bekend als onbekend. 
6. Eens deze wizard doorlopen is, klik je rechtermuisknop op de map *Boot images* onder jouw server en klik op *Add boot image*.
7. Vul het pad naar de waar de zonet gecreëerde .wim zich bevind. Waarschijnlijk is dit de *Boot* directory van de deployment share.
8. Klik rechtermuisknop op je server > *properties* > tabblad *TFTP* > deselecteer het vakje voor *Enable variable windows extension*.
9. Nog steeds bij *Properties* > tabblad *DHCP*. Zorg ervoor dat beide opties geselecteerd zijn. Dit zorgt ervoor dat de DHCP geïnformeerd wordt dat dit ook een PXE server is. 
10. Onder tabblad *Boot* > duidt zowel voor gekende als ongekende clients aan *Always continue the PXE boot*. 
11. Controleer nog eventjes de DHCP server. *Servernaam* > *IPv4* > *Server options*. Hier zo de optie 60 PXEClient moeten staan. Optie 66 en 67 zijn niet nodig om dat alles zich in hetzelfde subnet bevindt. 

### 2.5 Maak een verse virtuelemachine aan
1. Creëer een nieuwe virtuele machine, kies voor Other Windows 64bit.
2. Behoud de standaardwaarden.
3. Ga naar *settings* > *network*. Stel 1 netwerkadapter in op een intern netwerk met dezelfde naam als dat van de Windows Server.
4. Ga naar *settings* > *System*. Stel de bootorder zo in dat er eerst geboot wordt vanaf de harde schijf en daarna vanaf het netwerk. 
5. Ga naar *settings* > *network* > *Adapter 1* > *Advanced*. Zet *Promisuous mode* op allow all. Doe dit ook voor de interne netwerk adapter van de Windows Server. 
6. Start de virtuele machine. Je krijgt normaal geen enkele wizard te zien door *Rules* die we zonet gedefinieerd hebben in de deployment share.

** De Windows Server zal geïnstalleerd worden met IIS en ASP.NET. Ook SQL Server zal voorzien worden alsook de laatste Windows Updates. Tot slot zal de staat van deze machine 'gevangen' worden en opgeslaan als .wim bestand op onze deployment share op onze eerste Windows Server. Dit bestand is onze referentie image die we nu kunnen gebruiken om Windows Server instantie te deployen met exact dezelfde configuratie. ** 

### 3. Deployen van de referentie image.
1. Je mag de virtuele machine die gezorgd heeft voor het capturen van de image verwijderen.
2. Op je Windows Server maak je in nieuwe deployment share aan en importeer je een nieuw besturingssysteem. Dit heb je eerder hierboven gedaan, kies deze keer wel voor het zojuist gegenereerde .wim bestand in de *Captures* directory van je deployment share. 
3.  Bij de wizard om het besturingssysteem te importeren zal je nu echter niet voor de bovenste optie moeten kiezen maar wel voor de middelste: *Custom image file*. Voeg het .wim bestand dat gecaptured werd toe. Dit bevindt zich in de andere deployment share in de Captures folder. 
4. Laat de volgende optie op default staan en vervolledig de wizard.     
5. Vervolgens creëren we een nieuwe *task sequence* voor deze deployment share.
6. Kies zelf een sequence id en naam en kies voor *Standard Server Task Sequence*.
8. Doorloop de rest van de wizard: selecteer het zonet geïmporteerde besturingssysteem, geef geen product key in en kies een admin wachtwoord.  
9. We gaan opnieuw de *rules* van deze deployment share wat aanpassen. Klik rechtermuisknop op de share en ga voor *properties*.
10. Vervolgens ga je naar het *rules* tabblad en vervang dit door volgend:
```
[Settings]

Priority=Default

[Default]
_SMSTSORGNAME=EXAMPLE.COM
OSInstall=Y
SkipAppsOnUpgrade=YES
SkipAdminPassword=YES
SkipProductKey=YES
SkipComputerName=YES
SkipDomainMembership=YES
SkipUserData=YES
UserDataLocation=AUTO
SkipLocaleSelection=YES
SkipTaskSequence=YES
DeploymentType=NEWCOMPUTER
SkipTimeZone=YES
SkipApplications=YES
SkipBitLocker=YES
SkipSummary=YES
SkipBDDWelcome=YES
SkipCapture=YES
DoCapture=NO
SkipFinalSummary=YES
UILanguage=0813:00000813
InputLocale=0813:00000813
SystemLocale=0813:00000813
UserLocale=0813:00000813
KeyboardLocale=0813:00000813
DoNotCreateExtraPartition=YES
TimeZoneName=Romance Standard Time 
JoinDomain=EXAMPLE
DomainAdmin=EXAMPLE\Administrator 
DomainAdminPassword=Vagrant123
WSUSServer=http://WIN-3HS2EJOHAUA:8530
SkipTaskSequence=YES
TaskSequenceID=1
```

En de bootstrap.ini naar volgende: 
```
[Settings]
Priority=Default

[Default]
DeployRoot=\\WIN-3HS2EJOHAUA\Share$
UserDomain=example
SkipBDDWelcome=YES
UserID=Administrator
UserPassword=Vagrant123
```
*Uiteraard dien je de WSUSServer naam, domeinnaam, -usernamen en -wachtwoord en het task sequence id aan te passen naar je eigen waarden.*

De meeste properties geven aan dat een bepaalde wizard die normaal wordt getoond bij het installeren mogen overgeslagen worden. Anderen stellen de tijdszone en toetsenbord layout goed in. Ook credentials om toegang te krijgen tot de netwerkshare en het domein worden meegegeven. Er wordt ook gezegd welke task sequence gebruikt moet worden en wat de naam is van de server die voor de Windows updates zorgt.*

11. Update de deployment share via rechtermuisknop te klikken op de naam. 
12. Nu zal er een image gegenereerd worden in de *Boot* directory. 
12. Ga naar *Windows deployment services* via *Tools* in *Windows server manager*.
14. Verwijder de boot image van daarnet en voeg de zojuist gecreëerde toe. 
15. Klik rechtermuisknop op de naam van de server en kies *restart* onder *actions*.
16. Tot slot kan je net zoals daarnet nieuwe virtuele machines aanmaken met dezelfde instellingen (belangrijk intnet netweradapter en bootvolgorde eerst hdd en dan network). Er zal automatisch de Windows Server met de roles en features en SQL Server op geïnstalleerd worden. 


Auteur: Quinten De Bruyne




  
