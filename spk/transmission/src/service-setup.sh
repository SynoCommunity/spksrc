# Add python to path
# This gives tranmission the power to execute python scripts on completion (like TorrentToMedia).
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
    # use system python for DSM7
    PYTHON_BIN_PATHS=""
else
    GROUP="sc-download"
    PYTHON_BIN_PATHS="/var/packages/python38/target/bin:/var/packages/python3/target/bin:"
fi
PATH="${SYNOPKG_PKGDEST}/bin:${PYTHON_BIN_PATHS}${PATH}"
CFG_FILE="${SYNOPKG_PKGVAR}/settings.json"
TRANSMISSION="${SYNOPKG_PKGDEST}/bin/transmission-daemon"

SERVICE_COMMAND="${TRANSMISSION} -g ${SYNOPKG_PKGVAR} -x ${PID_FILE} -e ${LOG_FILE}"

validate_preinst()
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
        fi

        # Edit the configuration according to the wizard
        sed -i -e "s|@download_dir@|${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}|g" "${CFG_FILE}"
        sed -i -e "s|@username@|${wizard_username:=admin}|g" "${CFG_FILE}"
        sed -i -e "s|@password@|${wizard_password:=admin}|g" "${CFG_FILE}"
        if [ -d "${wizard_watch_dir}" ]; then
            sed -i -e "s|@watch_dir_enabled@|true|g" "${CFG_FILE}"
            sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" "${CFG_FILE}"
        else
            sed -i -e "s|@watch_dir_enabled@|false|g" "${CFG_FILE}"
            sed -i -e "/@watch_dir@/d" "${CFG_FILE}"
        fi
        if [ -d "${wizard_incomplete_dir}" ]; then
            sed -i -e "s|@incomplete_dir_enabled@|true|g" "${CFG_FILE}"
            sed -i -e "s|@incomplete_dir@|${wizard_incomplete_dir}|g" "${CFG_FILE}"
        else
            sed -i -e "s|@incomplete_dir_enabled@|false|g" "${CFG_FILE}"
            sed -i -e "/@incomplete_dir@/d" "${CFG_FILE}"
        fi

        # Set permissions for optional folders
        if [ -d "${wizard_watch_dir}" ]; then
            set_syno_permissions "${wizard_watch_dir}" "${GROUP}"
        fi
        if [ -d "${wizard_incomplete_dir}" ]; then
            set_syno_permissions "${wizard_incomplete_dir}" "${GROUP}"
        fi
    fi
}

service_postupgrade ()
{
    if [ -r "${CFG_FILE}" ]; then
        # Migrate to DSM7
        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
            OLD_DOWNLOAD_DIR=$(sed -n 's/.*"download-dir"\s*:\s*"\(.*\)",/\1/p' "${CFG_FILE}")
            OLD_INCOMPLETE_DIR=$(sed -n 's/.*"incomplete-dir"\s*:\s*"\(.*\)",/\1/p' "${CFG_FILE}")
            OLD_WATCHED_DIR=$(sed -n 's/.*"watch-dir"\s*:\s*"\(.*\)",/\1/p' "${CFG_FILE}")

            NEW_DOWNLOAD_DIR="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}"
            NEW_INCOMPLETE_DIR="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/incomplete"
            NEW_WATCHED_DIR="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/watch"

            # update folders
            SETTINGS=$(cat "${CFG_FILE}")
            SETTINGS=$(echo "$SETTINGS" | jq '."watch-dir-enabled"=true | ."incomplete-dir-enabled"=true')
            SETTINGS=$(echo "$SETTINGS" | jq --arg path ${NEW_DOWNLOAD_DIR} '."download-dir"=$path')
            SETTINGS=$(echo "$SETTINGS" | jq --arg path ${NEW_INCOMPLETE_DIR} '."incomplete-dir"=$path')
            SETTINGS=$(echo "$SETTINGS" | jq --arg path ${NEW_WATCHED_DIR} '."watch-dir"=$path')
            echo "$SETTINGS" > "${CFG_FILE}"

            mkdir -p "$NEW_INCOMPLETE_DIR"
            mkdir -p "$NEW_WATCHED_DIR"

            # move files
            # not moving download dir because it could contain data not from this package
            # if [ "$OLD_DOWNLOAD_DIR" != "$NEW_DOWNLOAD_DIR" ]; then
            #     mv -nv "$OLD_DOWNLOAD_DIR"/* "$NEW_DOWNLOAD_DIR"
            # fi
            shopt -s dotglob # copy hidden folder/files too
            if [ -n "${OLD_INCOMPLETE_DIR}" ] &&  [ "$OLD_INCOMPLETE_DIR" != "$NEW_INCOMPLETE_DIR" ]; then
                mv -nv "$OLD_INCOMPLETE_DIR"/* "$NEW_INCOMPLETE_DIR/"
            fi
            if [ -n "${OLD_WATCHED_DIR}" ] && [ "$OLD_WATCHED_DIR" != "$NEW_WATCHED_DIR" ]; then
                mv -nv "$OLD_WATCHED_DIR"/* "$NEW_WATCHED_DIR/"
            fi
            shopt -d dotglob
        else
            # Extract the right paths from config file and update Permissions
            DOWNLOAD_DIR=$(sed -n 's/.*"download-dir"\s*:\s*"\(.*\)",/\1/p' "${CFG_FILE}")
            INCOMPLETE_DIR=$(sed -n 's/.*"incomplete-dir"\s*:\s*"\(.*\)",/\1/p' "${CFG_FILE}")
            WATCHED_DIR=$(sed -n 's/.*"watch-dir"\s*:\s*"\(.*\)",/\1/p' "${CFG_FILE}")
            # Apply permissions
            if [ -n "${DOWNLOAD_DIR}" ] && [ -d "${DOWNLOAD_DIR}" ]; then
                set_syno_permissions "${DOWNLOAD_DIR}" "${GROUP}"
            fi
            if [ -n "${INCOMPLETE_DIR}" ] && [ -d "${INCOMPLETE_DIR}" ]; then
                set_syno_permissions "${INCOMPLETE_DIR}" "${GROUP}"
            fi
            if [ -n "${WATCHED_DIR}" ] && [ -d "${WATCHED_DIR}" ]; then
                set_syno_permissions "${WATCHED_DIR}" "${GROUP}"
            fi
        fi
    fi
}
