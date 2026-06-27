
CFG_FILE="${SYNOPKG_PKGVAR}/mpd.conf"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/mpd ${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Edit the configuration according to the wizard (install only)
        sed -i -e "s|@music_directory@|${SHARE_PATH}|g" "${CFG_FILE}"

        # Create playlists folder
        mkdir -p "${SYNOPKG_PKGVAR}/playlists"
    fi
}

service_preupgrade ()
{
    if [ ! -e "${CFG_FILE}" ]; then
        echo "WARNING: cannot update ${INST_VARIABLES}. Config not found: ${CFG_FILE}"
    else
        # Migrate legacy MPD socket path (global bind_to_address only)
        if grep -Eq '^#bind_to_address[[:space:]]+"~/.mpd/socket"' "${CFG_FILE}"; then
            echo "Migrating legacy MPD socket path to package location"
            sed -i \
                -e 's|^#bind_to_address[[:space:]]\+"~/.mpd/socket"|bind_to_address		"/var/packages/mpd/var/mpd.socket"|' \
                "${CFG_FILE}"
        fi
        # Handle legacy installs
        if [ ! -e "${INST_VARIABLES}" ]; then
            # create file with installer variables on the fly
            SHARE_PATH=$(sed -nE 's/^music_directory[[:space:]]+"([^"]+)".*/\1/p' "${CFG_FILE}")
            if [ -z "${SHARE_NAME}" -a -n "${SHARE_PATH}" ]; then
                SHARE_NAME=$(basename "${SHARE_PATH}")
            fi
            echo "Create ${INST_VARIABLES} [SHARE_PATH=${SHARE_PATH}, SHARE_NAME=${SHARE_NAME}]"
            save_wizard_variables
        else
            # fix installer variables of former installation (stored share name as SHARE_PATH)
            SHARE_PATH=$(echo "${SHARE_PATH}" | grep ^/)
            if [ -z "${SHARE_PATH}" -o -z "${SHARE_NAME}" ]; then
                if [ -z "${SHARE_PATH}" ]; then
                    SHARE_PATH=$(sed -nE 's/^music_directory[[:space:]]+"([^"]+)".*/\1/p' "${CFG_FILE}")
                fi
                if [ -z "${SHARE_NAME}" -a -n "${SHARE_PATH}" ]; then
                    SHARE_NAME=$(basename "${SHARE_PATH}")
                fi
                echo "Update ${INST_VARIABLES} [SHARE_PATH=${SHARE_PATH}, SHARE_NAME=${SHARE_NAME}]"
                save_wizard_variables
            fi
        fi
    fi
}
