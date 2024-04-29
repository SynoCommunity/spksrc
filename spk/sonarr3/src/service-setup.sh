
# Sonarr service setup
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
MONO_PATH="/var/packages/mono/target/bin"
MONO="${MONO_PATH}/mono"
SONARR="${SYNOPKG_PKGDEST}/share/Sonarr/Sonarr.exe"

# Sonarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${HOME_DIR}/.config"
SONARR_CONFIG_DIR="${CONFIG_DIR}/Sonarr"
PID_FILE="${SONARR_CONFIG_DIR}/sonarr.pid"
CMD_ARGS="-nobrowser -data=${SONARR_CONFIG_DIR}"

# Some have it stored in the root of package
LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/.config"

# workaround for mono bug with armv5 (https://github.com/mono/mono/issues/12537)
if [ "$SYNOPKG_DSM_ARCH" = "88f6281" ] || [ "$SYNOPKG_DSM_ARCH" = "88f6282" ]; then
    MONO="MONO_ENV_OPTIONS='-O=-aot,-float32' ${MONO}"
fi

# for DSM < 7 only:
if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    GROUP="sc-download"
    LEGACY_GROUP="sc-media"
fi

SERVICE_COMMAND="env PATH=${MONO_PATH}:${PATH} HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${MONO} ${SONARR} ${CMD_ARGS}"
SVC_BACKGROUND=y
SVC_WAIT_TIMEOUT=90

validate_preupgrade ()
{
    # check if the installed distribution is a legacy version
    if [ -f ${SYNOPKG_PKGDEST}/share/NzbDrone/NzbDrone.exe ]; then
        # v2 installed
        echo "Update from NzbDrone (Sonarr v2.x) is not supported."
        exit 1
    fi
}

service_postinst ()
{
    echo "Set update required"
    # Make Sonarr do an update check on start to update to the latest version available
    touch ${SONARR_CONFIG_DIR}/update_required 2>&1
    
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

    # remove former temp folders that were never removed
    for folder in "nzbdrone_backup" "nzbdrone_update" "sonarr_backup" "sonarr_update"; do
        if [ -d /tmp/${folder} ]; then
            echo "Remove obsolete folder /tmp/${folder}"
            rm -rf /tmp/${folder} 2>&1
        fi
    done

    # never update Sonarr distribution, use internal updater only
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup ] && rm -rf ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup
    echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
    mkdir -p ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup 2>&1
    rsync -aX ${SYNOPKG_PKGDEST}/share ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/ 2>&1
}

service_postupgrade ()
{
    # restore Sonarr distribution
    if [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share ]; then
        echo "Restore previous distribution from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        rm -rf ${SYNOPKG_PKGDEST}/share/Sonarr/bin 2>&1
        # prevent overwrite of updated package_info
        rsync -aX --exclude=package_info ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share/ ${SYNOPKG_PKGDEST}/share 2>&1
    fi

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}/share"
    fi
}
