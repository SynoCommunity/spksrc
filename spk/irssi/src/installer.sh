#!/bin/sh

# Package
PACKAGE="irssi"
DNAME="Irssi"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Put irssi in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/irssi /usr/local/bin/irssi

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
    rm -f /usr/local/bin/irssi

    exit 0
}

preupgrade ()
{
    # Save configuration
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/etc/irssi.conf ${TMP_DIR}/${PACKAGE}/irssi.conf

    exit 0
}

postupgrade ()
{
    # Restore configuration
    mv ${TMP_DIR}/${PACKAGE}/irssi.conf ${INSTALL_DIR}/etc/irssi.conf
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
