# Verslag opdract 2.2

## Installeren van Cockpit

- Open een ssh verbinding naar de VM-box (zie verslag opdracht 2.1)
- Voer het volgende commando in om Cockpit te installeren

> sudo yum install cockpit

- Voer het volgende commando in om Cockpit te starten

> sudo systemctl enable --now cockpit.socket

- Cockpit is nu geïnstalleerd op je VM-box
- Voor eventuele firewall, voer de volgende commando's in

```bash
sudo firewall-cmd --permanent --zone=public --add-service=cockpit
sudo firewall-cmd --reload
```

## Openen van de Cockpit GUI

- Start de vagrant box op
- Log in met de volgende credentials:
  - Login: vagrant
  - Wachtwoord: vagrant
- Voer het volgende commando in

> ifconfig

- Bij 'eth1', neem het eerste ip adres na 'inet'
- Open een webbrowser
- Voer de volgende url in: *ip-adres*:9090

Auteur(s) verslag: Michiel Vanreybrouck
