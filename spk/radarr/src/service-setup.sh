PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

# Binary for .NET Core version
RADARR="${SYNOPKG_PKGDEST}/share/Radarr/Radarr"

# Radarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGDEST}/var"
CONFIG_DIR="${SYNOPKG_PKGDEST}/var/.config"
PID_FILE="${CONFIG_DIR}/Radarr/radarr.pid"

# Some have it stored in the root of package
LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/.config"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

SERVICE_COMMAND="env PATH=${PATH} HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${RADARR}"
SVC_BACKGROUND=y

service_postinst ()
{
    # Move config.xml to .config
    mkdir -p ${CONFIG_DIR}/Radarr
    mv ${SYNOPKG_PKGDEST}/app/config.xml ${CONFIG_DIR}/Radarr/config.xml
    set_unix_permissions "${CONFIG_DIR}"

    # If nessecary, add user also to the old group before removing it
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
        mv ${LEGACY_CONFIG_DIR} ${CONFIG_DIR} >> ${INST_LOG} 2>&1
    else
        # Create, in case it's missing for some reason
        mkdir ${CONFIG_DIR} >> ${INST_LOG} 2>&1
    fi

    # Replace Installed Radarr Binary Ver. (will need to be updated in future versions of Radarr to only repalce if newer)
    echo "[REPLACING] Installed Radarr Binary" >> ${INST_LOG}
    fi
}

service_postupgrade ()
{
    # Skip Restore Current Radarr Binary if Current Ver. >= SPK Ver.
    set_unix_permissions "${CONFIG_DIR}"

    # If backup was created before new-style packages
    # new updates/backups will fail due to permissions (see #3185)
    set_unix_permissions "/tmp/radarr_backup"
    set_unix_permissions "/tmp/radarr_update"

    # Remove upgrade Flag
    rm ${CONFIG_DIR}/KEEP_VAR
}
