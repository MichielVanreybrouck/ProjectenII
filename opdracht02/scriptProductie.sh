#! /bin/bash
#
# Utility functions that are useful in all provisioning scripts.

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Set to 'yes' if debug messages should be printed.
readonly debug_output='yes'

#------------------------------------------------------------------------------
# Logging and debug output
#------------------------------------------------------------------------------

# Three levels of logging are provided: log (for messages you always want to
# see), debug (for debug output that you only want to see if specified), and
# error (obviously, for error messages).

# Usage: log [ARG]...
#
# Prints all arguments on the standard output stream
log() {
  printf '\e[0;33m[INFO]  %s\e[0m\n' "${*}"
}

# Usage: debug [ARG]...
#
# Prints all arguments on the standard error stream
debug() {
  if [ "${debug_output}" = 'yes' ]; then
    printf '\e[0;36m[DEBUG] %s\e[0m\n' "${*}" 1>&2
  fi
}

# Usage: error [ARG]...
#
# Prints all arguments on the standard error stream
error() {
  printf '\e[0;31m[ERROR] %s\e[0m\n' "${*}" 1>&2
}

#------------------------------------------------------------------------------
# Useful tests
#------------------------------------------------------------------------------

# Usage: files_differ FILE1 FILE2
#
# Tests whether the two specified files have different content
#
# Returns with exit status 0 if the files are different, a nonzero exit status
# if they are identical.
files_differ() {
  local file1="${1}"
  local file2="${2}"

  # If the second file doesn't exist, it's considered to be different
  if [ ! -f "${file2}" ]; then
    return 0
  fi

  local -r checksum1=$(md5sum "${file1}" | cut -c 1-32)
  local -r checksum2=$(md5sum "${file2}" | cut -c 1-32)

  [ "${checksum1}" != "${checksum2}" ]
}


#------------------------------------------------------------------------------
# SELinux
#------------------------------------------------------------------------------

# Usage: ensure_sebool VARIABLE
#
# Ensures that an SELinux boolean variable is turned on
ensure_sebool()  {
  local -r sebool_variable="${1}"
  local -r current_status=$(getsebool "${sebool_variable}")

  if [ "${current_status}" != "${sebool_variable} --> on" ]; then
    setsebool -P "${sebool_variable}" on
  fi
}

#------------------------------------------------------------------------------
# User management
#------------------------------------------------------------------------------

# Usage: ensure_user_exists USERNAME
#
# Create the user with the specified name if it doesn’t exist
ensure_user_exists() {
  local user="${1}"
  log "Ensure user ${user} exists"
  if ! getent passwd "${user}"; then
    log " -> user added"
    useradd "${user}"
  else
    log " -> already exists"
  fi
}

# Usage: ensure_group_exists GROUPNAME
#
# Creates the group with the specified name, if it doesn’t exist
ensure_group_exists() {
  local group="${1}"

  log "Ensure group ${group} exists"
  if ! getent group "${group}"; then
    log " -> group added"
    groupadd "${group}"
  else
    log " -> already exists"
  fi
}

# Usage: assign_groups USER GROUP...
#
# Adds the specified user to the specified groups
assign_groups() {
  local user="${1}"
  shift
  log "Adding user ${user} to groups: ${*}"
  while [ "$#" -ne "0" ]; do
    usermod -aG "${1}" "${user}"
    shift
  done
}

#------------------------------------------------------------------------------
# Services
#------------------------------------------------------------------------------

# Usage: install_apache
#
# Install and start apache webserver
install_apache(){
  log "Installing and starting apache webserver.."
  dnf -y install httpd >/dev/null
  systemctl enable httpd >/dev/null
  systemctl start httpd >/dev/null

  pgrep -x httpd >/dev/null && log " -> Apache installed and running" || log " -> Apache didn't install correctly"
}


# Usage: install_mariadb
#
# Install and configure maria_db

install_mariadb(){
  log "Installing MariaDB server.."
  yum -y install mariadb-server mariadb >/dev/null
  log "Starting MariaDB server.."
  systemctl start mariadb >/dev/null

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

install_cockpit(){
  # installing cockpit
  log "Installing cockpit.."
  yum install cockpit -y >/dev/null
  log "Cockpit starting.."
  systemctl enable --now cockpit.socket >/dev/null
  log " -> Cockpit installed and started"
  
}

setup_firewall(){
  log "Starting firewall.."
  systemctl enable firewalld >/dev/null
  systemctl start firewalld >/dev/null
  log "Adding firewall rules"
  firewall-cmd --add-service={http,https} --permanent >/dev/null
  firewall-cmd --permanent --zone=public --add-service=cockpit >/dev/null
  firewall-cmd --reload >/dev/null
  log " -> Firewall enabled correctly"
}

# Installing drupal
install_drupal(){

  log "Installing Drupal.."
  db_drupal_password="drupal"

  # creating database for drupal  
  log "creating database.."

  mysql -u root -p"root" <<EOF
CREATE DATABASE drupal;
CREATE USER drupal IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON drupal.* TO drupal;
FLUSH PRIVILEGES; 
EOF
  log "Database created!"

  # mysql -u drupal -p -> access drupal database

  # installing PHP and extensions
  log "Installing php.."
  dnf install -y @php >/dev/null
  dnf install -y php php-{cli,mysqlnd,json,opcache,xml,mbstring,gd,curl} >/dev/null
  log "Php installed!"
  # php -v -> check version PHP
  # starting PHP service
  log "Enabling php.."
  systemctl enable --now php-fpm >/dev/null
  log "Php enabled!"
  # systemctl status php-fpm -> check status php service
  # installing drupal
  dnf -y install wget >/dev/null
  DRUPAL_VERSION="8.8.2"
  wget https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz >/dev/null 2>&1
  log "Drupal downloaded correctly.."
  # extract file
  tar xvf drupal-${DRUPAL_VERSION}.tar.gz >/dev/null 2>&1
  
  # move folder to drupal
  mv drupal-${DRUPAL_VERSION} /var/www/html/drupal
  # creating additional dir
  mkdir /var/www/html/drupal/sites/default/files
  cp /var/www/html/drupal/sites/default/default.settings.php /var/www/html/drupal/sites/default/settings.php
  # setting permissions
  semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/drupal(/.*)?" >/dev/null 2>&1
  semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/drupal/sites/default/settings.php' >/dev/null 2>&1
  semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/drupal/sites/default/files' >/dev/null 2>&1
  restorecon -Rv /var/www/html/drupal >/dev/null 2>&1
  restorecon -v /var/www/html/drupal/sites/default/settings.php >/dev/null 2>&1
  restorecon -Rv /var/www/html/drupal/sites/default/files >/dev/null 2>&1
  chown -R apache:apache  /var/www/html/drupal >/dev/null 2>&1
  # config file creation
  touch /etc/httpd/conf.d/drupal.conf >/dev/null 2>&1

  systemctl restart httpd

  log " -> Drupal installed"
}

log "Starting server specific provisioning tasks on ${HOSTNAME}"
log "Creating user"

ensure_user_exists groep9
ensure_group_exists admin 
assign_groups groep9 admin

install_apache
install_mariadb
install_drupal 
install_cockpit
setup_firewall