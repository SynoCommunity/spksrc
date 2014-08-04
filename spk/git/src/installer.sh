#!/bin/sh

# Package
PACKAGE="git"
DNAME="Git"

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

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Set the permissions
    chown -hR root:root ${SYNOPKG_PKGDEST}
    chmod -R go-w ${SYNOPKG_PKGDEST}

    # Put symlinks in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/git /usr/local/bin/git
    ln -s ${INSTALL_DIR}/bin/git-receive-pack /usr/local/bin/git-receive-pack
    ln -s ${INSTALL_DIR}/bin/git-shell /usr/local/bin/git-shell
    ln -s ${INSTALL_DIR}/bin/git-upload-archive /usr/local/bin/git-upload-archive
    ln -s ${INSTALL_DIR}/bin/git-upload-pack /usr/local/bin/git-upload-pack

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
    rm -f /usr/local/bin/git
    rm -f /usr/local/bin/git-receive-pack
    rm -f /usr/local/bin/git-shell
    rm -f /usr/local/bin/git-upload-archive
    rm -f /usr/local/bin/git-upload-pack

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
