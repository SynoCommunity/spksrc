#!/bin/sh

# Package
PACKAGE="zstd"
DNAME="Zstandard"

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
    
    # Put zstd in the PATH
    mkdir -p /usr/local/bin

    ln -s ${INSTALL_DIR}/bin/unzstd /usr/local/bin/unzstd
    ln -s ${INSTALL_DIR}/bin/zstd /usr/local/bin/zstd
    ln -s ${INSTALL_DIR}/bin/zstdcat /usr/local/bin/zstdcat
    ln -s ${INSTALL_DIR}/bin/zstdgrep /usr/local/bin/zstdgrep
    ln -s ${INSTALL_DIR}/bin/zstdless /usr/local/bin/zstdless
    ln -s ${INSTALL_DIR}/bin/zstdmt /usr/local/bin/zstdmt
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

    rm -f /usr/local/bin/unzstd
    rm -f /usr/local/bin/zstd
    rm -f /usr/local/bin/zstdcat
    rm -f /usr/local/bin/zstdgrep
    rm -f /usr/local/bin/zstdless
    rm -f /usr/local/bin/zstdmt
    exit 0
}

