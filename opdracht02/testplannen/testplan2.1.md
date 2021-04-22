# Testplan taak 1: Lokale testomgeving

## Initial: Settings.conf

- Voeg in de settings.conf file de gewenste database namen en wachtwoorden in

## Test 1: Kijken of de juiste versie van CentOS is geïnstalleerd

- Open een terminal
- Ga naar de plaats waar je vagrant file staat
- Voer het volgende commando in

> vagrant ssh

- Voer volgende commando in

`rpm -q centos-release`

- Test resultaat positief:
  - CentOS release version is 8.1.1
- Test resultaat negatief:
  - CentOS release version is niet 8.1.1

## Test 2: Kijken of apache actief is

- Open een terminal
- Ga naar de plaats waar je vagrant file staat
- Voer het volgende commando in

> vagrant ssh

- Voer volgende commando in

`systemctl status httpd`

- Test resultaat positief:
  - Het puntje active staat op active
- Test resultaat negatief:
  - Apache staat niet op active

## Test 3: Kijken of MariaDB actief is

- Open een terminal
- Ga naar de plaats waar je vagrant file staat
- Voer het volgende commando in

> vagrant ssh

- Voer volgende commando in

`sudo systemctl is-active mariadb.service`

- Test resultaat positief:
  - Active
- Test resultaat negatief:
  - Inactive

## Test 4: Check of Drupal geïnstalleerd is

- Open een terminal
- Ga naar de plaats waar je vagrant file staat
- Voer het volgende commando in

> vagrant ssh

- Voer het volgende commando in

`ifconfig`

- Bij 'eth1', neem het eerste ip adres na 'inet'
- Open een webbrowser
- Voer de volgende url in: 192.168.56.31/drupal
- Test resultaat positief:
  - Je kan drupal configureren
- Test resultaat negatief
  - Drupal verschijnt niet op het scherm

Auteur(s) testplan: Michiel Vanreybrouck, Dries Melkebeke
