PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
#
CFG_PATH="${SYNOPKG_PKGVAR}"
CFG_CORE="${SYNOPKG_PKGVAR}/core.conf"
CFG_WATCH="${SYNOPKG_PKGVAR}/autoadd.conf"
#
PYTHON_EGG_CACHE="${SYNOPKG_PKGDEST}/env/cache"
#
DELUGED="${SYNOPKG_PKGDEST}/env/bin/deluged"
DELUGED_LOG="${SYNOPKG_PKGDEST}/var/deluged.log"
DELUGED_PID="${SYNOPKG_PKGDEST}/var/deluged.pid"
#
DELUGEWEB="${SYNOPKG_PKGDEST}/env/bin/deluge-web"
DELUGEWEB_LOG="${SYNOPKG_PKGDEST}/var/deluge-web.log"
DELUGEWEB_PID="${SYNOPKG_PKGDEST}/var/deluge-web.pid"
#
# deluded & deluge-web options:
# -c --config
# -l --logfile
# -L --loglevel
# -d --do-not-daemonize ==> forked PID untrackable
# -P --pidfile          ==> generated PID file unusable for tracking
#
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes
DELUGEWEB_DAEMON="${DELUGEWEB} -c ${CFG_PATH} ${DELUGE_ARGS} -l ${DELUGEWEB_LOG} -L info --logrotate -P ${DELUGEWEB_PID} -d"
DELUGED_DAEMON="${DELUGED} -c ${CFG_PATH} ${DELUGE_ARGS} -l ${DELUGED_LOG} -L info --logrotate -P ${DELUGED_PID} -d"
#
SERVICE_COMMAND[0]="${DELUGED_DAEMON}"
SERVICE_COMMAND[1]="${DELUGEWEB_DAEMON}"

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
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}/env"
    fi

    # Edit the configuration files according to the wizard
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        for cfg_file in "${CFG_CORE} ${CFG_WATCH}"; do
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
            sed -i -e "s|\"enabled_plugins\": \[\],|\"enabled_plugins\": \[\n        \"AutoAdd\"\n    \], \n|g" ${CFG_CORE}
            sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" ${CFG_WATCH}
        else
            sed -i -e "/@watch_dir@/d" ${CFG_WATCH}
        fi
    fi
}


service_postupgrade ()
{
    # Needed to force correct permissions, during update from prior version
    # Extract the right paths from config file
    if [ -r "${CFG_CORE}" ]; then
        download=`sed -n 's/.*"download_location"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_CORE}`
        complete=`sed -n 's/.*"move_completed_path"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_CORE}`
        watch=`sed -n 's/.*"autoadd_location"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_CORE}`

        # For backwards compatibility, apply permissions
        if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
            if [ -n "${download}" ] && [ -d "${download}" ]; then
                set_syno_permissions "${download}" "${GROUP}"
            fi
            if [ -n "${complete}" ] && [ -d "${complete}" ]; then
                set_syno_permissions "${complete}" "${GROUP}"
            fi
            if [ -n "${watch}" ] && [ -d "${watch}" ]; then
                set_syno_permissions "${watch}" "${GROUP}"
            fi
        fi
    fi
}
