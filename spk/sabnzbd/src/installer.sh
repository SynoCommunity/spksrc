#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="sabnzbd"
DNAME="SABnzbd+"
PYTHON_DIR="/usr/local/python27"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
VAR_DIR="/usr/local/var/${PACKAGE}"
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
    mkdir -p ${VAR_DIR}
    mkdir -p /usr/local/bin

    # Remove the DSM user
    if ${SYNOUSER} --enum local | grep "^${PACKAGE}$" >/dev/null
    then
    	# Keep the existing uid
        uid=`grep ${PACKAGE} /etc/passwd | cut -d: -f3`
        ${SYNOUSER} --del ${PACKAGE} 2> /dev/null
        UID_PARAM="-u ${uid}"
    fi

    # Extract the files to the installation directory
    ${PYTHON_DIR}/bin/xzdec -c ${SYNOPKG_PKGDEST}/package.txz | \
        tar xpf - -C ${INSTALL_DIR}
    # Remove the installer archive to save space
    rm ${SYNOPKG_PKGDEST}/package.txz

    ln -s /var/packages/SABnzbd/scripts/start-stop-status /usr/local/bin/${PACKAGE}-ctl 

    # Install the application in the main interface.
    if [ -d ${SYNO3APP} ]
    then
        rm -f ${SYNO3APP}/${PACKAGE}
        ln -s ${INSTALL_DIR}/share/synoman ${SYNO3APP}/${PACKAGE}
    fi

    # Copy the default configuration if needed
    if [ -f ${VAR_DIR}/config.ini ]
    then
        true
    else
        # No config file, copy default one
        cp ${SYNOPKG_PKGDEST}/var/config.ini ${VAR_DIR}/config.ini
    fi

    # Ensure that only the sabnzbd user can access this file, as some
    # password are stored in clear text
    chmod 600 ${VAR_DIR}/config.ini

    # Install the nice and ionice hardlinks
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create the service user if needed
    if grep "^${PACKAGE}:" /etc/passwd >/dev/null
    then
        true
    else
        adduser -h ${VAR_DIR} -g "${DNAME} User" -G users -D -H ${UID_PARAM} -s /bin/sh ${PACKAGE}
    fi

    # Correct the files ownership    
    chown -Rh ${PACKAGE}:users ${INSTALL_DIR} ${VAR_DIR}

    exit 0
}

preuninst ()
{
    # Make sure the package is not running while we are removing it.
    /usr/local/bin/${PACKAGE}-ctl stop

    exit 0
}

postuninst ()
{
    # Keep the user data and settings during the upgrade
    if [ -f ${UPGRADE} ]
    then
        true 
    else
        deluser ${PACKAGE}
        rm -fr ${VAR_DIR}
    fi

    # Remove the application from the main interface if it was previously added.
    if [ -h ${SYNO3APP}/${PACKAGE} ]
    then
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
    # The package manager only check the version when installing, not upgrading. So do it here the old way.
    if [ -e ${PYTHON_DIR}/bin/adduser ]
    then
        touch ${UPGRADE}
    else
        echo "Please uppdate Python26 before updating this package"
        false
    fi

    exit $?
}

postupgrade ()
{
    rm -f ${UPGRADE}

    exit 0
}
