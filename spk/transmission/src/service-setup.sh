# Add python to path
# This gives tranmission the power to execute python scripts on completion (like TorrentToMedia).
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
    # use system python for DSM7
    PYTHON_BIN_PATHS=""
else
    GROUP="sc-download"
    PYTHON_BIN_PATHS="/var/packages/python310/target/bin:/var/packages/python38/target/bin:/var/packages/python3/target/bin:"
fi

PATH="${SYNOPKG_PKGDEST}/bin:${PYTHON_BIN_PATHS}${PATH}"
CFG_FILE="${SYNOPKG_PKGVAR}/settings.json"
TRANSMISSION="${SYNOPKG_PKGDEST}/bin/transmission-daemon"

SERVICE_COMMAND="${TRANSMISSION} -g ${SYNOPKG_PKGVAR} -x ${PID_FILE} -e ${LOG_FILE}"

validate_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        # If chosen, they need to exist
        if [ -n "${wizard_watch_dir}" ] && [ ! -d "${wizard_watch_dir}" ]; then
            echo "Watch directory ${wizard_watch_dir} does not exist."
            exit 1
        fi
        if [ -n "${wizard_incomplete_dir}" ] && [ ! -d "${wizard_incomplete_dir}" ]; then
            echo "Incomplete directory ${wizard_incomplete_dir} does not exist."
            exit 1
        fi
    fi

    exit 0
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Attempt to create the folders after the user/group/shared folder has been created by the package (DSM7+)
        # Let the package manage the "watch" and "incomplete" folders for DSM7
        # https://github.com/SynoCommunity/spksrc/issues/4766#issuecomment-899875151
        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
            wizard_watch_dir="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/watch"
            wizard_incomplete_dir="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/incomplete"
            mkdir -p "${wizard_watch_dir}"
            mkdir -p "${wizard_incomplete_dir}"
        else
            # Set permissions for optional folders for DSM <7
            # existance is validated with validate_preinst
            set_syno_permissions "${wizard_watch_dir}" "${GROUP}"
            set_syno_permissions "${wizard_incomplete_dir}" "${GROUP}"
        fi

        # Edit the configuration according to the wizard
        sed -e "s|@download_dir@|${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}|g" \
            -e "s|@username@|${wizard_username:=admin}|g" \
            -e "s|@password@|${wizard_password:=admin}|g" \
            -i ${CFG_FILE}
        if [ -d "${wizard_watch_dir}" ]; then
            sed -e "s|@watch_dir_enabled@|true|g" \
                -e "s|@watch_dir@|${wizard_watch_dir}|g" \
                -i ${CFG_FILE}
        else
            sed -e "s|@watch_dir_enabled@|false|g" \
                -e "/@watch_dir@/d" \
                -i ${CFG_FILE}
        fi
        if [ -d "${wizard_incomplete_dir}" ]; then
            sed -e "s|@incomplete_dir_enabled@|true|g" \
                -e "s|@incomplete_dir@|${wizard_incomplete_dir}|g" \
                -i ${CFG_FILE}
        else
            sed -e "s|@incomplete_dir_enabled@|false|g" \
                -e "/@incomplete_dir@/d" \
                -i ${CFG_FILE}
        fi
    fi
}

service_postupgrade ()
{
    if [ -r "${CFG_FILE}" ]; then
    
        # Extract the paths from config file
        DOWNLOAD_DIR=$(sed -n 's/.*"download-dir"\s*:\s*"\(.*\)",/\1/p' ${CFG_FILE})
        INCOMPLETE_DIR=$(sed -n 's/.*"incomplete-dir"\s*:\s*"\(.*\)",/\1/p' ${CFG_FILE})
        WATCH_DIR=$(sed -n 's/.*"watch-dir"\s*:\s*"\(.*\)",/\1/p' ${CFG_FILE})
    
        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
            # Migrate from DSM6 to DSM7 or update folders on DSM7 when changed in upgrade wizard

            NEW_DOWNLOAD_DIR="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}"
            NEW_INCOMPLETE_DIR="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/incomplete"
            NEW_WATCH_DIR="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/watch"
            mkdir -p "${NEW_INCOMPLETE_DIR}"
            mkdir -p "${NEW_WATCH_DIR}"

            # update folders in config file according to the wizard
            SETTINGS=$(cat "${CFG_FILE}")
            SETTINGS=$(echo "$SETTINGS" | jq '."watch-dir-enabled"=true | ."incomplete-dir-enabled"=true')
            SETTINGS=$(echo "$SETTINGS" | jq --arg path ${NEW_DOWNLOAD_DIR} '."download-dir"=$path')
            SETTINGS=$(echo "$SETTINGS" | jq --arg path ${NEW_INCOMPLETE_DIR} '."incomplete-dir"=$path')
            SETTINGS=$(echo "$SETTINGS" | jq --arg path ${NEW_WATCH_DIR} '."watch-dir"=$path')
            echo "${SETTINGS}" > ${CFG_FILE}

            # move files when folders are changed
            shopt -s dotglob # move hidden folder/files too
            if [ -n "${DOWNLOAD_DIR}" ] && [ $(realpath "${DOWNLOAD_DIR}") != $(realpath "${NEW_DOWNLOAD_DIR}") ]; then
                # move only files from previous download folder that are created by this package (${EFF_USER})
                find "${DOWNLOAD_DIR}" -maxdepth 1 -user ${EFF_USER} -exec mv -nv {} "${NEW_DOWNLOAD_DIR}/" \;
            fi
            if [ -n "${INCOMPLETE_DIR}" ] && [ $(realpath "${INCOMPLETE_DIR}") != $(realpath "${NEW_INCOMPLETE_DIR}") ]; then
                mv -nv "${INCOMPLETE_DIR}/*" "${NEW_INCOMPLETE_DIR}/"
            fi
            if [ -n "${WATCH_DIR}" ] && [ $(realpath "${WATCH_DIR}") != $(realpath "${NEW_WATCH_DIR}") ]; then
                mv -nv "${WATCH_DIR}/*" "${NEW_WATCH_DIR}/"
            fi
            shopt -u dotglob

        else

            # Apply permissions
            if [ -n "${DOWNLOAD_DIR}" ] && [ -d "${DOWNLOAD_DIR}" ]; then
                set_syno_permissions "${DOWNLOAD_DIR}" "${GROUP}"
            fi
            if [ -n "${INCOMPLETE_DIR}" ] && [ -d "${INCOMPLETE_DIR}" ]; then
                set_syno_permissions "${INCOMPLETE_DIR}" "${GROUP}"
            fi
            if [ -n "${WATCH_DIR}" ] && [ -d "${WATCH_DIR}" ]; then
                set_syno_permissions "${WATCH_DIR}" "${GROUP}"
            fi
        fi
    fi
}
