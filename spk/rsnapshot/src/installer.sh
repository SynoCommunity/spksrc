#!/bin/sh

# Package
PACKAGE="rsnapshot"
DNAME="rsnapshot"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp/${PACKAGE}"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Add symlink
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/rsnapshot /usr/local/bin/rsnapshot
    ln -s ${INSTALL_DIR}/bin/rsnapshot-diff /usr/local/bin/rsnapshot-diff

    # Copy config file
    cp ${INSTALL_DIR}/etc/rsnapshot.conf.default ${INSTALL_DIR}/etc/rsnapshot.conf

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

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
    rm /usr/local/bin/rsnapshot
    rm /usr/local/bin/rsnapshot-diff

    exit 0
}

preupgrade ()
{
    # Save the current config file
    rm -rf ${TMP_DIR}
    mkdir -p ${TMP_DIR}
    cp ${INSTALL_DIR}/etc/rsnapshot.conf ${TMP_DIR}

    exit 0
}

postupgrade ()
{
    # Restore the config file
    cp -f ${TMP_DIR}/rsnapshot.conf ${INSTALL_DIR}/etc/rsnapshot.conf
    rm -rf ${TMP_DIR}

    # Upgrade config file to new version
    ${INSTALL_DIR}/bin/rsnapshot upgrade-config-file

    exit 0
}
