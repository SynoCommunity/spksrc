#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="transmission"
DNAME="Transmission"
TR_UTILS="transmission-cli transmission-create transmission-edit \
          transmission-remote transmission-show" 

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
VAR_DIR="/usr/local/var/${PACKAGE}"
UPGRADE="/tmp/${PACKAGE}.upgrade"
PATH="${INSTALL_DIR}/bin:/bin:/usr/bin:/usr/syno/sbin" # Avoid ipkg commands

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
    if synouser --enum local | grep "^${PACKAGE}$" >/dev/null
    then
    	# Keep the existing uid
        uid=`grep ${PACKAGE} /etc/passwd | cut -d: -f3`
        synouser --del ${PACKAGE} 2> /dev/null
        UID_PARAM="-u ${uid}"
    fi

    # Extract the files to the installation directory
    ${SYNOPKG_PKGDEST}/sbin/xzdec -c ${SYNOPKG_PKGDEST}/package.txz | \
        tar xpf - -C ${INSTALL_DIR}
    # Remove the installer archive to save space
    rm ${SYNOPKG_PKGDEST}/package.txz

    # Create symlinks to utils
    for exe in ${TR_UTILS}
    do
      ln -s ${INSTALL_DIR}/bin/${exe} /usr/local/bin/${exe}
    done
    ln -s /var/packages/${PACKAGE}/scripts/start-stop-status /usr/local/bin/${PACKAGE}-ctl 

    # Install the application in the main interface.
    if [ -d ${SYNO3APP} ]
    then
        rm -f ${SYNO3APP}/${PACKAGE}
        ln -s ${INSTALL_DIR}/share/synoman ${SYNO3APP}/${PACKAGE}
    fi

    # Copy the default configuration if needed
    if [ -f ${VAR_DIR}/settings.json ]
    then
        true
    else
        # No config file, copy default one
        cp ${SYNOPKG_PKGDEST}/var/settings.json ${VAR_DIR}/settings.json
    fi

    # Update the configuration file
    ${INSTALL_DIR}/bin/transmission-daemon -g ${VAR_DIR}/ -d 2> ${VAR_DIR}/new.settings.json 
    mv ${VAR_DIR}/new.settings.json ${VAR_DIR}/settings.json
    chmod 600 ${VAR_DIR}/settings.json

    # Install the adduser and deluser hardlinks
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
    for exe in ${TR_UTILS}
    do
      rm /usr/local/bin/${exe}
    done
    rm /usr/local/bin/${PACKAGE}-ctl 

    # Remove the installation directory
    rm -fr ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    # Make sure the package is not running while we are upgrading it
    /usr/local/bin/${PACKAGE}-ctl stop
    touch ${UPGRADE}

    # Make sure the work dir exists
    mkdir -p ${VAR_DIR}
    # Save current state before upgrade
    if [ -d ${SYNOPKG_PKGDEST}/usr ]
    then
        # First installation scheme, copy to new
        mv ${SYNOPKG_PKGDEST}/usr/local/var/lib/transmission-daemon/* ${VAR_DIR}/
    else
        if [ -d ${SYNOPKG_PKGDEST}/var ]
        then
            # Second installation scheme, copy to new
            mv ${SYNOPKG_PKGDEST}/var/* ${VAR_DIR}/
        fi
    fi
    exit 0
}

postupgrade ()
{
    # Correct permission and ownership of download directory
    downloadDir=`grep download-dir ${VAR_DIR}/settings.json | cut -d'"' -f4`
    if [ -n "${downloadDir}" -a -d "${downloadDir}" ]
    then
        chown -Rh transmission:users ${downloadDir}
        chmod -R g+w ${downloadDir}
    fi

    # Correct permission and ownership of incomplete directory
    incompleteDir=`grep incomplete-dir ${VAR_DIR}/settings.json | cut -d'"' -f4`
    if [ -n "${incompleteDir}" -a -d "${incompleteDir}" ]
    then
        chown -Rh transmission:users ${incompleteDir}
    fi

    rm -f ${UPGRADE}

    exit 0
}
