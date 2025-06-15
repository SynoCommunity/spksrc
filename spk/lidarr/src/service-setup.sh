
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

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    GROUP="sc-download"
    SERVICE_COMMAND="env HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${LIDARR} ${CMD_ARGS}"
else
    SERVICE_COMMAND="env HOME=${HOME_DIR} ${LIDARR} ${CMD_ARGS}"
fi

SVC_BACKGROUND=y
SVC_WAIT_TIMEOUT=90

service_postinst ()
{
    echo "Set update required"
    # Make Lidarr do an update check on start to avoid possible Lidarr
    # downgrade when synocommunity package is updated
    touch ${LIDARR_CONFIG_DIR}/update_required 2>&1

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

    ## never update Lidarr distribution, use internal updater only
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup ] && rm -rf ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup
    echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
    mkdir -p ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup 2>&1
    rsync -aX ${SYNOPKG_PKGDEST}/share ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/ 2>&1
}

service_postupgrade ()
{
    ## restore Lidarr distribution
    if [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share ]; then
        echo "Restore previous distribution from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        rm -rf ${SYNOPKG_PKGDEST}/share/Lidarr/bin 2>&1
        # prevent overwrite of updated package_info
        rsync -aX --exclude=package_info ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share/ ${SYNOPKG_PKGDEST}/share 2>&1
    fi

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}/share"
    fi
}
