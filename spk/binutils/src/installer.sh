#!/bin/sh

# Package
PACKAGE="binutils"
DNAME="GNU binutils"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    
    # Put it in the PATH
    mkdir -p /usr/local/bin
    for app in `ls ${SYNOPKG_PKGDEST}/bin` ; do
        ln -s ${INSTALL_DIR}/bin/$app /usr/local/bin/$app
    done

    exit 0
}

preuninst ()
{
    # Remove links
    for app in `ls ${SYNOPKG_PKGDEST}/bin` ; do
        rm -f /usr/local/bin/$app
    done
 
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
