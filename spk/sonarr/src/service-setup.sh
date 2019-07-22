PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
MONO_PATH="/usr/local/mono/bin"
MONO="${MONO_PATH}/mono"

# Sonarr uses the home directory to store it's ".config"
HOME_DIR="${SYNOPKG_PKGDEST}/var"
CONFIG_DIR="${SYNOPKG_PKGDEST}/var/.config"

# Sonarr v2 -> v3 compatibility:
if [ -f "${SYNOPKG_PKGDEST}/share/NzbDrone/NzbDrone.exe" ]; then
    # v2 installed
    SONARR="${SYNOPKG_PKGDEST}/share/NzbDrone/NzbDrone.exe"
    PID_FILE="${CONFIG_DIR}/NzbDrone/nzbdrone.pid"
else
    # v3 installed
    SONARR="${SYNOPKG_PKGDEST}/share/Sonarr/Sonarr.exe"
    PID_FILE="${CONFIG_DIR}/Sonarr/sonarr.pid"
fi

# Allow correct Sonarr SPK version checking (v2 or v3)
if [ -f "${SYNOPKG_PKGINST_TEMP_DIR}/share/NzbDrone/NzbDrone.exe" ]; then
    # v2 SPK
    SPK_SONARR="${SYNOPKG_PKGINST_TEMP_DIR}/share/NzbDrone/NzbDrone.exe"
else
    # v3 SPK
    SPK_SONARR="${SYNOPKG_PKGINST_TEMP_DIR}/share/Sonarr/Sonarr.exe"
fi

# Some have it stored in the root of package
LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/.config"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

SERVICE_COMMAND="env PATH=${MONO_PATH}:${PATH} HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${MONO} ${SONARR}"
SVC_BACKGROUND=y

service_postinst ()
{
    set_unix_permissions "${CONFIG_DIR}"

    # If necessary, add user also to the old group before removing it
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "${LEGACY_GROUP}"
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "users"

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN >> ${INST_LOG}
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}

service_preupgrade ()
{
    # We have to account for legacy folder in the root
    # It should go, after the upgrade, into /var/.config/
    # The /var/ folder gets automatically copied by service-installer after this
    if [ -d "${LEGACY_CONFIG_DIR}" ]; then
        echo "Moving ${LEGACY_CONFIG_DIR} to ${INST_VAR}" >> ${INST_LOG}
        mv ${LEGACY_CONFIG_DIR} ${CONFIG_DIR} >> ${LOG_FILE} 2>&1
    else
        # Create, in case it's missing for some reason
        mkdir ${CONFIG_DIR} >> ${LOG_FILE} 2>&1
    fi

    # Is Installed Sonarr Binary Ver. >= SPK Sonarr Binary Ver.?
    CUR_VER=$(${MONO_PATH}/monodis --assembly ${SONARR} | grep "Version:" | awk '{print $2}')
    echo "Installed Sonarr Binary: ${CUR_VER}" >> ${INST_LOG}
    SPK_VER=$(${MONO_PATH}/monodis --assembly ${SPK_SONARR} | grep "Version:" | awk '{print $2}')
    echo "Requested Sonarr Binary: ${SPK_VER}" >> ${INST_LOG}
    function version_compare() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }
    if version_compare $CUR_VER $SPK_VER; then
        echo 'KEEP_CUR="yes"' > ${CONFIG_DIR}/KEEP_VAR
        echo "[KEEPING] Installed Sonarr Binary - Upgrading Package Only" >> ${INST_LOG}
        mv ${SYNOPKG_PKGDEST}/share ${INST_VAR}
    else
        echo 'KEEP_CUR="no"' > ${CONFIG_DIR}/KEEP_VAR
        echo "[REPLACING] Installed Sonarr Binary" >> ${INST_LOG}
    fi
}

service_postupgrade ()
{
    # Restore Current Sonarr Binary If Current Ver. >= SPK Ver.
    . ${CONFIG_DIR}/KEEP_VAR
    if [ "$KEEP_CUR" == "yes" ]; then
        echo "Restoring Sonarr version from before upgrade" >> ${INST_LOG}
        rm -fr ${SYNOPKG_PKGDEST}/share >> $INST_LOG 2>&1
        mv ${INST_VAR}/share ${SYNOPKG_PKGDEST}/ >> $INST_LOG 2>&1
        set_unix_permissions "${SYNOPKG_PKGDEST}/share"
    fi

    set_unix_permissions "${CONFIG_DIR}"

    # If backup was created before new-style packages
    # new updates/backups will fail due to permissions (see #3185)
    set_unix_permissions "/tmp/nzbdrone_backup"
    set_unix_permissions "/tmp/nzbdrone_update"

    # Remove upgrade Flag
    rm ${CONFIG_DIR}/KEEP_VAR
}
