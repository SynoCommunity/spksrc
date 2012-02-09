#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="mpd"
DNAME="Music Player Daemon"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
GEN_CERT="${INSTALL_DIR}/sbin/gencert.sh"
UPGRADE="/tmp/${PACKAGE}.upgrade"
PATH="${INSTALL_DIR}/bin:/bin:/usr/bin" # Avoid ipkg commands

#########################################
# DSM package manager functions


preinst ()
{
    exit 0
}

postinst ()
{
    # Create the view directory
    mkdir -p ${INSTALL_DIR}
    mkdir -p /usr/local/bin

    # Link folders
    for dir in ${SYNOPKG_PKGDEST}/*; do
        ln -s ${SYNOPKG_PKGDEST}/`basename ${dir}` ${INSTALL_DIR}/`basename ${dir}`
    done

    # Create a link in /usr/local/bin
    ln -s /var/packages/${PACKAGE}/scripts/start-stop-status /usr/local/bin/${PACKAGE}-ctl

    # Correct the files ownership
    chown -R root:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove symlinks to utils
    rm /usr/local/bin/${PACKAGE}-ctl

    # Remove the installation directory
    rm -fr ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    # Save some stuff
    rm -fr /tmp/${PACKAGE}
    mkdir /tmp/${PACKAGE}
    mkdir /tmp/${PACKAGE}/etc
    cp ${INSTALL_DIR}/etc/mpd.conf /tmp/${PACKAGE}/etc/
    mkdir /tmp/${PACKAGE}/var
    cp -r ${INSTALL_DIR}/var/* /tmp/${PACKAGE}/var/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    for dir in etc var; do
        cp -r /tmp/${PACKAGE}/${dir}/* ${INSTALL_DIR}/${dir}/
    done
    rm -fr /tmp/mpd

    exit 0
}
