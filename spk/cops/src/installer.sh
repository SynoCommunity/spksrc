#!/bin/sh

# Package
PACKAGE="cops"
DNAME="COPS"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
DEFAULT_CFG_FILE="/usr/local/${PACKAGE}/config_local.php.synology"
WEB_DIR="/var/services/web"
CFG_FILE="${WEB_DIR}/${PACKAGE}/config_local.php"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install the web interface
    cp -R ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR}

    # Create a default configuration file
    if [ ! -f ${CFG_FILE} ]; then
      cp ${DEFAULT_CFG_FILE} ${CFG_FILE}
      sed -i -e "s|@calibre_dir@|${wizard_calibre_dir:=/volume1/calibre/}|g" ${CFG_FILE}
      sed -i -e "s|@cops_title@|${wizard_cops_title:=COPS}|g" ${CFG_FILE}
      sed -i -e "s|@use_url_rewriting@|${wizard_use_url_rewriting:=0}|g" ${CFG_FILE}
      chmod ga+w ${CFG_FILE}
    fi

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

    # Remove the web interface
    rm -fr ${WEB_DIR}/${PACKAGE}

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
