# Installing drupal
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


