PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
#
CFG_PATH="${SYNOPKG_PKGVAR}"
CFG_FILE="${SYNOPKG_PKGVAR}/core.conf"
CFG_WATCH="${SYNOPKG_PKGVAR}/autoadd.conf"
LANGUAGE="env LANG=en_US.UTF-8"
#
DELUGE_LOGS="${SYNOPKG_PKGVAR}/logs"
#
DELUGED="${SYNOPKG_PKGDEST}/env/bin/deluged"
DELUGED_LOG="${DELUGE_LOGS}/deluged.log"
DELUGED_PID="${DELUGE_LOGS}/deluged.pid"
#
DELUGEWEB="${SYNOPKG_PKGDEST}/env/bin/deluge-web"
DELUGEWEB_LOG="${DELUGE_LOGS}/deluge-web.log"
DELUGEWEB_PID="${DELUGE_LOGS}/deluge-web.pid"
#
# Fixes 'Tracker Status: Error: certificate verify failed'
export SSL_CERT_FILE=$(${PYTHON_DIR}/python3 -c "import certifi; print(certifi.where())")
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

if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
    GROUP="synocommunity"
else
    GROUP="sc-download"
fi

deluge_default_install ()
{
    incomplete_folder="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/incomplete"
    complete_folder="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/complete"
    watch_folder="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/watch"

    # Create download directories
    install -m 0775 -o ${EFF_USER} -g ${GROUP} -d "${incomplete_folder}"
    install -m 0775 -o ${EFF_USER} -g ${GROUP} -d "${complete_folder}"
    install -m 0775 -o ${EFF_USER} -g ${GROUP} -d "${watch_folder}"

    # DSM<=6: add group ACL
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        echo "Setting-up group ACL permissions"
        if [ -n "${incomplete_folder}" ] && [ -d "${incomplete_folder}" ]; then
            set_syno_permissions "${incomplete_folder}" "${GROUP}"
        fi
        if [ -n "${complete_folder}" ] && [ -d "${complete_folder}" ]; then
            set_syno_permissions "${complete_folder}" "${GROUP}"
        fi
        if [ -n "${watch_folder}" ] && [ -d "${watch_folder}" ]; then
            set_syno_permissions "${watch_folder}" "${GROUP}"
        fi
    fi

    # Edit the configuration files according to the wizard
    for cfg_file in "${CFG_FILE} ${CFG_WATCH}"; do
        # Default download directory
        sed -i -e "s|@download_dir@|${incomplete_folder}|g" ${cfg_file}
        # Complete directory enabled
        sed -i -e "s|@complete_dir_enabled@|true|g" ${cfg_file}
        sed -i -e "s|@complete_dir@|${complete_folder}|g" ${cfg_file}
    done
    # Watch directory
    sed -i -e "s|\"enabled_plugins\": \[\],|\"enabled_plugins\": \[\n        \"AutoAdd\"\n    \], \n|g" ${CFG_FILE}
    sed -i -e "s|@watch_dir@|${watch_folder}|g" ${CFG_WATCH}
    # plugins directory
    sed -i -e "s|@plugins_dir@|${SYNOPKG_PKGVAR}/plugins|g" ${CFG_FILE}
}

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    # Install the wheels
    install_python_wheels

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        deluge_default_install
    fi

    # DSM<=6: Copy new default configuration files prior from them being
    #         overwritten by old version during postupgrade recovery
    if [ -r "${CFG_FILE}" -a "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        cp -p ${CFG_FILE} ${CFG_FILE}.new
        cp -p ${CFG_WATCH} ${CFG_WATCH}.new
    fi
}


service_postupgrade ()
{
    # Adjust permissions on new path for DSM <= 6
    # Needed to force correct permissions, during update from prior version
    # Extract the right paths from config file
    if [ -r "${CFG_FILE}" -a "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        # Older versions of Deluge on DSM <= 6 must
        # be updated using a newer configuration

        # Backup current old version of core.conf and autoadd.conf
        cp -p ${CFG_FILE} ${CFG_FILE}.bak.$(date +%Y%m%d%H%M)
        cp -p ${CFG_WATCH} ${CFG_WATCH}.bak.$(date +%Y%m%d%H%M)

        # Copy new "default" version of core.conf and autoadd.conf
        cp -p ${CFG_FILE}.new ${CFG_FILE}
        cp -p ${CFG_WATCH}.new ${CFG_WATCH}

        # Reset to default installation
        deluge_default_install
    fi
}
