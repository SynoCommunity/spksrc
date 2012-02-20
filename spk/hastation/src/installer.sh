#!/bin/sh

# Package
PACKAGE="hastation"
DNAME="H.A. Station"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="root"
PIP="${INSTALL_DIR}/bin/pip"
UPGRADE="/tmp/${PACKAGE}.upgrade"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install the bundle
    ${PIP} install -b ${INSTALL_DIR}/var/build -U ${INSTALL_DIR}/share/Dobby/requirements.pybundle
    rm -fr ${INSTALL_DIR}/var/build

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

    exit 0
}

preupgrade ()
{
    # Create the upgrade flag
    touch ${UPGRADE}

    exit 0
}

postupgrade ()
{
    # Remove the upgrade flag
    rm  ${UPGRADE}

    exit 0
}
