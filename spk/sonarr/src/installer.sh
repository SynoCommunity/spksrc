#!/bin/sh

# Package
PACKAGE="sonarr"
DNAME="Sonarr"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
INSTALL_LOG="${INSTALL_DIR}/var/install.log"
TMP_INSTALL_LOG="${TMP_DIR}/${PACKAGE}/var/install.log"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="${PACKAGE}"
GROUP="users"
PID_FILE="${INSTALL_DIR}/var/.config/NzbDrone/nzbdrone.pid"
MONO_PATH="/usr/local/mono/bin"
MONO="${MONO_PATH}/mono"
SONARR="${INSTALL_DIR}/share/NzbDrone/NzbDrone.exe"
SPK_SONARR="${SYNOPKG_PKGINST_TEMP_DIR}/share/NzbDrone/NzbDrone.exe"
COMMAND="env PATH=${MONO_PATH}:${PATH} LD_LIBRARY_PATH=${INSTALL_DIR}/lib ${MONO}"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Logging Install
    mkdir -p ${INSTALL_DIR}/var
    echo "|| Installing package $(grep "version" /var/packages/${PACKAGE}/INFO) - $(date) ||" >> ${INSTALL_LOG}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    # Log
    echo "|| Package Install Completed - $(date) ||" >> ${INSTALL_LOG}

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    # Remove firewall config
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
    fi

    exit 0
}

postuninst ()
{
    # Remove Link
    rm -f ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    # Log Upgrade
    echo "|| Beginning Package Upgrade - $(date) ||" >> ${INSTALL_LOG}

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/

    # Is Installed Sonarr Binary Ver. >= SPK Sonarr Binary Ver.?
    CUR_VER=$(${COMMAND} ${SONARR} --? | grep -o "Version.*" | awk '{print $2;exit;}' | tr -d '.')
    echo "   Installed Sonarr Binary: ${CUR_VER}" >> ${TMP_INSTALL_LOG}
    SPK_VER=$(${COMMAND} ${SPK_SONARR} --? | grep -o "Version.*" | awk '{print $2;exit;}' | tr -d '.')
    echo "   Requested Sonarr Binary: ${SPK_VER}" >> ${TMP_INSTALL_LOG}
    if [ "$CUR_VER" -ge "$SPK_VER" ]; then
       echo 'KEEP_CUR="yes"' > ${TMP_DIR}/${PACKAGE}/var/KEEP_VAR
       echo "   [KEEPING] Installed Sonarr Binary - Upgrading Package Only" >> ${TMP_INSTALL_LOG}
       mv ${INSTALL_DIR}/share ${TMP_DIR}/${PACKAGE}/
    else
       echo 'KEEP_CUR="no"' > ${TMP_DIR}/${PACKAGE}/var/KEEP_VAR
       echo "   [REPLACING] Installed Sonarr Binary" >> ${TMP_INSTALL_LOG}
    fi

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/

    # Restore Current Sonarr Binary If Current Ver. >= SPK Ver.
    . ${INSTALL_DIR}/var/KEEP_VAR
    if [ "$KEEP_CUR" == "yes" ]; then
       rm -fr ${INSTALL_DIR}/share
       mv ${TMP_DIR}/${PACKAGE}/share ${INSTALL_DIR}/
    fi

    # Remove Backups & Upgrade Flag
    rm -fr ${TMP_DIR}/${PACKAGE}
    rm ${INSTALL_DIR}/var/KEEP_VAR

    # Finish Logging
    echo "|| Package upgraded to $(grep "version" /var/packages/${PACKAGE}/INFO) - $(date) ||" >> ${INSTALL_LOG}

    exit 0
}
