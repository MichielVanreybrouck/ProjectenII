# Testplan taak 4: Docker opstelling

## Test 1: Check of vagrant correct opstart

1. Download en save de dockeromgeving 
2. Open commandline en voer volgend commando in:

`vagrant up`

- Test resultaat positief:
  - Vagrant start de virtuele machine op zonder fouten
- Test resultaat negatief:
  - Vagrant stopt de installatie bij een fout
**Resultaat:** Error bij installatie: :x:
```
`path` for shell provisioner does not exist on the host system: /home/quintendebruyne/Documents/projecten2/p2ops-1920-g09/opdracht02/dockeromgeving/provisioning/M4.sh
```
Mogelijke oplossing: verander in path de naam naar m4.sh of vernader de naam van het bestand naar M4.sh. 
 
## Test 2: Check op docker-compose.yml goed opstart

1. Log in als root (wachtwoord: vagrant)

`sudo root`

2. Ga naar de docker map en run de docker-compose.yml file:

`cd docker`
`docker-compose up -d`

- Test resultaat positief:
  - Het commando voert uit zonder fouten
- Test resultaat negatief:
  - Het commando geeft ERRORS

## Test 3: Check of de website beschikbaar is en installatie werkt

Ga op lokale machine naar: `192.168.56.31`
- Surf naar `192.168.56.31`
3. Kies nederlands -> Save and continue
4. Kies Standaard -> Opslaan en doorgaan
5. Kies Mysql, MariaDB, .. en voer volgende gegevens in: (Deze gegevens zijn afhankelijk van de configuratie binnen docker/docker-compose.yml)

| Config option |               |
| ------------- | ------------- |
| Databasenaam  | drupal        |
| Gebruikersnaam| drupal        |
| Databasepw    | drupal        |

6. Kies Uitgebreide opties en voer in als host: `mariadb` -> opslaan en doorgaan

- Test resultaat positief:
  - Drupal installeert en geeft geen fouten bij connectie met database
- Test resultaat negatief:
  - Drupal pagina opent niet of geeft fouten bij database/installatie
