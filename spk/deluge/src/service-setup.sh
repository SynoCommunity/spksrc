PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
CORE_CFG_FILE="${SYNOPKG_PKGVAR}/core.conf"
WATCH_CFG_FILE="${SYNOPKG_PKGVAR}/autoadd.conf"

# Required variables to start both processes
# We use Generic Service variables for main deamon
DELUGED="${SYNOPKG_PKGDEST}/env/bin/deluged"
DELUGE_WEB="${SYNOPKG_PKGDEST}/env/bin/deluge-web"
CFG_DIR="${SYNOPKG_PKGVAR}"
PYTHON_EGG_CACHE="${SYNOPKG_PKGDEST}/env/cache"
#DELUGE_WEB_PID="${SYNOPKG_PKGDEST}/var/deluge-web.pid"
DELUGE_WEB_LOG="${SYNOPKG_PKGDEST}/var/deluge-web.log"

DAEMON_DELUGED="${DELUGED} --config ${CFG_DIR} --logfile ${LOG_FILE} --loglevel info --pidfile ${PID_FILE}"
#DAEMON_DELUGE_WEB="${DELUGE_WEB} --config ${CFG_DIR} --logfile ${DELUGE_WEB_LOG} --loglevel info --pidfile ${DELUGE_WEB_PID}"
DAEMON_DELUGE_WEB="${DELUGE_WEB} --config ${CFG_DIR} --logfile ${DELUGE_WEB_LOG} --loglevel info --pidfile ${PID_FILE}"
SERVICE_COMMAND[0]="${DAEMON_DELUGED}"
SERVICE_COMMAND[1]="${DAEMON_DELUGE_WEB}"

GROUP="sc-download"

service_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -d "${wizard_download_dir}" ]; then
            echo "Download directory ${wizard_download_dir} does not exist."
            exit 1
        fi
        if [ -n "${wizard_watch_dir}" -a ! -d "${wizard_watch_dir}" ]; then
            echo "Watch directory ${wizard_watch_dir} does not exist."
            exit 1
        fi
        if [ -n "${wizard_complete_dir}" -a ! -d "${wizard_complete_dir}" ]; then
            echo "Complete directory ${wizard_complete_dir} does not exist."
            exit 1
        fi
    fi
}

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    # Install the wheels
    install_python_wheels

    # For backwards compatibility, correct permissions, otherwise Deluge can't write to cache
    if [ $SYNOPKG_DSM_VERSION_MAJOR == 6 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}/env"
    fi

    # Edit the configuration files according to the wizard
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        for cfg_file in "${CORE_CFG_FILE} ${WATCH_CFG_FILE}"; do
            sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" ${cfg_file}
            if [ -d "${wizard_complete_dir}" ]; then
                sed -i -e "s|@complete_dir_enabled@|true|g" ${cfg_file}
                sed -i -e "s|@complete_dir@|${wizard_complete_dir}|g" ${cfg_file}
            else
                sed -i -e "s|@complete_dir_enabled@|false|g" ${cfg_file}
                sed -i -e "/@complete_dir@/d" ${cfg_file}
            fi
        done
        if [ -d "${wizard_watch_dir}" ]; then
            sed -i -e "s|\"enabled_plugins\": \[\],|\"enabled_plugins\": \[\n        \"AutoAdd\"\n    \], \n|g" ${CORE_CFG_FILE}
            sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" ${WATCH_CFG_FILE}
        else
            sed -i -e "/@watch_dir@/d" ${WATCH_CFG_FILE}
        fi
    fi

    # Create logs directory, otherwise it does not start due to permissions errors
    #mkdir "$(dirname ${LOG_FILE})" >> ${INST_LOG} 2>&1
}


service_postupgrade ()
{
    # Needed to force correct permissions, during update from prior version
    # Extract the right paths from config file
    if [ -r "${CORE_CFG_FILE}" ]; then
        DOWNLOAD_DIR=`sed -n 's/.*"download_location"[ ]*:[ ]*"\(.*\)",/\1/p' ${CORE_CFG_FILE}`
        COMPLETE_DIR=`sed -n 's/.*"move_completed_path"[ ]*:[ ]*"\(.*\)",/\1/p' ${CORE_CFG_FILE}`
        WATCHED_DIR=`sed -n 's/.*"autoadd_location"[ ]*:[ ]*"\(.*\)",/\1/p' ${CORE_CFG_FILE}`

        # Apply permissions
        if [ -n "${DOWNLOAD_DIR}" ] && [ -d "${DOWNLOAD_DIR}" ]; then
            set_syno_permissions "${DOWNLOAD_DIR}" "${GROUP}"
        fi
        if [ -n "${COMPLETE_DIR}" ] && [ -d "${COMPLETE_DIR}" ]; then
            set_syno_permissions "${COMPLETE_DIR}" "${GROUP}"
        fi
        if [ -n "${WATCHED_DIR}" ] && [ -d "${WATCHED_DIR}" ]; then
            set_syno_permissions "${WATCHED_DIR}" "${GROUP}"
        fi
    fi
}
