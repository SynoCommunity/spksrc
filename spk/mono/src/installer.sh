#!/bin/sh

# Package
PACKAGE="mono"
DNAME="Mono"

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

    # Sync certificate
    /var/packages/mono/target/bin/cert-sync /etc/ssl/certs/ca-certificates.crt > /dev/null

    exit 0
}

preuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    exit 0
}

postuninst ()
{
    exit 0
}

preupgrade ()
{
    exit 0
}

postupgrade ()
{
    # Sync certificate
    /var/packages/mono/target/bin/cert-sync /etc/ssl/certs/ca-certificates.crt > /dev/null

    exit 0
}
