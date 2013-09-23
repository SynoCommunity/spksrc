#!/bin/sh

# Package
PACKAGE="HelloWorld"

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

    # Put binary in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/helloworld /usr/local/bin/helloworld
    ln -s ${INSTALL_DIR}/bin/helloworld-static /usr/local/bin/helloworld-static

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
    rm -f /usr/local/bin/helloworld
    rm -f /usr/local/bin/helloworld-static

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
