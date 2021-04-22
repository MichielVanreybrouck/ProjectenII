# Opdracht 2: Automatiseren opzetten Linux-servers

## Opdrachtomschrijving: Linux-Webapplicatieservers

Verschillende klanten vragen ons om hun **webapplicatie** te hosten. Tot nu toe hebben we altijd manueel een server opgezet waarbij de nodige software geïnstalleerd en geconfigureerd werd. Door de groeiende vraag is dit niet houdbaar. De bedoeling is een soort "sjabloon" uit te werken zodat we veel sneller een nieuwe server kunnen opzetten die meteen geconfigureerd is om een applicatie op te draaien. Om het voor webapplicatie-ontwikkelaars eenvoudiger te maken om op hun eigen laptop een **testomgeving** op te zetten, is de eerste stap het creëren van VirtualBox VMs. Uiteindelijk is het de bedoeling om deze in de cloud te reproduceren.

We splitsen deze opdracht op in enkele mijlpalen

### M1. Lokale testomgeving

- De VMs worden aangemaakt met [Vagrant](https://www.vagrantup.com/). In je repository is reeds een startomgeving voorzien waarmee je al aan de slag kan. Je moet geen Linux installatie-ISO's downloaden: de instatie van het OS wordt geautomatiseerd door Vagrant.
- Een eerste opstelling is de klassieke LAMP-stack (Linux+Apache+MariaDB+PHP) en bestaat uit volgende componenten (vrij te kiezen door het team):
    - Linux: [CentOS 8](https://app.vagrantup.com/bento/boxes/centos-8) of [Fedora 31 Server](https://app.vagrantup.com/bento/boxes/fedora-31) (zonder grafische omgeving)
    - Webserver: Apache of nginx
    - Database: MariaDB of PostgreSQL
    - Webapplicatie: Drupal (of een andere PHP-applicatie)
- De volledige opstelling is geautomatiseerd met Bash-scripts. De installatie van de webapplicatie (en eventuele dependencies) wordt in een apart script uitgevoerd (de klant kan immers een andere PHP-applicatie willen draaien).
- Maak het script configureerbaar. De gebruiker moet bijvoorbeeld zelf in staat zijn zelf de naam van de database en wachtwoorden te kiezen, bijvoorbeeld door een configuratiebestand met de nodige instellingen aan te passen.
- Heb oog voor beveiliging:
    - SELinux staat aan (Enforcing)
    - Er is een firewall die enkel het noodzakelijke verkeer doorlaat (SSH, HTTP, HTTPS)
    - ...
- Heb ook oog voor programmeerstijl. Pas de technieken toe die je geleerd hebt bij Besturingssystemen: Linux. Wie een stap verder wil gaan kan [deze presentatie over Bash scripting](https://gitpitch.com/bertvv/presentation-clean-bash) bekijken.

**Deliverables:**

- Vagrant-omgeving met 1 VM
- Installatie-script webserver + database
- Installatie-script webapplicatie
- Technische documentatie:
    - Hoe kan een teamlid de opstelling reproduceren zonder hulp?
    - Cheat sheet: wat zijn de belangrijkste commando's om de VM te beheren en om problemen op te lossen?
- Gebruikersdocumentatie: hoe kan een PHP-developer zonder hulp de VM configureren opstarten?
- Testplan en -rapport

### M2. Monitoring

- Om een goede werking van een productie-server te kunnen opvolgen, heb je een monitoringsysteem nodig. Pas het installatie-script aan om [Cockpit](https://cockpit-project.org/) op de VM te activeren.
- Voer een load test uit op de webserver vanaf het fysieke systeem. Gebruik bv. [httperf](https://github.com/httperf/httperf) of een andere load testing tool. Volg via Cockpit op hoe de webserver zich gedraagt. Vanaf welke load vertraagt de server? Wanneer valt die volledig uit? Welke systeembron is het eerst overbelast: RAM, CPU, Disk I/O, Network I/O, ...?

**Deliverables:**

- Aangepast installatiescript
- Aangepaste technische documentatie
- Testplan en -rapport van de load tests

### M3. Productie-omgeving

De bedoeling is om servers met *exact dezelfde* configuratie in een **productie-omgeving** te kunnen opzetten. We denken er aan om dit uit te besteden via een Infrastructure as a Service/public cloud provider .

De volgende Public Cloud providers geven gratis credits via het [Github Student Pack](https://education.github.com/pack):

- [Digital Ocean](https://www.digitalocean.com/)
- [Amazon Web Services Educate](https://aws.amazon.com/education/awseducate/)
- [Azure](https://aka.ms/devtoolsforteaching)

Kies een van deze platformen en reproduceer de testopstelling uit VirtualBox in de cloud. Maak voor monitoring eventueel gebruik van de functionaliteiten van de cloud-omgeving. Als jullie scripts voldoende configureerbaar zijn, is er slechts een minimum aan wijzigingen nodig.

**Deliverables:**

- Aangepaste installatie-scripts zodat ze zowel lokaal als in de gekozen cloud-omgeving bruikbaar zijn
- Technische documentatie: hoe kan een teamlid de opstelling reproduceren?
- Testplan- en rapport

### M4. Containervirtualisatie

Meer en meer bedrijven stappen over van de klassieke [VM hypervisor](https://en.wikipedia.org/wiki/Hypervisor) naar [containervirtualisatie](https://en.wikipedia.org/wiki/OS-level_virtualization). Een product dat op korte tijd enorm populair geworden is, is [Docker](https://www.docker.com/). De hype rond Docker was hevig, maar is intussen aan het afkoelen. Containervirtualisatie zal ongetwijfeld belangrijk blijven, maar er zijn meerdere spelers op het toneel verschenen. De bedoeling is om met deze technologieën te experimenteren om te onderzoeken of het interessant is om jullie klanten hier support voor aan te bieden.

- Zet een nieuwe VM op waarop je een containervirtualisatieplatform installeert: Podman of Docker.
- Installeer Cockpit met de plugin voor het monitoren van containers.
- Zet een gelijkaardige omgeving op zoals de eerste VM: een PHP-applicatie met een database-backend. Je zal minstens 2 containers nodig hebben: één voor de database, één voor de webserver + applicatie. Het automatiseren van het opzetten van meerdere containers die samenwerken wordt vaak gedaan met Docker Compose. Voor Podman bestaat er ongetwijfeld een gelijkaardige tool.
- Zorg dat de website te zien is vanop het fysieke systeem via het IP-adres van de VM en de normale poorten voor webserververkeer. Je zal port-forwardingregels moeten instellen om netwerkverkeer op die poorten door te sturen naar de gepaste container.
- Herhaal de load tests uit de vorige iteratie. Gedraagt deze opstelling zich fundamenteel anders? Kan de webserver meer trafiek aan of niet? Waar bevindt zich nu de bottleneck?

In eerste instantie plannen we nog niet dit in een publieke cloud-omgeving uit te rollen of aan klanten aan te bieden. Documentatie voor eindgebruikers is hier dan ook niet nodig.

**Deliverables:**

- Installatiescripts VM, containers
- Technische documentatie:
    - Hoe kan een teamlid de opstelling reproduceren?
    - Aangevuld cheat sheet: belangrijkste commando's om met Docker/Podman te werken
- Testplan en -rapport basisopstelling + load tests

### Acceptatiecriteria

- Het moet voor een applicatie-ontwikkelaar eenvoudig zijn om een **testomgeving** op te zetten voor het draaien van een webapplicatie met database-backend.
    - Dit toon je aan door een demo te geven van een webapplicatie die op het platform draait (bv. Drupal)
    - Toon ook de resultaten van de load tests
- Het opzetten van deze servers moet **exact reproduceerbaar** zijn. Om écht op schaal bruikbaar te zijn, moet je het installatieproces automatiseren. Een teamlid moet, zonder manuele tussenkomst, in staat zijn om de hele opstelling *from scratch* op te zetten met het commando `vagrant up`
- Er is de nodige aandacht besteed aan **herbruikbaarheid**.
    - De scripts zijn bruikbaar op verschillende types systemen: binnen de VirtualBox testomgeving op je desktop, binnen één van de voorgestelde cloud platformen.
    - Instellingen die specifiek zijn voor een applicatie (bv. database-gebruikersnaam en wachtwoord) zijn configureerbaar. Vermijd dus "hard-coded" data tussen de code, maar gebruik waar mogelijk variabelen.
    - Maak onderscheid tussen het installatiescript voor het *platform* (dat herbruikbaar is) en de webapplicatie zelf (door de gebruiker bepaald)
- Er is een proof-of-concept opgezet met een **public cloud platform** (hetzij uit de opgegeven providers/producten hetzij een ander na afspraak met de begeleiders).
- Toon een demo van het **containervirtualisatieplatform** en de load tests
