#!/bin/sh

# Package
PACKAGE="safekeep"
DNAME="SafeKeep"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    ln -s ${INSTALL_DIR}/bin/safekeep /usr/local/bin/safekeep
    ln -s ${INSTALL_DIR}/etc/safekeep /etc/safekeep
    ln -s ${INSTALL_DIR}/etc/cron.d/safekeep /etc/cron.d/safekeep

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
    rm -f /usr/local/bin/safekeep
    rm -f /etc/safekeep
    rm -f /etc/cron.d/safekeep

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
