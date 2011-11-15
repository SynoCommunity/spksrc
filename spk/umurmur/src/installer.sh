#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="umurmur"
DNAME="uMurmur"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
GEN_CERT="${INSTALL_DIR}/sbin/gencert.sh"
UPGRADE="/tmp/${PACKAGE}.upgrade"
PATH="${INSTALL_DIR}/bin:/bin:/usr/bin" # Avoid ipkg commands
LOG_FILE="${INSTALL_DIR}/var/umurmurd.log"

SYNO3APP="/usr/syno/synoman/webman/3rdparty"

#########################################
# DSM package manager functions


preinst ()
{
    exit 0
}

postinst ()
{
    # Correct the files ownership
    chown -R root:root ${SYNOPKG_PKGDEST}

    # Create the view directory
    mkdir -p ${INSTALL_DIR}
    mkdir -p /usr/local/bin

    # Link folders
    for dir in ${SYNOPKG_PKGDEST}/*; do
        ln -s ${SYNOPKG_PKGDEST}/`basename ${dir}` ${INSTALL_DIR}/`basename ${dir}`
    done

    # Create empty log file with full permissions (for nobody)
    touch ${LOG_FILE}
    chmod 777 ${LOG_FILE}

    # Create a link in /usr/local/bin
    ln -s /var/packages/umurmur/scripts/start-stop-status /usr/local/bin/${PACKAGE}-ctl

    # Install the application in the main interface
    if [ -d ${SYNO3APP} ]; then
        rm -f ${SYNO3APP}/${PACKAGE}
        ln -s ${SYNOPKG_PKGDEST}/share/synoman ${SYNO3APP}/${PACKAGE}
    fi

    # Restore the config file and certificate if we're upgrading
    if [ -f ${UPGRADE} ]; then
        mv /tmp/umurmur.conf ${INSTALL_DIR}/etc/
        mv /tmp/umurmur.crt ${INSTALL_DIR}/etc/
        mv /tmp/umurmur.key ${INSTALL_DIR}/etc/
    fi

    # Certificate generation
    ${GEN_CERT} > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        exit 1
    fi

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Save the config file and the user if we're upgrading, delete the user otherwise
    if [ -f ${UPGRADE} ]; then
        cp ${INSTALL_DIR}/etc/umurmur.conf /tmp/
        cp ${INSTALL_DIR}/etc/umurmur.key /tmp/
        cp ${INSTALL_DIR}/etc/umurmur.crt /tmp/
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
