#!/bin/sh

# Package
PACKAGE="detox"
DNAME="Detox"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    
    # Put mc in the PATH
    mkdir -p /usr/local/bin
    mkdir -p /usr/local/usr/share/detox
    mkdir -p /usr/local/usr/share/man/man1
    mkdir -p /usr/local/usr/share/man/man5
    
    ln -s /usr/local/detox/bin/detox /usr/local/bin/detox
    ln -s /usr/local/detox/etc/detoxrc /usr/local/etc/detoxrc
    ln -s /usr/local/detox/share/detox/iso88591.tbl /usr/local/usr/share/detox/iso88591.tbl
    ln -s /usr/local/detox/share/detox/unicode.tbl /usr/local/usr/share/detox/unicode.tbl
    ln -s /usr/local/detox/share/man/man1/detox.1 /usr/local/usr/share/man/man1/detox.1
    ln -s /usr/local/detox/share/man/man5/detox.tbl.5 /usr/local/usr/share/man/man5/detox.tbl.5
    ln -s /usr/local/detox/share/man/man5/detoxrc.5 /usr/local/usr/share/man/man5/detoxrc.5
    ln -s /usr/local/detox/etc/detoxrc /usr/local/etc/detoxrc
    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove link
    rm -rf ${INSTALL_DIR}
    rm -rf /usr/local/bin/detox
    rm -rf /usr/local/etc/detox*
    rm -rf /usr/local/share/detox
    rm -rf /usr/local/share/man/man1/detox*
    rm -rf /usr/local/share/man/man5/detox*
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
