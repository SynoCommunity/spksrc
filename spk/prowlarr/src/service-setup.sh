
# Prowlarr service setup
PROWLARR="${SYNOPKG_PKGDEST}/share/Prowlarr/bin/Prowlarr"

# Prowlarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${HOME_DIR}/.config"
PROWLARR_CONFIG_DIR="${CONFIG_DIR}/Prowlarr"
PID_FILE="${PROWLARR_CONFIG_DIR}/prowlarr.pid"
CMD_ARGS="-nobrowser -data=${PROWLARR_CONFIG_DIR}"

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    GROUP="sc-download"
    SERVICE_COMMAND="env HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${PROWLARR} ${CMD_ARGS}"
else
    SERVICE_COMMAND="env HOME=${HOME_DIR} ${PROWLARR} ${CMD_ARGS}"
fi

SVC_BACKGROUND=y
SVC_WAIT_TIMEOUT=90

service_postinst ()
{
    echo "Set update required"
    # Make Prowlarr do an update check on start
    touch ${PROWLARR_CONFIG_DIR}/update_required 2>&1

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
}

service_preupgrade ()
{
    ## never update Prowlarr distribution, use internal updater only
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup ] && rm -rf ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup
    echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
    mkdir -p ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup 2>&1
    rsync -aX ${SYNOPKG_PKGDEST}/share ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/ 2>&1
}

service_postupgrade ()
{
    ## restore Prowlarr distribution
    if [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share ]; then
        echo "Restore previous distribution from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        rm -rf ${SYNOPKG_PKGDEST}/share/Prowlarr/bin 2>&1
        # prevent overwrite of updated package_info
        rsync -aX --exclude=package_info ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share/ ${SYNOPKG_PKGDEST}/share 2>&1
    fi

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}/share"
    fi
}
