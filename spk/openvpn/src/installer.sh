#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="openvpn"
DNAME="OpenVPN 2.2.1"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
VAR_DIR="/usr/local/var/${PACKAGE}"
UPGRADELOCK="/tmp/${PACKAGE}.upgrade.lock"
PATH="${INSTALL_DIR}/bin:/bin:/usr/bin" # Avoid ipkg commands

#########################################
# DSM package manager functions

preinst ()
{
    exit 0
}

postinst ()
{
    # Installation directories
    mkdir -p ${INSTALL_DIR}
    mkdir -p ${INSTALL_DIR}/bin
    mkdir -p ${VAR_DIR}

    # Create symlink
    ln -s ${SYNOPKG_PKGDEST}/bin/openvpn ${INSTALL_DIR}/bin/openvpn
    ln -s ${SYNOPKG_PKGDEST}/lib ${INSTALL_DIR}/lib
    ln -s ${SYNOPKG_PKGDEST}/keys ${INSTALL_DIR}/keys
    ln -s ${SYNOPKG_PKGDEST}/var/client.conf ${VAR_DIR}/client.conf
    ln -s ${SYNOPKG_PKGDEST}/var/server.conf ${VAR_DIR}/server.conf
    
    # Correct the files ownership (need to be change in a future release by a dedicated user)
    chown -R root:root ${SYNOPKG_PKGDEST}

    # Correct the files permission
    chmod 755 ${SYNOPKG_PKGDEST}/bin/*
    chmod 666 ${SYNOPKG_PKGDEST}/var/*.conf

    exit 0
}

preuninst ()
{
    
    exit 0
}

postuninst ()
{
    # Remove the installation directory
    rm -fr ${INSTALL_DIR}
    rm -fr ${VAR_DIR}

    exit 0
}

preupgrade ()
{
    touch $UPGRADELOCK
    exit 0
}

postupgrade ()
{
    rm -f $UPGRADELOCK
    exit 0
}
