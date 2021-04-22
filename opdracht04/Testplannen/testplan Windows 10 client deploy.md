### Testplan: Windows 10 uitrol naar clients gebruikmakende van Windows Deployment Services

Indien het volledige proces van het capturen en deployen van de client getest wil worden, dan kan je het stappenplan beschreven in het verslag volgen. Dit is echter zeer tijdsintensief. Daarom heb ik van het uiteindelijke .wim bestand dat gecaptured werd [online beschikbaar gesteld](http://gofile.me/4zUgx/Tiq18wxfb). Download dit bestand.

## 1. Installeer Windows Server
Volg de volledige eerste allinea in [het verslag](https://github.com/HoGentTIN/p2ops-1920-g09/blob/master/opdracht04/Verslagen/Verslag%20cre%C3%ABren%20en%20deployen%20windows%2010%20reference%20image.md) om de Windows server op te zetten in VirtualBox. Gebruik dezelfde domeinnamen, gebruikersnamen en wachtwoorden (example.com, Administrator, Vagrant123 als wachtwoord). Ook de Windows Deployment Services zullen we gebruiken, installatie staat beschreven onder 2.5. Zet alle instellingen al goed, maar voeg straks pas een nieuw boot image toe.

## 2. Aanmaken van de deploymentshare.
1. Open de Deployment Workbench.
2.  Creëer een nieuwe share. Rechter muisknop > Create new deployment share. Kies vervolgens een locatie en naam. Zorg ook dat je straks het UNC path nog weet.
2. Klap de zojuist gecreëerde deployment share uit. Klik vervolgens rechter muisknop op *Operating Systems* > *Import operating system*.
3. Volg de wizard; kies voor de tweede optie *Custom image file* en selecteer het .wim bestand dat je eerder hebt gedownload. 
4. Laat de volgende optie op default staan en vervolledig de wizard.     
5. Vervolgens creëren we een nieuwe *task sequence* voor deze deployment share.
6. Kies zelf een sequence id en naam en kies opnieuw voor *Standard Client Task Sequence*.
8. Doorloop de rest van de wizard: geef geen product key in en kies een admin wachtwoord.
9. Klik rechtermuisknop op de task sequence > *properties*. Ga naar het tabblad *Task sequence*. Onder *State restore* vind je zowel voor als na de stap om applicaties te installeren de stap *Windows updates*. Enable deze stap door deze te selecter en in het tabblad options het vinkje voor *Disable this step* uit te vinken.
9. We gaan de *rules* van deze deployment share wat aanpassen. Klik rechtermuisknop op de share en ga voor *properties*.
10. Vervolgens ga je naar het *rules* tabblad en vervang dit door volgend:
```
[Settings]
Priority=Default

[Default]
_SMSTSORGNAME=EXAMPLE.COM
OSInstall=Y
SkipAppsOnUpgrade=YES
SkipTaskSequence=YES
TaskSequenceID=sequenceid
SkipAdminPassword=YES
SkipProductKey=YES
SkipComputerName=YES
SkipDomainMembership=YES
SkipUserData=YES
UserDataLocation=AUTO
SkipLocaleSelection=YES
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
DoNotCreateExtraPartition = YES
TimeZoneName=Romance Standard Time 
JoinDomain=EXAMPLE
DomainAdmin=EXAMPLE\Administrator 
DomainAdminPassword=Vagrant123
WSUSServer=http://WIN-3HS2EJOHAUA:8530
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
UserPassword=Vagrant123
SkipTaskSequence=YES
TaskSequenceID=sequenceid
```
*Uiteraard dien je de WSUSServer naam, domeinnaam, -usernamen en -wachtwoord en het task sequence id aan te passen naar je eigen waarden. De Deployroot is het UNC path van je deployment share en UserID en UserPassword zijn de credentials die nodig zijn om toegang te krijgen tot de deployment share. 
De meeste properties geven aan dat een bepaalde wizard die normaal wordt getoond bij het installeren mogen overgeslagen worden. Anderen stellen de tijdszone en toetsenbord layout goed in. Ook credentials om toegang te krijgen tot de netwerkshare en het domein worden meegegeven. Er wordt ook gezegd welke task sequence gebruikt moet worden en wat de naam is van de server die voor de Windows updates zorgt.*

11. Update de deployment share via rechtermuisknop te klikken op de naam. 
12. Nu zal er een image gegenereerd worden in de *Boot* directory.


## 3. Deployen van het Windows 10 besturingssysteem.

1. Ga naar *Server manager* > *Tools* > *Windows deployment services*.
2. Expand de servernode, klik rechtermuisknop op *Boot images* en kies voor *Add boot image*.
3. Browse naar de drive waarop de image file gemount is. Selecteer het .wim bestand in de folder *\Deploy\Boot*. Vervolledig de wizard.
4. Restart de server nog eens: rechtermuisknop op de naam van de server (in wds) > All tasks > Restart.

## 4. Aanmaken van de nieuwe virtuele machine.
1. Creëer een nieuwe virtuele machine, kies voor Windows 10 64bit.
2. Behoud de standaardwaarden.
3. Ga naar *settings* > *network*. Stel 1 netwerkadapter in op een intern netwerk met dezelfde naam als dat van de Windows Server.
4. Ga naar *settings* > *System*. Stel de bootorder zo in dat er eerst geboot wordt vanaf de harde schijf en daarna vanaf het netwerk. 
5. Ga naar *settings* > *network* > *Adapter 1* > *Advanced*. Zet *Promisuous mode* op allow all. Doe dit ook voor de interne netwerk adapter van de Windows Server. 
6. Start de virtuele machine en alles zal automatisch geïnstalleerd worden.

## 5. Controleren applicaties
1. Zoek naar Adobe reader, Java en LibreOffice in *Program Files* of *Program Files x86*. Je zult zien dat deze applicaties geïnstalleerd zijn.
2. Controleer of je de laatste Windows updates hebt bij *Settings*
