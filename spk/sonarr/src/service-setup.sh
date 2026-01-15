
# Sonarr service setup
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
SONARR="${SYNOPKG_PKGDEST}/share/Sonarr/bin/Sonarr"

# Sonarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${HOME_DIR}/.config"
SONARR_CONFIG_DIR="${CONFIG_DIR}/Sonarr"
PID_FILE="${SONARR_CONFIG_DIR}/sonarr.pid"
CMD_ARGS="-nobrowser -data=${SONARR_CONFIG_DIR}"

LEGACY_SPK_NAME="nzbdrone"
LEGACY_SYNOPKG_PKGDEST="/var/packages/${LEGACY_SPK_NAME}/target"
# check for legacy package data storage location
if [ -d /var/packages/${LEGACY_SPK_NAME}/var ]; then
    LEGACY_SYNOPKG_PKGVAR="/var/packages/${LEGACY_SPK_NAME}/var"
else
    LEGACY_SYNOPKG_PKGVAR="${LEGACY_SYNOPKG_PKGDEST}/var"
fi
LEGACY_CONFIG_DIR="${LEGACY_SYNOPKG_PKGVAR}/.config"
# Some have it stored in the root of package
LEGACY_OLD_CONFIG_DIR="${LEGACY_SYNOPKG_PKGDEST}/.config"

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    GROUP="sc-download"
    SERVICE_COMMAND="env PATH=${PATH} HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${SONARR} ${CMD_ARGS}"
else
    SERVICE_COMMAND="env PATH=${PATH} HOME=${HOME_DIR} ${SONARR} ${CMD_ARGS}"
fi

SVC_BACKGROUND=y
SVC_WAIT_TIMEOUT=120

validate_preinst ()
{
    # check if the installed distribution is a legacy version
    if [ -f ${LEGACY_SYNOPKG_PKGDEST}/share/NzbDrone/NzbDrone.exe ]; then
        # v2 installed
        echo "Update from NzbDrone (Sonarr v2.x) is not supported."
        exit 1
    elif [ -f ${LEGACY_SYNOPKG_PKGDEST}/share/Sonarr/Sonarr.exe ]; then
        # v3 installed
        install_log "Updating from NzbDrone (Sonarr v3.x) via package replacement."
    fi
}

service_postinst ()
{
    # if legacy config present, migrate to @appdata folder
    mkdir -p ${SONARR_CONFIG_DIR} 2>&1
    if [ -d ${LEGACY_CONFIG_DIR}/Sonarr ]; then
        echo "Migrate ${LEGACY_CONFIG_DIR}/Sonarr to ${CONFIG_DIR}"
        rsync -aX ${LEGACY_CONFIG_DIR}/Sonarr ${CONFIG_DIR} 2>&1
    elif [ -d ${LEGACY_OLD_CONFIG_DIR}/Sonarr ]; then
        echo "Migrate ${LEGACY_OLD_CONFIG_DIR}/Sonarr to ${CONFIG_DIR}"
        rsync -aX ${LEGACY_OLD_CONFIG_DIR}/Sonarr ${CONFIG_DIR} 2>&1
    else
        # Make Sonarr do an update check on start to update to the latest version available
        echo "Set update required"
        touch ${SONARR_CONFIG_DIR}/update_required 2>&1
    fi

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
}

service_preupgrade ()
{
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
