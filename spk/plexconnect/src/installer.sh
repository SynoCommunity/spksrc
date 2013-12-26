#!/bin/sh

# Package
PACKAGE="plexconnect"
DNAME="PlexConnect"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
CFG_FILE="share/PlexConnect/Settings.cfg"
RUNAS="${PACKAGE}"
PYTHON="${PYTHON_DIR}/bin/python"
APACHE_DIR="/usr/syno/apache"
HTTPD_CONF_USER="${APACHE_DIR}/conf/httpd.conf-user"
VHOST_FILE="${APACHE_DIR}/conf/extra/plexconnect-vhosts.conf"
INSTALLER_LOG="/../../@tmp/installer.log"
## not in use yet
#HTTPD_SSL_CONF_USER="${APACHE_DIR}/conf/extra/httpd-ssl.conf-user"
#VHOST_SSL_FILE="${APACHE_DIR}/conf/extra/plexconnect-ssl-vhosts.conf"

installer_log() {
  return
  echo "INSTALLER: ${1}" >> "${INSTALLER_LOG}"
}

preinst ()
{
  installer_log "-- preinst"
  exit 0
}

postinst ()
{
  installer_log "-- postinst"
  # Link
  ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

  # Create user
  adduser -h ${INSTALL_DIR} -g "${DNAME} User" -G users -s /bin/sh -S -D ${PACKAGE}

  # Create the certificates
  #openssl req -new -nodes -newkey rsa:2048 -out "${INSTALL_DIR}/etc/certificates/trailers.pem" -keyout "${INSTALL_DIR}/etc/certificates/trailers.key" -x509 -days 7300 -subj "/C=US/CN=trailers.apple.com"
  #openssl x509 -in "${INSTALL_DIR}/etc/certificates/trailers.pem" -outform der -out "${INSTALL_DIR}/etc/certificates/trailers.cer" && cat "${INSTALL_DIR}/etc/certificates/trailers.key" >> "${INSTALL_DIR}/etc/certificates/trailers.pem"

  # Edit the configuration according to the wizard
  if [ "${wizard_dns_server}" != "" ]; then
    sed -i -e "s|8.8.8.8|${wizard_dns_server}|g" ${INSTALL_DIR}/${CFG_FILE}
    installer_log "Using wizard_dns_server"
  else
    installer_log "Not Using wizard_dns_server"
  fi

  #add VHOST_FILE
  cp -f ${INSTALL_DIR}/app/plexconnect-vhosts.conf ${VHOST_FILE}
  if [ "${wizard_ip}" != "" ]; then
    installer_log "Using wizard_ip"
    sed -i -e "s|127.0.0.1|$wizard_ip|g" ${VHOST_FILE}
  else
    installer_log "Not Using wizard_ip"
  fi
  #add VHOST_SSL_FILE
  #cp -f ${INSTALL_DIR}/app/plexconnect-ssl-vhosts.conf ${VHOST_SSL_FILE}

  # make a copy of HTTPD_CONF_USER
  cp ${HTTPD_CONF_USER} ${HTTPD_CONF_USER}.bak
  # include our VHOST_FILE
  echo "Include ${VHOST_FILE}" >> ${HTTPD_CONF_USER}

  # make a copy of HTTPD_SSL_CONF_USER
  #cp ${HTTPD_SSL_CONF_USER} ${HTTPD_SSL_CONF_USER}.bak
  # include our VHOST_SSL_FILE
  #echo "Include ${VHOST_SSL_FILE}" >> ${HTTPD_SSL_CONF_USER}

  # restart apache
  /usr/syno/etc.defaults/rc.d/S97apache-user.sh restart > /dev/null

  # Correct the files ownership
  chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

  exit 0
}

preuninst ()
{
  installer_log "-- preuninst"
  # Remove the user (if not upgrading)
  if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
    deluser ${PACKAGE}
  fi

  exit 0
}

postuninst ()
{
  installer_log "-- postuninst"
  # Remove link
  rm -f ${INSTALL_DIR}

  # remove plexconnect-vhosts.conf
  sed -i -e "/^Include.*plexconnect-vhosts\.conf$/d" ${HTTPD_CONF_USER}
  # remove plexconnect-ssl-vhosts.conf
  #sed -i -e "/^Include.*plexconnect-ssl-vhosts\.conf$/d" ${HTTPD_SSL_CONF_USER}

  #remove plexconnect-vhosts.conf
  rm -fr ${VHOST_FILE}
  #remove plexconnect-ssl-vhosts.conf
  #rm -fr ${VHOST_SSL_FILE}

  # restart apache
  /usr/syno/etc.defaults/rc.d/S97apache-user.sh restart > /dev/null

  exit 0
}

preupgrade ()
{
  installer_log "-- preupgrade ${TMP_DIR}/${PACKAGE}"
  rm -fr ${TMP_DIR}/${PACKAGE}
  mkdir -p ${TMP_DIR}/${PACKAGE}

  # Save post upgrade configuration files
  installer_log "backup configuration"
  cp ${INSTALL_DIR}/share/PlexConnect/*.cfg ${TMP_DIR}/${PACKAGE}/

  # backup certificates
  if [ -f ${INSTALL_DIR}/etc/certificates/trailers.cer ]; then
    installer_log "backup certificates"
    mkdir -p ${TMP_DIR}/${PACKAGE}/certificates
    cp ${INSTALL_DIR}/etc/certificates/* ${TMP_DIR}/${PACKAGE}/certificates
  fi

  #remember ip address
  installer_log "backup IP"
  cat ${VHOST_FILE} | grep "ProxyPassReverse"  | awk -F:// '{print $2}' |  awk -F: '{print $1}' > ${TMP_DIR}/${PACKAGE}/ip

  # restart apache
  /usr/syno/etc.defaults/rc.d/S97apache-user.sh restart > /dev/null

  exit 0
}

postupgrade ()
{
  installer_log "-- postupgrade ${TMP_DIR}/${PACKAGE}"
  # Restore some stuff

  installer_log "restore configuration"
  mv -f ${TMP_DIR}/${PACKAGE}/*.cfg ${INSTALL_DIR}/share/PlexConnect/

  # restore certificates
  if [ -f ${TMP_DIR}/${PACKAGE}/certificates/trailers.cer ]; then
    installer_log "restore certificates"
    mv -f ${TMP_DIR}/${PACKAGE}/certificates/* ${INSTALL_DIR}/etc/certificates/
  fi

  # restore ip address
  MYIP=`cat ${TMP_DIR}/${PACKAGE}/ip`
  if [ "${MYIP}" != "" ]; then
    installer_log "restoring IP ${MYIP}"
    sed -i -e "s|127.0.0.1|$MYIP|g" ${VHOST_FILE}
  fi

  rm -fr ${TMP_DIR}/${PACKAGE}

  # Correct the files ownership
  chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

  exit 0
}
