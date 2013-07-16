#!/bin/sh

# Package
PACKAGE="plexconnect"
DNAME="PlexConnect"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
CFG_FILE="Settings.cfg"
ATV_CFG_FILE="ATVSettings.cfg"
PATH="${INSTALL_DIR}/sbin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="${PACKAGE}"
PYTHON="${PYTHON_DIR}/bin/python"
PROG_PY="${INSTALL_DIR}/PlexConnect.py"
APACHE_DIR="/usr/syno/apache"
HTTPD_CONF_USER="${APACHE_DIR}/conf/httpd.conf-user"
VHOST_FILE="${APACHE_DIR}/conf/extra/plexconnect-vhosts.conf"

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

  # Edit the configuration according to the wizard
  sed -i -e "s|8.8.8.8|${wizard_dns_server}|g" ${INSTALL_DIR}/${CFG_FILE}
  sed -i -e "s|ip_pms = 0.0.0.0|ip_pms = $MYIP|g" ${INSTALL_DIR}/${CFG_FILE}

  #add VHOST_FILE
  cp -f ${INSTALL_DIR}/app/plexconnect-vhosts.conf ${VHOST_FILE}

  # make a copy of HTTPD_CONF_USER
  cp ${HTTPD_CONF_USER} ${HTTPD_CONF_USER}.bak
  # include our VHOST_FILE
  echo "Include ${VHOST_FILE}" >> ${HTTPD_CONF_USER}

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

  #remove plexconnect-vhosts.conf
  rm -fr ${VHOST_FILE}

  # restart apache
  /usr/syno/etc.defaults/rc.d/S97apache-user.sh restart > /dev/null

  exit 0
}

preupgrade ()
{
  # Save some stuff
  rm -fr ${TMP_DIR}/${PACKAGE}
  mkdir -p ${TMP_DIR}/${PACKAGE}
  if [ -f ${INSTALL_DIR}/${CFG_FILE} ]
  then
    mv ${INSTALL_DIR}/${CFG_FILE} ${TMP_DIR}/${PACKAGE}/
  fi
  if [ -f ${INSTALL_DIR}/${ATV_CFG_FILE} ]
  then
    mv ${INSTALL_DIR}/${ATV_CFG_FILE} ${TMP_DIR}/${PACKAGE}/
  fi

  exit 0

}
postupgrade ()
{
    # Restore some stuff

  if [ -f ${TMP_DIR}/${PACKAGE}/${CFG_FILE} ]
  then
    rm -fr ${INSTALL_DIR}/${CFG_FILE}
    mv ${TMP_DIR}/${PACKAGE}/${CFG_FILE} ${INSTALL_DIR}/
  fi
  if [ -f ${INSTALL_DIR}/${ATV_CFG_FILE} ]
  then
    rm -fr ${INSTALL_DIR}/${ATV_CFG_FILE}
  fi
  if [ -f ${TMP_DIR}/${PACKAGE}/${ATV_CFG_FILE}  ]
  then
    mv ${TMP_DIR}/${PACKAGE}/${ATV_CFG_FILE} ${INSTALL_DIR}/
  fi
  rm -fr ${TMP_DIR}/${PACKAGE}

  # Correct the files ownership
  chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

  exit 0
}