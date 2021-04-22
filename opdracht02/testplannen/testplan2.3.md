# Testplan taak 3: Productieomgeving in de cloud

## Volg eerst de stappen van het verslag. Zorg dat je het github student pack hebt geactiveerd. Via het Github student pack kan je een gratis "Azure for student" account krijgen. Zorg er ook voor dat er geen "gratis versie" van azure geactiveerd is je account want dan zal er niks werken.

## Test 1: Kijken of de juiste versie van CentOS is geïnstalleerd

- Maak connectie met de vm via PuTTY
- Log in met je naam en wachtwoord
- Voer volgende commando in

> rpm -q centos-release

- Test resultaat positief:
  - CentOS release version is 8.0.0
- Test resultaat negatief:
  - CentOS release version is niet 8.0.0
  
## Test 2: Kijken of apache actief is

- Maak connectie met de vm via PuTTY
- Log in met je naam en wachtwoord
- Voer volgende commando in

> systemctl status httpd

- Test resultaat positief:
  - Het puntje active staat op active
- Test resultaat negatief:
  - Apache staat niet op active

## Test 3: Kijken of MariaDB actief is

- Maak connectie met de vm via PuTTY
- Log in met je naam en wachtwoord
- Voer volgende commando in

> sudo systemctl is-active mariadb.service

- Test resultaat positief:
  - Active
- Test resultaat negatief:
  - Inactive

## Test 4: Kijken of Drupal is geïnstalleerd

- Maak connectie met de vm via PuTTY
- Log in met je naam en wachtwoord
- Voer het volgende commando in

> ifconfig

- Bij 'eth0', neem het eerste ip adres na 'inet'
- Voer het commando 'ping' uit met als parameter het ip adres uit de vorige stap 
- Test resultaat positief:
  - Je krijgt antwoord op je ping bericht
- Test resultaat negatief
  - Je krijgt geen antwoord op je ping bericht
