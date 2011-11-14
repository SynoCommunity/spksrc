#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="sabnzbd"
DNAME="SABnzbd+"
PYTHON_DIR="/usr/local/python27"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
UPGRADE="/tmp/${PACKAGE}.upgrade"
PATH="${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin" # Avoid ipkg commands

SYNOUSER="/usr/syno/sbin/synouser"

SYNO3APP="/usr/syno/synoman/webman/3rdparty"

#########################################
# DSM package manager functions

preinst ()
{
    exit 0
}

postinst ()
{
    # Installation directories
    mkdir -p ${INSTALL_DIR}
    mkdir -p /usr/local/bin

    # Link folders
    for dir in ${SYNOPKG_PKGDEST}/*; do
        ln -s ${SYNOPKG_PKGDEST}/`basename ${dir}` ${INSTALL_DIR}/`basename ${dir}`
    done

    # Create a link in /usr/local/bin
    ln -s /var/packages/SABnzbd/scripts/start-stop-status /usr/local/bin/${PACKAGE}-ctl

    # Install the application in the main interface
    if [ -d ${SYNO3APP} ]; then
        rm -f ${SYNO3APP}/${PACKAGE}
        ln -s ${SYNOPKG_PKGDEST}/share/synoman ${SYNO3APP}/${PACKAGE}
    fi

    # Restore the config file if we're upgrading, use default otherwise
    if [ -f ${UPGRADE} ]; then
        mv /tmp/config.ini ${INSTALL_DIR}/
    else
        cp ${SYNOPKG_PKGDEST}/etc/config.ini ${INSTALL_DIR}/config.ini
    fi

    # Ensure that only the sabnzbd user can access this file, as some password are stored in clear text
    chmod 600 ${INSTALL_DIR}/config.ini

    # Install the nice and ionice hardlinks
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create the service user if needed
    if ! grep "^${PACKAGE}:" /etc/passwd >/dev/null; then
        adduser -h ${INSTALL_DIR} -g "${DNAME} User" -G users -D -H ${UID_PARAM} -s /bin/sh ${PACKAGE}
    fi

    # Correct the files ownership
    chown -Rh ${PACKAGE}:users ${INSTALL_DIR}

    exit 0
}

preuninst ()
{
    # Make sure the package is not running while we are removing it
    /usr/local/bin/${PACKAGE}-ctl stop

    exit 0
}

postuninst ()
{
    # Save the config file and the user if we're upgrading, delete the user otherwise
    if [ -f ${UPGRADE} ]; then
        cp ${INSTALL_DIR}/config.ini /tmp/
    else
        deluser ${PACKAGE}
    fi

    # Remove the application from the main interface if it was previously added
    if [ -h ${SYNO3APP}/${PACKAGE} ]; then
        rm ${SYNO3APP}/${PACKAGE}
    fi

    # Remove symlinks to utils
    rm /usr/local/bin/${PACKAGE}-ctl

    # Remove the installation directory
    rm -fr ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    touch ${UPGRADE}

    exit 0
}

postupgrade ()
{
    rm -f ${UPGRADE}

    exit 0
}
