#!/bin/sh

# Package
PACKAGE="he853"
DNAME="HomeEasy HE853 USB device executable"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"


preinst ()
{
    exit 0
}

postinst ()
{
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/${PACKAGE} /usr/local/bin/${PACKAGE}
    ln -s ${INSTALL_DIR}/lib/udev/rules.d/80-he853.rules /lib/udev/rules.d/

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    rm -f ${INSTALL_DIR}
    rm -f /usr/local/bin/${PACKAGE}
    rm -f /lib/udev/rules.d/80-he853.rules

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
