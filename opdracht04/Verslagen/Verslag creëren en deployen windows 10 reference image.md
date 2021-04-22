# Creëeren en deployen van een Windows 10 image in een testomgeving.


## 1. Opzetten Windows Server 2019

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
    * Bij *Products* kies je uiteraard voor Windows 10 (en ook de 2 opties voor Windows 10 updates) en vink je in het volgende venster ook *Critical updates, definition updates, security updates, upgrades* aan.
    * Bij *Configure sync schedule* kies synchronize manually. Kies tot slot voor *begin initial synchronization*
    * Eens de synchronistatie voltooid is, moet je in WSUS (via tools) de updates *approven*.


## 2. Aanmaken van een Windows 10 image met behulp van Microsoft Deployment Toolkit op Windows Server.
### 2.1 Deployment shares
Deployment shares is een repository waarin zowat alles zit dat MDT zal gebruiken om het image te maken en te deployen. Dit bevat operating system images, scripts, applicaties, drivers, language packs, ...
1. Open de Deployment Workbench.
2.  Creëer een nieuwe share. Rechter muisknop > Create new deployment share. Kies vervolgens een locatie en naam. Zorg ook dat je straks het UNC path nog weet.

### 2.2 Applicaties toevoegen
1. Download een Windows 10 image en mount deze op een drive van de Windows Server.
2. Klap de zojuist gecreëerde deployment share uit. Klik vervolgens rechter muisknop op *Operating Systems* > *Import operating system*.
3. Volg de wizard; kies voor *full set of source files* en selecteer dat drive waarop je het .iso bestand zonet op gemount hebt. 
4. Onder *Operating systems* zie je nu het Windows 10 besturingssysteem staan. 
5. We moeten ervoor zorgen dat Java, [Adobe reader](https://get.adobe.com/nl/reader/otherversions) en [Libre Office](https://www.libreoffice.org/download/download) geïnstalleerd wordt. Hiervoor moeten we eerst de installatiepackages (.msi) op onze server hebben staan. Download deze voor Windows 10 64 bit van het internet. 
7. Maak ergens per applicatie een folder aan en geef deze de naam van de applicatie. Kopier de .exe of .msi naar van elke app naar de juiste folder. 
6. Klik rechtermuisknop op *Applications* in onze deployment share en selecteer *New Application*.
7. Ga voor de default optie op het eerste scherm en vul de velden in. Alles is optioneel behalve de naam. 
8. In het volgende venstertje geef je het pad naar de folder van de applicatie. 
9. Nu moeten we een commando ingeven om de quiet install mogelijk te maken. Dit doe je voor de .exe bestanden door de naam van het installatiebestand in te geven gevolgd door /sAll voor Adobe reader en /s voor java. Voor de .msi installer van libreoffice doen we `msiexec /i LibreOffice_6.4.1_Win_x64.msi /qb`.

### 2.3 Het instellen van de *task sequence*
1. Klik op rechtermuisknop *Task Sequences* in de deployment share en kies voor *Create new task sequence*.
1. Vul een task sequence ID in en een naam. Klik op next en laat de default *Standar Client Task Sequence* staan.
1. Vul de velden van volgende vensters in. Kies ervoor om later een product key in te geven en de admin credentials nu niet te bepalen. We zouden nu over een task sequence beschikken.
1. In het volgende venstertje kies je voor het operating system dat je zonet hebt geïmporteerd.
1. Klik rechtermuisknop op de net aangemaakte task sequence in de deployment share. Kies voor *Properties* en ga naar het *Task Sequence* tab. Hier zie je welke taken zullen overlopen bij het deployen van de machine alsook in welke volgorde dit zal verlopen. 
1. In de folder *State Restore* zal je de taak *Install Applications* zien. Zorg ervoor dat hier de optie *Install multiple* aangevinkt staat. Dit installeert de eerder toegevoegde applicaties. 
1. We willen ervoor zorgen dat we de laatste updates van Windows installeren. Hiervoor klik je op *Windows Update (Pre-application Installation)* en ga je naar het tabblad *Options*. Hier vink je het selectievakje voor *disable this step* uit opdat deze stap toch zou uitgevoerd worden. 
1. Doe hetzelfde als de stap hierboven bij de stap *Windows update (Post-Application Installation)*, net na het installeren van de applicaties. 
1. Klik rechtermuisknop op de deployment share > *Properties* > *Rules* en verander de code door de volgende: 
```
[Settings]
Priority=Default
Properties=MyCustomProperty

[Default]
OSInstall=Y
UserID=Administrator
UserDomain=example.com
UserPassword=Vagrant123
SkipBDDWelcome=YES
SkipDeploymentType=YES
SkipDomainMembership=NO
SkipApplications=NO
SkipSummary=YES
SkipUserData=YES
SkipComputerName=NO
SkipTaskSequence=YES
TaskSequenceID=*idnummer*
SkipLocaleSelection=YES
SkipTimeZone=YES
SkipAppsOnUpgrade=YES
SkipAdminPassword=YES
SkipProductKey=YES
SkipComputerBackup=YES
SkipBitLocker=YES
SkipFinalSummary=YES  
SkipCapture=NO
WSUSServer=http://naamVanServer:8530
KeyboardLocale=nl-BE
```

Pas ook *Bootstrap.ini* aan: 
```
[Settings]
Priority=Default

[Default]
DeployRoot=\\naamvanserver\DeploymentShare$
UserID=Administrator
UserDomain=example.com
UserPassword=Vagrant123
KeyboardLocale=nl-BE 
```

Let vooral goed op dat je de waarden aanpast naar die van jou. Let ook goed op WSUSServer! Indien deze niet juist staat zullen er geen Windows updates kunnen doorgaan.

*We hebben nu de deployment share correct ingesteld. Klik rechtermuisknop op de share en selecteer *Update deployment share*. Er is nu een .iso image aanwezig in de Boot directory van de deployment share.*

### 2.5 Windows Deployment Services

1. Installeer de *Windows Deployment Services rol* in je Windows Server 2019 VM
   *Server manager* > *Add roles and features* 
2. Selecteer *Windows deployment services* in features en installeer de rol. Click op *Servers* > *Naam van je server* > *configure server*
4. Laat de proxy instellingen onveranderd.
5. Selecteer de optie om te responden op alle clients, zowel bekend als onbekend.
6. Eens deze wizard doorlopen is, klik je rechtermuisknop op de map *Boot images* onder jouw server en klik op *Add boot image*.
7. Vul het pad naar de waar de zonet gecreëerde .wim zich bevind. Waarschijnlijk is dit de *Boot* directory van de deployment share.
8. Klik rechtermuisknop op je server > *properties* > tabblad *TFTP* > deselecteer het vakje voor *Enable variable windows extension*.
9. Nog steeds bij *Properties* > tabblad *DHCP*. Zorg ervoor dat beide opties geselecteerd zijn. Dit zorgt ervoor dat de DHCP geïnformeerd wordt dat dit ook een PXE server is. 
10. Onder tabblad *Boot* > duidt zowel voor gekende als ongekende clients aan *Always continue the PXE boot*. 
11. Controleer nog eventjes de DHCP server. *Servernaam* > *IPv4* > *Server options*. Hier zo de optie 60 PXEClient moeten staan. Optie 66 en 67 zijn niet nodig om dat alles zich in hetzelfde subnet bevindt. 

### 2.6 Maak een verse virtuelemachine aan
1. Creëer een nieuwe virtuele machine, kies voor Windows 10 64bit.
2. Behoud de standaardwaarden.
3. Ga naar *settings* > *network*. Stel 1 netwerkadapter in op een intern netwerk met dezelfde naam als dat van de Windows Server.
4. Ga naar *settings* > *System*. Stel de bootorder zo in dat er eerst geboot wordt vanaf de harde schijf en daarna vanaf het netwerk. 
5. Ga naar *settings* > *network* > *Adapter 1* > *Advanced*. Zet *Promisuous mode* op allow all. Doe dit ook voor de interne netwerk adapter van de Windows Server. 
6. Start de virtuele machine. Je krijgt nu een wizard te zien, doorloop deze met de default waarden. Join geen domein(!), anders gaat de capture van de image naar een .wim bestand mislukken. Ga voor de task sequence die je zonet gecreëerd hebt en duidt ook alle drie de applicaties aan wanneer daar om gevraagd wordt. 


**Als alles goed gaat kan je nu jouw client virtuele machine starten en zal Windows 10 geïnstalleerd worden met de laatste nieuwe updates verkregen via de server, alsook de applicaties zullen worden geïnstalleerd worden. Tot slot zal MDS ervoor zorgen dat de staat van deze machine opgeslagen wordt naar een .wim bestand. Dit bestand is onze 'referentie image' die we nu kunnen gebruiken om de clientcomputers mee te deployen.**

## 3. Deployen van referentie image.

1. Je mag de virtuele machine die gezorgd heeft voor het capturen van de image verwijderen.
2. Op je Windows Server maak je in nieuwe deployment share aan en importeer je een nieuw besturingssysteem. Dit heb je eerder hierboven gedaan, kies deze keer wel voor het zojuist gegenereerde .wim bestand in de *Captures* directory van je deployment share. 
3.  Bij de wizard om het besturingssysteem te importeren zal je nu echter niet voor de bovenste optie moeten kiezen maar wel voor de middelste: *Custom image file*.
4. Laat de volgende optie op default staan en vervolledig de wizard.     
5. Vervolgens creëren we een nieuwe *task sequence* voor deze deployment share.
6. Kies zelf een sequence id en naam en kies opnieuw voor *Standard Client taks*.
8. Doorloop de rest van de wizard: geef geen product key in en kies een admin wachtwoord.  
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
SkipTaskSequence=NO
DeploymentType=NEWCOMPUTER
SkipTimeZone=YES
SkipApplications=YES
SkipBitLocker=YES
SkipSummary=YES
SkipBDDWelcome=YES
SkipCapture=NO
DoCapture=NO
SkipFinalSummary=NO
UILanguage=0813:00000813
InputLocale=0813:00000813
SystemLocale=0813:00000813
UserLocale=0813:00000813
KeyboardLocale=0813:00000813
DoNotCreateExtraPartition = YES
TimeZoneName=Romance Standard Time 
JoinDomain=EXAMPLE
DomainAdmin=EXAMPLE\Administrator 
DomainAdminPassword=Vagrant123
WSUSServer=http://WIN-3HS2EJOHAUA:8530
SkipTaskSequence=YES
TaskSequenceID=sequenceid
```

En de bootstrap.ini naar volgende: 
```
[Settings]
Priority=Default

[Default]
DeployRoot=\\WIN-3HS2EJOHAUA\DeploymentShareProd$
UserDomain=example
SkipBDDWelcome=YES
UserID=Administrator
UserPassword=Vagrant12
```
*Uiteraard dien je de WSUSServer naam, domeinnaam, -usernamen en -wachtwoord en het task sequence id aan te passen naar je eigen waarden.
De meeste properties geven aan dat een bepaalde wizard die normaal wordt getoond bij het installeren mogen overgeslagen worden. Anderen stellen de tijdszone en toetsenbord layout goed in. Ook credentials om toegang te krijgen tot de netwerkshare en het domein worden meegegeven. Er wordt ook gezegd welke task sequence gebruikt moet worden en wat de naam is van de server die voor de Windows updates zorgt.*

11. Update de deployment share via rechtermuisknop te klikken op de naam. 
12. Nu zal er een image gegenereerd worden in de *Boot* directory. 
12. Ga naar *Windows deployment services* via *Tools* in *Windows server manager*.
14. Verwijder de boot image van daarnet en voeg de zojuist gecreëerde toe. 
15. Klik rechtermuisknop op de naam van de server en kies *restart* onder *actions*.
16. Tot slot kan je net zoals daarnet nieuwe virtuele machines aanmaken met dezelfde instellingen (belangrijk intnet netweradapter en bootvolgorde eerst hdd en dan network). Er zal automatisch de Windows 10 met updates en applicaties op geïnstalleerd worden. 

Auteur: Quinten De Bruyne





