PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
MONO_PATH="/usr/local/mono/bin"
MONO="${MONO_PATH}/mono"

SONARR="${SYNOPKG_PKGDEST}/share/NzbDrone/NzbDrone.exe"
SPK_SONARR="${SYNOPKG_PKGINST_TEMP_DIR}/share/NzbDrone/NzbDrone.exe"

# Sonarr uses custom Config and PID directories
CONFIG_DIR="${SYNOPKG_PKGDEST}/.config"
PID_FILE="${CONFIG_DIR}/NzbDrone/nzbdrone.pid"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

# Generic service corrects only /var/ directories
# Sonarr needs other folders too
correct_sonarr_permissions ()
{
    DIR=$1
    echo "Setting permissions for ${EFF_USER} on ${DIR}" >> ${INST_LOG}
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
        chown -R ${EFF_USER}:root "${DIR}" >> ${INST_LOG} 2>&1
    else
        chown -R ${EFF_USER}:${USER} "${DIR}" >> ${INST_LOG} 2>&1
    fi
}

service_prestart ()
{
    # Replace generic service startup, run service as daemon
    echo "Starting Sonarr as daemon under user ${EFF_USER} in group ${GROUP}" >> ${LOG_FILE}
    COMMAND="env PATH=${MONO_PATH}:${PATH} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${MONO} ${SONARR}"
    echo "${COMMAND}" >> ${LOG_FILE}

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
        su ${EFF_USER} -s /bin/sh -c "${COMMAND}" >> ${LOG_FILE} 2>&1 &
    else
        ${COMMAND} >> ${LOG_FILE} 2>&1 &
    fi
}

service_postinst ()
{
    # Move config.xml to .config
    mkdir -p ${CONFIG_DIR}/NzbDrone
    mv ${SYNOPKG_PKGDEST}/app/config.xml ${CONFIG_DIR}/NzbDrone/config.xml
    correct_sonarr_permissions "${CONFIG_DIR}"

    # If nessecary, add user also to the old group before removing it
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "${LEGACY_GROUP}"

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN >> ${INST_LOG}
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}

service_preupgrade ()
{
    # We have to account for legacy folder under /var/
    # It should go, after the upgrade, into /.config/
    # The /var/ folder gets automatically copied by service-installer after this
    # So we need to move our new /.config/ folder to /var/ (if present)
    if [ -d "${CONFIG_DIR}" ]; then
        echo "Moving ${CONFIG_DIR} to ${INST_VAR}" >> ${INST_LOG}
        mv ${CONFIG_DIR} ${INST_VAR}/.config
    else
        # Need it always, to save KEEP_VAR
        mkdir ${INST_VAR}/.config
    fi

    # Is Installed Sonarr Binary Ver. >= SPK Sonarr Binary Ver.?
    CUR_VER=$(${MONO_PATH}/monodis --assembly ${SONARR} | grep "Version:" | awk '{print $2}')
    echo "Installed Sonarr Binary: ${CUR_VER}" >> ${INST_LOG}
    SPK_VER=$(${MONO_PATH}/monodis --assembly ${SPK_SONARR} | grep "Version:" | awk '{print $2}')
    echo "Requested Sonarr Binary: ${SPK_VER}" >> ${INST_LOG}
    if [ "${CUR_VER//.}" -ge "${SPK_VER//.}" ]; then
        echo 'KEEP_CUR="yes"' > ${INST_VAR}/.config/KEEP_VAR
        echo "[KEEPING] Installed Sonarr Binary - Upgrading Package Only" >> ${INST_LOG}
        mv ${SYNOPKG_PKGDEST}/share ${INST_VAR}
    else
        echo 'KEEP_CUR="no"' > ${INST_VAR}/.config/KEEP_VAR
        echo "[REPLACING] Installed Sonarr Binary" >> ${INST_LOG}
    fi
}

service_postupgrade ()
{
    # Restore some stuff
    # Service-installer already copied the /var/ folder with .config in it
    echo "Moving ${INST_VAR}/.config to ${CONFIG_DIR}" >> ${INST_LOG}
    rm -fr ${CONFIG_DIR} >> $INST_LOG 2>&1
    mv ${INST_VAR}/.config ${SYNOPKG_PKGDEST}/ >> $INST_LOG 2>&1

    # Restore Current Sonarr Binary If Current Ver. >= SPK Ver.
    . ${CONFIG_DIR}/KEEP_VAR
    if [ "$KEEP_CUR" == "yes" ]; then
        echo "Restoring Sonarr version from before upgrade" >> ${INST_LOG}
        rm -fr ${SYNOPKG_PKGDEST}/share >> $INST_LOG 2>&1
        mv ${INST_VAR}/share ${SYNOPKG_PKGDEST}/ >> $INST_LOG 2>&1
        correct_sonarr_permissions "${SYNOPKG_PKGDEST}/share"
    fi
    correct_sonarr_permissions "${CONFIG_DIR}"

    # Remove upgrade Flag
    rm ${CONFIG_DIR}/KEEP_VAR
}
