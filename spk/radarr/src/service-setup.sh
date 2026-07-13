
# Radarr service setup
RADARR="${SYNOPKG_PKGDEST}/share/Radarr/bin/Radarr"

# Radarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${HOME_DIR}/.config"
RADARR_CONFIG_DIR="${CONFIG_DIR}/Radarr"
PID_FILE="${RADARR_CONFIG_DIR}/radarr.pid"
CMD_ARGS="-nobrowser -data=${RADARR_CONFIG_DIR}"

# SPK_REV 15 has it in the wrong place for DSM 7
LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/var/.config"

if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    GROUP="sc-download"
    SERVICE_COMMAND="env HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${RADARR} ${CMD_ARGS}"
else
    SERVICE_COMMAND="env HOME=${HOME_DIR} ${RADARR} ${CMD_ARGS}"
fi

SVC_BACKGROUND=y
SVC_WAIT_TIMEOUT=90

internal_update_supported() {
    # DSM >= 7.2: Radarr can self-update (upstream libe_sqlite3.so is GLIBC 2.28+ compatible)
    # DSM < 7.2: Radarr cannot self-update (custom libe_sqlite3.so must be preserved)
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -gt 7 ] || \
       { [ "${SYNOPKG_DSM_VERSION_MAJOR}" -eq 7 ] && [ "${SYNOPKG_DSM_VERSION_MINOR}" -ge 2 ]; }; then
        return 0    # Supported
    else
        return 1    # Not supported
    fi
}

configure_update_method() {
    # Dynamically set UpdateMethod in package_info based on DSM version.
    # Package is built without UpdateMethod so the default is BuiltIn.
    # On DSM < 7.2 we must block Radarr's self-updater because it would
    # overwrite the custom libe_sqlite3.so (built for GLIBC 2.20–2.26)
    # with the upstream version requiring GLIBC >= 2.28, causing a crash.
    local info_file="${SYNOPKG_PKGDEST}/share/Radarr/package_info"
    [ -f "$info_file" ] || return 0

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -gt 7 ] || \
       { [ "${SYNOPKG_DSM_VERSION_MAJOR}" -eq 7 ] && [ "${SYNOPKG_DSM_VERSION_MINOR}" -ge 2 ]; }; then
        # DSM >= 7.2: remove External so Radarr defaults to BuiltIn
        sed -i '/^UpdateMethod=External$/d' "$info_file"
    else
        # DSM < 7.2: ensure External is set
        grep -q '^UpdateMethod=External' "$info_file" 2>/dev/null || \
            echo "UpdateMethod=External" >> "$info_file"
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        configure_update_method

        if internal_update_supported; then
            # Make Radarr do an update check on start to avoid possible Radarr
            # downgrade when synocommunity package is updated
            echo "Set update required"
            touch "${RADARR_CONFIG_DIR}/update_required" 2>&1
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
        # don't update Radarr distribution, use internal updater only
        [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup" ] && rm -rf "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        mkdir -p "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup" 2>&1
        rsync -aX "${SYNOPKG_PKGDEST}/share" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/" 2>&1
    fi
}

service_postupgrade ()
{
    # restore Radarr distribution
    if [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share" ]; then
        echo "Restore previous distribution from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        rm -rf "${SYNOPKG_PKGDEST}/share/Radarr/bin" 2>&1
        # prevent overwrite of updated package_info
        rsync -aX --exclude=package_info "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share/" "${SYNOPKG_PKGDEST}/share" 2>&1
    fi

    configure_update_method

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}/share"
    fi
}
