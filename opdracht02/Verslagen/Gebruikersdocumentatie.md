# Gebruikersdocumentatie

## Stap 1: Installeren van vagrant

- Klik op de volgende [link](https://www.vagrantup.com/downloads.html)
- Download en installeer de software voor uw besturingssysteem

## Stap 2: Installeren van virtualbox 6.0.18

- Klik op de volgende [link](https://www.virtualbox.org/wiki/Download_Old_Builds_6_0)
- Download en installeer de software voor uw besturingssysteem

## Stap 2: Configureer naam en wachtwoord databases:

- Open de map provisoning
- Open het bestand settings.conf met uw favoriete tekseditor
- Verander de volgende variabelen naar wens:

| Config option |               |
| ------------- | ------------- |
| DrupalDBName  | Databasenaam voor Drupal        |
| DrupalUserName| Databasegebruikersnaam met rechten voor database Drupal        |
| DrupalDBPass    | Wachtwoord voor Drupal gebruiker        |

## Stap3: Starten van de virtuele machine:

- Open een terminal venster binnen de testomgeving map
- Voer volgend commando in om de vagrant setup te starten met uw geconfigureerde opties:
`vagrant up`

- Wenst u de machine als gebruiker te betreden voer dan volgend commando in vanals de virtuele machine volledig opgestart is:
`vagrant ssh`
- U bent nu aangemeld als gebruiker vagrant binnen de machine.

