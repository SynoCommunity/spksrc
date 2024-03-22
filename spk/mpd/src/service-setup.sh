
CFG_FILE="${SYNOPKG_PKGVAR}/mpd.conf"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/mpd ${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    # Edit the configuration according to the wizard
    sed -i -e "s|@music_directory@|${SHARE_PATH}|g" ${CFG_FILE}

    # Create playlists folder
    mkdir -p "${SYNOPKG_PKGVAR}/playlists"
}

service_preupgrade ()
{
    # create file with installer variables on the fly
    if [ ! -e "${INST_VARIABLES}" ]; then
        if [ -e "${CFG_FILE}" ]; then
            if [ -z "${SHARE_PATH}" ]; then
                SHARE_PATH=$(cat ${CONFIG_FILE} | grep music_directory | awk '{print $2}')
            fi
            if [ -z "${SHARE_NAME}" -a -n "${SHARE_PATH}" ]; then
                SHARE_NAME=$(basename ${SHARE_PATH})
            fi
            echo "Create ${INST_VARIABLES} [SHARE_PATH=${SHARE_PATH}, SHARE_NAME=${SHARE_NAME}]"
            save_wizard_variables
        else
            echo "WARNING: cannot create ${INST_VARIABLES}. Config not found: ${CONFIG_FILE}"
        fi
    else
        echo "Installer variables available"
        cat "${INST_VARIABLES}"
    fi
}
