
# Lidarr service setup
LIDARR="${SYNOPKG_PKGDEST}/share/Lidarr/bin/Lidarr"

# Lidarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${HOME_DIR}/.config"
LIDARR_CONFIG_DIR="${CONFIG_DIR}/Lidarr"
PID_FILE="${LIDARR_CONFIG_DIR}/lidarr.pid"
CMD_ARGS="-nobrowser -data=${LIDARR_CONFIG_DIR}"

# Older installations have it in the wrong place for DSM 7
LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/.config"

if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    GROUP="sc-download"
    SERVICE_COMMAND="env HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${LIDARR} ${CMD_ARGS}"
else
    SERVICE_COMMAND="env HOME=${HOME_DIR} ${LIDARR} ${CMD_ARGS}"
fi

SVC_BACKGROUND=y
SVC_WAIT_TIMEOUT=90

internal_update_supported() {
    info_file="${SYNOPKG_PKGINST_TEMP_DIR}/share/Lidarr/package_info"

    # If the file doesn't exist, assume update is supported
    [ -f "$info_file" ] || return 0

    # If the file contains "UpdateMethod=External", updates are NOT supported
    if grep -q '^UpdateMethod=External' "$info_file" 2>/dev/null; then
        return 1    # Not supported
    else
        return 0    # Supported
    fi
}

# Ensure package_info UpdateMethod matches DSM capabilities at runtime.
# Packages built for TCVERSION < 7.2 ship with UpdateMethod=External to
# protect the custom libe_sqlite3.so on DSM 6–7.1. On DSM 7.2+, the
# updater overwrites bin/ entirely and the upstream GLIBC ≥ 2.28 build
# works as-is, so we can safely enable built-in updates.
configure_update_method() {
    info_file="${SYNOPKG_PKGDEST}/share/Lidarr/package_info"
    [ -f "$info_file" ] || return 0

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ] && \
       [ "${SYNOPKG_DSM_VERSION_MINOR:-0}" -ge 2 ] 2>/dev/null || \
       [ "${SYNOPKG_DSM_VERSION_MAJOR}" -gt 7 ]; then
        # DSM 7.2+: allow built-in updater
        if grep -q '^UpdateMethod=External' "$info_file" 2>/dev/null; then
            echo "DSM 7.2+ detected, enabling built-in updater"
            sed -i '/^UpdateMethod=External$/d' "$info_file"
        fi
    else
        # DSM < 7.2: protect from updater overwriting custom libe_sqlite3
        grep -q '^UpdateMethod=External' "$info_file" 2>/dev/null || \
            echo "UpdateMethod=External" >> "$info_file"
    fi
}

service_postinst ()
{
    configure_update_method

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if internal_update_supported; then
            # Make Lidarr do an update check on start to avoid possible Lidarr
            # downgrade when synocommunity package is updated
            echo "Set update required"
            touch "${LIDARR_CONFIG_DIR}/update_required" 2>&1
        fi

        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
            set_unix_permissions "${CONFIG_DIR}"
        fi
    fi
}

service_preupgrade ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
        # ensure config is in @appdata folder
        if [ -d "${LEGACY_CONFIG_DIR}" ]; then
            if [ "$(realpath "${LEGACY_CONFIG_DIR}")" != "$(realpath "${CONFIG_DIR}")" ]; then
                echo "Move ${LEGACY_CONFIG_DIR} to ${CONFIG_DIR}"
                mv "${LEGACY_CONFIG_DIR}" "${CONFIG_DIR}" 2>&1
            fi
        fi
    fi

    if internal_update_supported; then
        # don't update Lidarr distribution, use internal updater only
        [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup" ] && rm -rf "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        mkdir -p "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup" 2>&1
        rsync -aX "${SYNOPKG_PKGDEST}/share" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/" 2>&1
    fi
}

service_postupgrade ()
{
    configure_update_method

    # restore Lidarr distribution
    if [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share" ]; then
        echo "Restore previous distribution from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        rm -rf "${SYNOPKG_PKGDEST}/share/Lidarr/bin" 2>&1
        # prevent overwrite of updated package_info
        rsync -aX --exclude=package_info "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share/" "${SYNOPKG_PKGDEST}/share" 2>&1
    fi

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}/share"
    fi
}
