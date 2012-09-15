#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="pyLoad"
DNAME="pyLoad"
PYTHON_DIR="/usr/local/python26"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
VAR_DIR="/usr/local/var/${PACKAGE}"
UPGRADE="/tmp/${PACKAGE}.upgrade"
PATH="${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin" # Avoid ipkg commands

SYNO3APP="/usr/syno/synoman/webman/3rdparty"

# Quote the wizard variables
echo $pyLoadUser > $$
pyLoadUser=`sed 's/"/\\"/gp' $$`
echo $pyLoadPasswd > $$
pyLoadPasswd=`sed 's/"/\\"/gp' $$`
echo $pyLoadPasswd2 > $$
pyLoadPasswd2=`sed 's/"/\\"/gp' $$`
/bin/rm -f $$

#########################################
# DSM package manager functions

preinst ()
{
    checkPassword ||exit 1
    exit 0
}

postinst ()
{
    # Installation directories
    mkdir -p ${INSTALL_DIR}
    mkdir -p ${VAR_DIR}
    mkdir -p /usr/local/bin


    # Extract the files to the installation directory
    ${PYTHON_DIR}/bin/xzdec -c ${SYNOPKG_PKGDEST}/package.txz | \
        tar xpf - -C ${INSTALL_DIR}
    # Remove the installer archive to save space
    rm ${SYNOPKG_PKGDEST}/package.txz

    ln -s /var/packages/${PACKAGE}/scripts/start-stop-status /usr/local/bin/${PACKAGE}-ctl

    # Install the application in the main interface.
    if [ -d ${SYNO3APP} ]
    then
        rm -f ${SYNO3APP}/${PACKAGE}
        ln -s ${INSTALL_DIR}/share/synoman ${SYNO3APP}/${PACKAGE}
    fi
    # Create the configuration file
    if [ -f ${VAR_DIR}/pyload.conf ]
    then
        true # Keep current settings
    else
        # Create the default config
        PATH=$PATH:${INSTALL_DIR}/bin ${INSTALL_DIR}/share/pyLoad/pyLoadCore.py \
            --configdir=${VAR_DIR} --autosetup "${pyLoadUser}" "${pyLoadPasswd}" >${VAR_DIR}/install.log
        echo "You can now log in pyLoad with previously entered username and password." >> ${SYNOPKG_TEMP_LOGFILE}
    fi

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
    touch $isUpgrade
    exit 0
}

postupgrade ()
{
    rm -f $isUpgrade

    exit 0
}

#########################################
# Local functions
checkPassword ()
{
  if [ "${pyLoadPasswd}" = "${pyLoadPasswd2}" ]
  then
      true
  else
        cat >> ${SYNOPKG_TEMP_LOGFILE} << EOM
The entered passwords don't match, please retry to install.
EOM
        return 1
  fi
 
  return 0
}
