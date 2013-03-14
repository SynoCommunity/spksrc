#!/bin/sh

# Package
PACKAGE="newznab"
DNAME="Newznab"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install the web interface
    cp -R ${INSTALL_DIR}/share/newznab ${WEB_DIR}

    # Fix permissions
    chmod 777 ${WEB_DIR}/newznab/www/lib/smarty/templates_c
    chmod 777 ${WEB_DIR}/newznab/www/covers/movies
    chmod 777 ${WEB_DIR}/newznab/www/covers/music
    chmod 777 ${WEB_DIR}/newznab/www
    chmod 777 ${WEB_DIR}/newznab/www/install
    chmod 777 ${WEB_DIR}/newznab/nzbfiles

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
    rm -fr ${WEB_DIR}/newznab

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
