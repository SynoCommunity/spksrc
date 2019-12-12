#!/bin/sh

# Package
PACKAGE="postgresql"
DNAME="PostegreSQL"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
DAEMON_USER="`echo ${SYNOPKG_PKGNAME} | awk {'print tolower($_)'}`"
DAEMON_ID="${SYNOPKG_PKGNAME} daemon user"
DAEMON_PASS="`openssl rand 12 -base64 2>/dev/null`"


preinst ()
{
    exit 0
}

postinst ()
{
  # Link
  ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

  # create daemon user
  synouser --add ${DAEMON_USER} ${DAEMON_PASS} "${DAEMON_ID}" 0 "" ""

  # determine the daemon user homedir and save that variable in the user's profile
  # this is needed because new users seem to inherit a HOME value of /root which they have no permissions for
  DAEMON_HOME="`cat /etc/passwd | grep "${DAEMON_ID}" | cut -f6 -d':'`"
  su - ${DAEMON_USER} -s /bin/sh -c "echo export HOME=\'${DAEMON_HOME}\' >> .profile"

  # change owner of folder tree
  chown -R ${DAEMON_USER}:users ${SYNOPKG_PKGDEST}

  su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/initdb -D ${SYNOPKG_PKGDEST}/var/data"

  # change default port to 5433 in order to avoid conflict with existing postgres 9
  su - ${DAEMON_USER} -s /bin/sh -c "sed -i -e 's/#port = 5432/port=5433/g' ${SYNOPKG_PKGDEST}/var/data/postgresql.conf"

  su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${SYNOPKG_PKGDEST}/var/data -l ${SYNOPKG_PKGDEST}/var/logfile start"

  # create role in order to have a customized user/password
  su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/psql -p 5433 -d postgres -c \"CREATE ROLE ${wizard_pg_username:=pgadmin} PASSWORD '${wizard_pg_password:=changepassword}' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN; \""

  su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${SYNOPKG_PKGDEST}/var/data stop"

  exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
  # Remove link
  rm -f ${INSTALL_DIR}

  #remove daemon user
  synouser --del ${DAEMON_USER}

  #remove daemon user's home directory (needed since DSM 4.1)
  [ -e /var/services/homes/${DAEMON_USER} ] && rm -r /var/services/homes/${DAEMON_USER}

  exit 0
}

preupgrade ()
{
    exit 0
}

postupgrade ()
{
    exit 0
}
