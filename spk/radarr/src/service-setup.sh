
# Radarr service setup
RADARR="${SYNOPKG_PKGDEST}/share/Radarr/bin/Radarr"

# Radarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${HOME_DIR}/.config"
RADARR_CONFIG_DIR="${CONFIG_DIR}/Radarr"
PID_FILE="${RADARR_CONFIG_DIR}/radarr.pid"

# SPK_REV 15 has it in the wrong place for DSM 7
LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/var/.config"

# for DSM < 7 only:
GROUP="sc-download"

SERVICE_COMMAND="env HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${RADARR} -nobrowser -data=${RADARR_CONFIG_DIR}"
SVC_BACKGROUND=y

service_postinst ()
{
    # Move config.xml to .config
    mkdir -p ${RADARR_CONFIG_DIR}
    mv ${SYNOPKG_PKGDEST}/app/config.xml ${RADARR_CONFIG_DIR}/config.xml

    echo "Set update required"
    # Make Radarr do an update check on start to avoid possible Radarr
    # downgrade when synocommunity package is updated
    touch ${RADARR_CONFIG_DIR}/update_required 2>&1

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
}

service_preupgrade ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -ge 7 ]; then
        # ensure config is in @appdata folder
        if [ -d "${LEGACY_CONFIG_DIR}" ]; then
            if [ "$(realpath ${LEGACY_CONFIG_DIR})" != "$(realpath ${CONFIG_DIR})" ]; then
                echo "Move ${LEGACY_CONFIG_DIR} to ${CONFIG_DIR}"
                mv ${LEGACY_CONFIG_DIR} ${CONFIG_DIR} 2>&1
            fi
        fi
    fi

    ## never update Radarr distribution, use internal updater only
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup ] && rm -rf ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup
    echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
    mkdir -p ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup 2>&1
    rsync -aX ${SYNOPKG_PKGDEST}/share ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/ 2>&1
}

service_postupgrade ()
{
    ## restore Radarr distribution
    if [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share ]; then
        echo "Restore previous distribution from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        rm -rf ${SYNOPKG_PKGDEST}/share/Radarr/bin 2>&1
        # prevent overwrite of updated package_info
        rsync -aX --exclude=package_info ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share/ ${SYNOPKG_PKGDEST}/share 2>&1
    fi
}
