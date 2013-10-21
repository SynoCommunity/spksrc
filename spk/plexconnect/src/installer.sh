#!/bin/sh

# Package
PACKAGE="plexconnect"
DNAME="PlexConnect"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
CFG_FILE="share/PlexConnect/Settings.cfg"
ATV_CFG_FILE="share/PlexConnect/ATVSettings.cfg"
PATH="${INSTALL_DIR}/sbin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="${PACKAGE}"
PYTHON="${PYTHON_DIR}/bin/python"
APACHE_DIR="/usr/syno/apache"
HTTPD_CONF_USER="${APACHE_DIR}/conf/httpd.conf-user"
VHOST_FILE="${APACHE_DIR}/conf/extra/plexconnect-vhosts.conf"
## not in use yet
#HTTPD_SSL_CONF_USER="${APACHE_DIR}/conf/extra/httpd-ssl.conf-user"
#VHOST_SSL_FILE="${APACHE_DIR}/conf/extra/plexconnect-ssl-vhosts.conf"

preinst ()
{
    exit 0
}

postinst ()
{
  # Link
  ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
  MYIP=`/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`

  # Create user
  adduser -h ${INSTALL_DIR} -g "${DNAME} User" -G users -s /bin/sh -S -D ${PACKAGE}

  # Create the certificates
  #openssl req -new -nodes -newkey rsa:2048 -out "${INSTALL_DIR}/etc/certificates/trailers.pem" -keyout "${INSTALL_DIR}/etc/certificates/trailers.key" -x509 -days 7300 -subj "/C=US/CN=trailers.apple.com"
  #openssl x509 -in "${INSTALL_DIR}/etc/certificates/trailers.pem" -outform der -out "${INSTALL_DIR}/etc/certificates/trailers.cer" && cat "${INSTALL_DIR}/etc/certificates/trailers.key" >> "${INSTALL_DIR}/etc/certificates/trailers.pem"

  # Edit the configuration according to the wizard
  sed -i -e "s|8.8.8.8|${wizard_dns_server}|g" ${INSTALL_DIR}/${CFG_FILE}
  #sed -i -e "s|ip_pms = 0.0.0.0|ip_pms = $MYIP|g" ${INSTALL_DIR}/${CFG_FILE}

  #add VHOST_FILE
  cp -f ${INSTALL_DIR}/app/plexconnect-vhosts.conf ${VHOST_FILE}
  sed -i -e "s|127.0.0.1|$MYIP|g" ${VHOST_FILE}
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
  # Remove the user (if not upgrading)
  if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
    deluser ${PACKAGE}
  fi

  exit 0
}

postuninst ()
{
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
  rm -fr ${TMP_DIR}/${PACKAGE}
  mkdir -p ${TMP_DIR}/${PACKAGE}

  # Save post upgrade configuration files
  mv ${INSTALL_DIR}/share/PlexConnect/*.cfg ${TMP_DIR}/${PACKAGE}/

  # backup certificates
  if [ -f ${INSTALL_DIR}/etc/certificates/trailers.cer ]
    then
      mkdir -p ${TMP_DIR}/${PACKAGE}/certificates
      mv ${INSTALL_DIR}/etc/certificates/* ${TMP_DIR}/${PACKAGE}/certificates
  fi

  exit 0

}
postupgrade ()
{
  # Restore some stuff

  mv -f ${TMP_DIR}/${PACKAGE}/*.cfg ${INSTALL_DIR}/share/PlexConnect/

  # restore certificates
  if [ -f ${TMP_DIR}/${PACKAGE}/certificates/trailers.cer ]
    then
      mv -f ${TMP_DIR}/${PACKAGE}/certificates/* ${INSTALL_DIR}/etc/certificates/
  fi

  rm -fr ${TMP_DIR}/${PACKAGE}

  # Correct the files ownership
  chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

  exit 0
}