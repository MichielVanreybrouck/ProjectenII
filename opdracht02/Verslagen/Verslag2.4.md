# Verslag opdracht 2.4

## Stap 1: Aanmaken van nieuwe vagrant omgeving voor Docker

1. Template folder vagrant invoegen
2. Naam veranderen naar dockeromgeving

## Stap 2: Aanmaken funties binnen provisioning/util.sh

1. Docker/docker-compose installeren met gepaste log
~~~~
install_docker(){
    dnf -y install dnf-plugins-core
  dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  dnf install -y docker-ce docker-ce-cli containerd.io
  dnf install -y docker-compose
  systemctl enable docker
  systemctl start docker
  log " -> Docker installed"
}
~~~~

2. Workaround tegen bugs binnen docker en fedora31

~~~~
dnf -y install grubby
  grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
  mkdir /sys/fs/cgroup/systemd
  mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
  log " -> Backwards compatibility cgroups installed"
~~~~

## Stap 3: Functies toevoegen aan m4.sh

1. Voeg volgende code toe aan m4.sh
~~~~
log "Starting server specific provisioning tasks on ${HOSTNAME}"

install_docker
fix_backwards_compatibility`
~~~~

## Stap 4: Shared folder vagrant en Dockercompose.yml
1. Maak nieuwe folder binnen vagrantfolder aan genaamd 'docker'
2. Maak de file 'docker-compose.yml' aan met volgende code:
~~~~
version: '3'

services:
  drupal:
    image: drupal:latest
    ports:
      - 80:80
    restart: always

  mariadb:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_DATABASE: drupal
      MYSQL_USER: drupal
      MYSQL_PASSWORD: drupal
      MYSQL_ROOT_PASSWORD: root    
~~~~

3. Voeg volgende code toe aan de Vagrantfile:
`Vagrant.configure("2") do |config|
  config.vm.synced_folder "docker/", "/home/vagrant/docker"
end` 

## Stap 5: Opstarten van VM en acties binnen VM

1. Open commandline en typ:
`vagrant up`

2. Log in als root met `su root` wachtwoord 'vagrant'
3. Ga naar de aangemaakt map docker met `cd docker`
4. Voer het volgende commando uit: `docker-compose up -d`
5. Docker draai nu 2 containers, 1 MariaDB container en 1 Drupal/web applicatie

## Stap 6: Bekijk drupal binnen browser

1. Open browser op lokale machine
2. Surf naar `192.168.56.31`. Dit opent de drupal installatie
3. Kies nederlands -> Save and continue
4. Kies Standaard -> Opslaan en doorgaan
5. Kies Mysql, MariaDB, .. en voer volgende gegevens in: (Deze gegevens zijn afhankelijk van de configuratie binnen docker/docker-compose.yml)

| Config option |               |
| ------------- | ------------- |
| Databasenaam  | drupal        |
| Gebruikersnaam| drupal        |
| Databasepw    | drupal        |

6. Kies Uitgebreide opties en voer in als host: `mariadb` -> opslaan en doorgaan
7. De installatie zal nu beginnen en correct voltooien.
