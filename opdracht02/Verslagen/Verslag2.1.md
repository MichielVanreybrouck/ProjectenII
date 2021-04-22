# Verslag opdracht 2.1

## Installeren van vagrant

- Klik op de volgende [link](https://www.vagrantup.com/downloads.html)
- Download en installeer de software

## VM-box aanmaken met vagrant

- Open een terminal
- Navigeer naar de map waarin de vagrant file is gelokaliseerd
- Typ in de terminal het volgende commando

> vagrant up

- Nu wordt een vagrant machine opgestart, hierbij wordt een vm aangemaakt die vooraf is geconfigureerd.

## SSH connectie opstellen met de aangemaakte VM-box

- Open een terminal
- Navigeer naar de map waarin de vagrant file is gelokaliseerd
- Typ in de terminal het volgende commando

> vagrant ssh

- SSH connectie via vagrant opgestart met username Vagrant

## Verwijderen van een running vagrant VM-box

- Open een terminal
- Navigeer naar de map waarin de vagrant file is gelokaliseerd
- Typ in de terminal het volgende commando

> vagrant destroy

- Bij de vraag: "Are you sure you want to destroy the 'srv001' VM?" typ "y" en druk op enter

Auteur(s) verslag: Michiel Vanreybrouck

## Stap 1: CentOS8 als operating system

- Open vagrantfile van de testomgeving
- Voeg volgende code toe:
`DEFAULT_BASE_BOX = 'bento/centos-8'`

## Stap 2: Script Webserver apache

- Open util.sh in de provisioning map
- Onder "Services" voer volgende code in voor de installatie en start van de webserver:
~~~~
install_apache(){
  log "Installing and starting apache webserver.."
  dnf -y install httpd
  systemctl enable httpd
  systemctl start httpd

  pgrep -x httpd && log " -> Apache installed and running" || log " -> Apache didn't install correctly"
}
~~~~

- Vul binnen srv001.sh de naam van het script `install_apache` aan onderaan bij "Provision server" om het effectief te starten bij het `vagrant up` commando.

## Stap 3: Script Database Mariadb

- Open util.sh in het provisioning map
- Onder "Services" voer volgende code in voor de installatie en start van de database server en het beveiligen ervan:
~~~~
install_mariadb(){
  log "Installing MariaDB server.."
  yum -y install mariadb-server mariadb
  log "Starting MariaDB server.."
  systemctl start mariadb

  log "Securing database installation.."
  db_root_password="root"
  mysql -u root <<EOF
  UPDATE mysql.user SET Password=PASSWORD('${db_root_password}') WHERE User='root';
  DELETE FROM mysql.user WHERE User='';
  DROP DATABASE IF EXISTS test;
  DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
  FLUSH PRIVILEGES;
EOF


  log " -> MariaDB installed and running"
}
~~~~

- Vul binnen srv001.sh de naam van het script `install_mariadb` aan onderaan bij "Provision server" om het effectief te starten bij het `vagrant up` commando.

## Stap 4: Script Drupal

- Maak een aparte drupal.sh file aan in de provisioning map
- Voeg binnen srv001.sh volgende code toe onder "Imports" om drupal.sh te importeren:
~~~~
source ${PROVISIONING_SCRIPTS}/drupal.sh
~~~~

- Voeg binnen drupal volgende code toe:
~~~~
install_drupal(){

  . /vagrant/provisioning/settings.conf

  log "Installing Drupal.."

  # creating database for drupal  
  log "creating database.."

  mysql -u root -p"root" <<EOF
  CREATE DATABASE $DrupalDBName;
  CREATE USER $DrupalUserName IDENTIFIED BY '${DrupalDBPass}';
  GRANT ALL PRIVILEGES ON ${DrupalDBName}.* TO $DrupalUserName;
  FLUSH PRIVILEGES; 
EOF
  log "Database created!"
  
  # mysql -u drupal -p -> access drupal database

  # installing PHP and extensions
  log "Installing php.."
  dnf install -y @php
  dnf install -y php php-{cli,mysqlnd,json,opcache,xml,mbstring,gd,curl}
  log "Php installed!"
  # php -v -> check version PHP
  # starting PHP service
  log "Enabling php.."
  systemctl enable --now php-fpm
  log "Php enabled!"
  # systemctl status php-fpm -> check status php service
  # installing drupal
  dnf -y install wget
  DRUPAL_VERSION="8.8.2"
  wget https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz
  log "Drupal downloaded correctly.."
  # extract file
  tar xvf drupal-${DRUPAL_VERSION}.tar.gz
  
  # move folder to drupal
  mv drupal-${DRUPAL_VERSION} /var/www/html/drupal
  # creating additional dir
  mkdir /var/www/html/drupal/sites/default/files
  cp /var/www/html/drupal/sites/default/default.settings.php /var/www/html/drupal/sites/default/settings.php
  # setting permissions
  semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/drupal(/.*)?"
  semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/drupal/sites/default/settings.php'
  semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/drupal/sites/default/files'
  restorecon -Rv /var/www/html/drupal
  restorecon -v /var/www/html/drupal/sites/default/settings.php
  restorecon -Rv /var/www/html/drupal/sites/default/files
  chown -R apache:apache  /var/www/html/drupal
  # config file creation
  touch /etc/httpd/conf.d/drupal.conf

  systemctl restart httpd

  log " -> Drupal installed"
}
~~~~

- Vul binnen srv001.sh de naam van het script `install_drupal` aan onderaan bij "Provision server" om het effectief te starten bij het `vagrant up` commando.

## Stap 5: settings file

- Maak een nieuwe file aan in de provisioning map: settings.conf
- Voer volgende code in in deze file. Dit zijn de variabelen die later bij de installatie van drupal gebruikt zullen worden en makkelijk aan te passen zijn door de eindgebruiker.
~~~~
#Configuration file for vagrant setup
DrupalDBName="drupalConf"
DrupalUserName="drupalConf"
DrupalDBPass="drupalConf"
~~~~