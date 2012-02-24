#!/bin/sh

# Package
PACKAGE="hastation"
DNAME="H.A. Station"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="root"
PIP="${INSTALL_DIR}/bin/pip"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install the bundle
    ${PIP} install -b ${INSTALL_DIR}/var/build -U ${INSTALL_DIR}/share/Dobby/requirements.pybundle > /dev/null
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
    exit 0
}

postupgrade ()
{
    exit 0
}
