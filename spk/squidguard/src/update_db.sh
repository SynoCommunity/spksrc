#!/bin/sh

# Package
PACKAGE="squidguard"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="squid"
DB_DIR="${INSTALL_DIR}/var/db"
DB_FILE="ftp://ftp.univ-tlse1.fr/pub/reseau/cache/squidguard_contrib/blacklists.tar.gz"

cd ${DB_DIR}
wget ${DB_FILE}
tar xvzf blacklists.tar.gz -C ${DB_DIR}
if [ $? -eq 0 ]
then
  mv ${DB_DIR}/blacklists/* ${DB_DIR}
  rm blacklists.tar.gz
  rmdir blacklists
  chown -R ${RUNAS}:root ${DB_DIR}
  ${INSTALL_DIR}/bin/squidGuard -c ${INSTALL_DIR}/etc/squidguard.conf -C all
fi
