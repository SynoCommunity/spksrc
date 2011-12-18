#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="hastation"
DNAME="H.A. Station"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
VAR_DIR="/usr/local/var/${PACKAGE}"
UPGRADE="/tmp/${PACKAGE}.upgrade"
PATH="${INSTALL_DIR}/bin:/bin:/usr/bin" # Avoid ipkg commands

SYNO3APP="/usr/syno/synoman/webman/3rdparty"

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
    mkdir -p ${VAR_DIR}/run

    # Link folders
    for dir in ${SYNOPKG_PKGDEST}/*; do
        ln -s ${SYNOPKG_PKGDEST}/`basename ${dir}` ${INSTALL_DIR}/`basename ${dir}`
    done

    exit 0
}

preuninst ()
{
    for ctl in ${VAR_DIR}/run/*-ctl
    do
        ${ctl} stop
    done
    
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
    exit 0
}

postupgrade ()
{
    exit 0
}
