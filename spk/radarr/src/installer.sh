#!/bin/sh

# Package
PACKAGE="radarr"
DNAME="Radarr"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
MONO_PATH="/usr/local/mono/bin"
MONO="${MONO_PATH}/mono"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
SERVICETOOL="/usr/syno/bin/servicetool"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

RADARR="${INSTALL_DIR}/share/Radarr/Radarr.exe"
SPK_RADARR="${SYNOPKG_PKGINST_TEMP_DIR}/share/Radarr/Radarr.exe"
COMMAND="env PATH=${MONO_PATH}:${PATH} LD_LIBRARY_PATH=${INSTALL_DIR}/lib ${MONO}"
PID_FILE="${INSTALL_DIR}/.config/Radarr/nzbdrone.pid"
INSTALL_LOG="${INSTALL_DIR}/.config/install.log"
TMP_INSTALL_LOG="${TMP_DIR}/${PACKAGE}/.config/install.log"

DSM6_UPGRADE="${INSTALL_DIR}/.config/.dsm6_upgrade"
SC_USER="sc-radarr"
SC_GROUP="sc-media"
SC_GROUP_DESC="SynoCommunity's media related group"
LEGACY_USER="radarr"
LEGACY_GROUP="users"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


syno_group_create ()
{
    # Create syno group
    synogroup --add ${SC_GROUP} ${USER} > /dev/null
    # Set description of the syno group
    synogroup --descset ${SC_GROUP} "${SC_GROUP_DESC}"
    # Add user to syno group
    addgroup ${USER} ${SC_GROUP}
}

syno_group_remove ()
{
    # Remove user from syno group
    delgroup ${USER} ${SC_GROUP}
    # Check if syno group is empty
    if ! synogroup --get ${SC_GROUP} | grep -q "0:"; then
        # Remove syno group
        synogroup --del ${SC_GROUP} > /dev/null
    fi
}


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Logging Install
    mkdir -p ${INSTALL_DIR}/.config
    echo "|| Installing package $(grep "version" /var/packages/${PACKAGE}/INFO) - $(date) ||" >> ${INSTALL_LOG}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create legacy user
    if [ "${BUILDNUMBER}" -lt "7321" ]; then
        adduser -h ${INSTALL_DIR}/.config -g "${DNAME} User" -G ${LEGACY_GROUP} -s /bin/sh -S -D ${LEGACY_USER}
    fi

    syno_group_create

    # Move config.xml to .config
    mkdir -p ${INSTALL_DIR}/.config/Radarr
    mv ${INSTALL_DIR}/app/config.xml ${INSTALL_DIR}/.config/Radarr/config.xml

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

    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        # Remove the user (if not upgrading)
        syno_group_remove
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${USER}

        # Remove firewall configuration
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
    # Stop the package
    ${SSS} stop > /dev/null

    # DSM6 Upgrade handling
    if [ "${BUILDNUMBER}" -ge "7321" ] && [ ! -f ${DSM6_UPGRADE} ]; then
        echo "Deleting legacy user" > ${DSM6_UPGRADE}
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${LEGACY_USER}
    fi

    # Log Upgrade
    echo "|| Beginning Package Upgrade - $(date) ||" >> ${INSTALL_LOG}

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}

    # Check for legacy var folder and (if found) move contents to .config
    if [ -d "${INSTALL_DIR}/var" ]; then
    mv ${INSTALL_DIR}/var/.config ${TMP_DIR}/${PACKAGE}/
    mv ${INSTALL_DIR}/var/install.log ${TMP_INSTALL_LOG}
    echo "   [LEGACY] Found var Folder - Moving To .config" >> ${TMP_INSTALL_LOG}
    else
    mv ${INSTALL_DIR}/.config ${TMP_DIR}/${PACKAGE}/
    fi

    # Is Installed Radarr Binary Ver. >= SPK Radarr Binary Ver.?
    CUR_VER=$(${MONO_PATH}/monodis --assembly ${RADARR} | grep "Version:" | awk '{print $2}')
    echo "   Installed Radarr Binary: ${CUR_VER}" >> ${TMP_INSTALL_LOG}
    SPK_VER=$(${MONO_PATH}/monodis --assembly ${SPK_RADARR} | grep "Version:" | awk '{print $2}')
    echo "   Requested Radarr Binary: ${SPK_VER}" >> ${TMP_INSTALL_LOG}
    if [ "${CUR_VER//.}" -ge "${SPK_VER//.}" ]; then
       echo 'KEEP_CUR="yes"' > ${TMP_DIR}/${PACKAGE}/.config/KEEP_VAR
       echo "   [KEEPING] Installed Radarr Binary - Upgrading Package Only" >> ${TMP_INSTALL_LOG}
       mv ${INSTALL_DIR}/share ${TMP_DIR}/${PACKAGE}/
    else
       echo 'KEEP_CUR="no"' > ${TMP_DIR}/${PACKAGE}/.config/KEEP_VAR
       echo "   [REPLACING] Installed Radarr Binary" >> ${TMP_INSTALL_LOG}
    fi

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/.config
    mv ${TMP_DIR}/${PACKAGE}/.config ${INSTALL_DIR}/

    # Restore Current Radarr Binary If Current Ver. >= SPK Ver.
    . ${INSTALL_DIR}/.config/KEEP_VAR
    if [ "$KEEP_CUR" == "yes" ]; then
       rm -fr ${INSTALL_DIR}/share
       mv ${TMP_DIR}/${PACKAGE}/share ${INSTALL_DIR}/
    fi

    # Remove Backups & Upgrade Flag
    rm -fr ${TMP_DIR}/${PACKAGE}
    rm ${INSTALL_DIR}/.config/KEEP_VAR

    # Finish Logging
    echo "|| Package upgraded to $(grep "version" /var/packages/${PACKAGE}/INFO) - $(date) ||" >> ${INSTALL_LOG}

    # Ensure file ownership is correct after upgrade
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}
