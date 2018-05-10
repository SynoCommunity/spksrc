#!/bin/sh

# Package
PACKAGE="dkb-trace"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"

preinst ()
{
    
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Edit the configuration according to the wizard
    sed -i -e "s/@username@/${wizard_username:=admin}/g" ${INSTALL_DIR}/share/dkb-trace/web/config.php
    sed -i -e "s/@password@/${wizard_password:=admin}/g" ${INSTALL_DIR}/share/dkb-trace/web/config.php

    # Web directory
    cp -R ${INSTALL_DIR}/share/dkb-trace/web/ /var/services/web/${PACKAGE}/

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Link
    rm -f ${INSTALL_DIR}

    # Web directory
    rm -rf /var/services/web/${PACKAGE}/

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
