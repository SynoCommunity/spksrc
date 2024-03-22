
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
    if [ ! -e "${CFG_FILE}" ]; then
        echo "WARNING: cannot update ${INST_VARIABLES}. Config not found: ${CFG_FILE}"
    else
        if [ ! -e "${INST_VARIABLES}" ]; then
            # create file with installer variables on the fly
            SHARE_PATH=$(cat ${CFG_FILE} | grep ^music_directory | awk '{print $2}' | tr -d \")
            if [ -z "${SHARE_NAME}" -a -n "${SHARE_PATH}" ]; then
                SHARE_NAME=$(basename ${SHARE_PATH})
            fi
            echo "Create ${INST_VARIABLES} [SHARE_PATH=${SHARE_PATH}, SHARE_NAME=${SHARE_NAME}]"
            save_wizard_variables
        else
            # fix installer variables of former installation (stored share name as SHARE_PATH)
            SHARE_PATH=$(echo "${SHARE_PATH}" | grep ^/)
            if [ -z "${SHARE_PATH}" -o -z "${SHARE_NAME}" ]; then
                if [ -z "${SHARE_PATH}" ]; then
                    SHARE_PATH=$(cat ${CFG_FILE} | grep ^music_directory | awk '{print $2}' | tr -d \")
                fi
                if [ -z "${SHARE_NAME}" -a -n "${SHARE_PATH}" ]; then
                    SHARE_NAME=$(basename ${SHARE_PATH})
                fi
                echo "Update ${INST_VARIABLES} [SHARE_PATH=${SHARE_PATH}, SHARE_NAME=${SHARE_NAME}]"
                save_wizard_variables
            fi
        fi
    fi
}
