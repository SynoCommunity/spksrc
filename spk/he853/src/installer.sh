#!/bin/sh

# Package
PACKAGE="he853"
DNAME="HomeEasy HE853 USB device executable"
UDEVRULE="80-${PACKAGE}.rules"

# Others
LOCALBASE="/usr/local/"
LOCALBIN="${LOCALBASE}bin/"
INSTALL_DIR="${LOCALBASE}${PACKAGE}/"
UDEVBASE="/lib/udev/rules.d/"

preinst ()
{
    exit 0
}

postinst ()
{
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    mkdir -p ${LOCALBIN}
    ln -s ${INSTALL_DIR}/bin/${PACKAGE} ${LOCALBIN}

    ln -s ${INSTALL_DIR}${UDEVBASE}${UDEVRULE} ${UDEVBASE}

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    rm -f ${UDEVBASE}${UDEVRULE}

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
