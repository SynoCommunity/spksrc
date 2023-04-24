
# Readarr service setup
READARR="${SYNOPKG_PKGDEST}/share/Readarr/bin/Readarr"

# Readarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${HOME_DIR}/.config"
READARR_CONFIG_DIR="${CONFIG_DIR}/Readarr"
PID_FILE="${READARR_CONFIG_DIR}/readarr.pid"
CMD_ARGS="-nobrowser -data=${READARR_CONFIG_DIR}"

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    GROUP="sc-download"
    SERVICE_COMMAND="env HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${READARR} ${CMD_ARGS}"
else
    SERVICE_COMMAND="env HOME=${HOME_DIR} ${READARR} ${CMD_ARGS}"
fi

SVC_BACKGROUND=y
SVC_WAIT_TIMEOUT=90

service_postinst ()
{
    echo "Set update required"
    # Make Readarr do an update check on start
    touch ${READARR_CONFIG_DIR}/update_required 2>&1

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
}

service_preupgrade ()
{
    ## never update Readarr distribution, use internal updater only
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup ] && rm -rf ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup
    echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
    mkdir -p ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup 2>&1
    rsync -aX ${SYNOPKG_PKGDEST}/share ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/ 2>&1
}

service_postupgrade ()
{
    ## restore Readarr distribution
    if [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share ]; then
        echo "Restore previous distribution from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        rm -rf ${SYNOPKG_PKGDEST}/share/Readarr/bin 2>&1
        # prevent overwrite of updated package_info
        rsync -aX --exclude=package_info ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share/ ${SYNOPKG_PKGDEST}/share 2>&1
    fi

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}/share"
    fi
}
