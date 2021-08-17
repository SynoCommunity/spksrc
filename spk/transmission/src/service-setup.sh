# Add python to path
# This gives tranmission the power to execute python scripts on completion (like TorrentToMedia).
PYTHON_DIR="/usr/local/python"
PATH="${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}/bin:${PATH}"
CFG_FILE="${SYNOPKG_PKGVAR}/settings.json"
TRANSMISSION="${SYNOPKG_PKGDEST}/bin/transmission-daemon"

GROUP="sc-download"

SERVICE_COMMAND="${TRANSMISSION} -g ${SYNOPKG_PKGVAR} -x ${PID_FILE} -e ${LOG_FILE}"

validate_preinst()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        # If chosen, they need to exist
        if [ -n "${wizard_watch_dir}" ] && [ ! -d "${wizard_watch_dir}" ]; then
            echo "Watch directory ${wizard_watch_dir} does not exist. And the package could not create it."
            exit 1
        fi
        if [ -n "${wizard_incomplete_dir}" ] && [ ! -d "${wizard_incomplete_dir}" ]; then
            echo "Incomplete directory ${wizard_incomplete_dir} does not exist. And the package could not create it."
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
        sed -i -e "s|@download_dir@|${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}|g" ${CFG_FILE}
        sed -i -e "s|@username@|${wizard_username:=admin}|g" ${CFG_FILE}
        sed -i -e "s|@password@|${wizard_password:=admin}|g" ${CFG_FILE}
        if [ -d "${wizard_watch_dir}" ]; then
            sed -i -e "s|@watch_dir_enabled@|true|g" ${CFG_FILE}
            sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" ${CFG_FILE}
        else
            sed -i -e "s|@watch_dir_enabled@|false|g" ${CFG_FILE}
            sed -i -e "/@watch_dir@/d" ${CFG_FILE}
        fi
        if [ -d "${wizard_incomplete_dir}" ]; then
            sed -i -e "s|@incomplete_dir_enabled@|true|g" ${CFG_FILE}
            sed -i -e "s|@incomplete_dir@|${wizard_incomplete_dir}|g" ${CFG_FILE}
        else
            sed -i -e "s|@incomplete_dir_enabled@|false|g" ${CFG_FILE}
            sed -i -e "/@incomplete_dir@/d" ${CFG_FILE}
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

validate_postinst()
{
    # Need to make sure the user/group has been created by the package
    # before checking that the folder exists (chicken egg problem)
    # https://github.com/SynoCommunity/spksrc/issues/4766#issuecomment-899535272
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # If chosen, they need to exist
        if [ -n "${wizard_watch_dir}" ] && [ ! -d "${wizard_watch_dir}" ]; then
            echo "<p style=\"color:red\">Watch directory ${wizard_watch_dir} does not exist. And the package could not create it. <br> Please uninstall the package, check permissions and try again.</p>"
            exit 1
        fi
        if [ -n "${wizard_incomplete_dir}" ] && [ ! -d "${wizard_incomplete_dir}" ]; then
            echo "<p style=\"color:red\">Incomplete directory ${wizard_incomplete_dir} does not exist. And the package could not create it. <br> Please uninstall the package, check permissions and try again.</p>"
            exit 1
        fi
    fi

    exit 0
}


service_postupgrade ()
{
    # Needed to force correct permissions, during update
    # Extract the right paths from config file
    if [ -r "${CFG_FILE}" ]; then
        # update folder
        sed -i -e "s|\s\"download-dir\".*|    \"download-dir\": \"${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}\",|g" ${CFG_FILE}

        DOWNLOAD_DIR=$(sed -n 's/.*"download-dir"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_FILE})
        INCOMPLETE_DIR=$(sed -n 's/.*"incomplete-dir"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_FILE})
        WATCHED_DIR=$(sed -n 's/.*"watch-dir"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_FILE})
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
}
