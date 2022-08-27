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

if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    GROUP="sc-download"
fi

deluge_default_install ()
{
    # Edit the configuration according to the wizard
    shared_folder="${wizard_volume:=/volume1}/${wizard_download_dir:=downloads}"
    sed -i -e "s|@shared_folder@|${shared_folder}|g" ${CFG_FILE}
    sed -i -e "s|@script_dir@|${SYNOPKG_PKGVAR}/scripts|g" ${CFG_FILE}

    # Create download directories
    mkdir -p -m 0775 "${shared_folder}/incomplete"
    mkdir -p -m 0775 "${shared_folder}/complete"
    mkdir -p -m 0775 "${shared_folder}/watch"

    # Edit the configuration files according to the wizard
    for cfg_file in "${CFG_FILE} ${CFG_WATCH}"; do
        # Default download directory
        sed -i -e "s|@download_dir@|${shared_folder}/incomplete|g" ${cfg_file}
        # Complete directory enabled
        sed -i -e "s|@complete_dir_enabled@|true|g" ${cfg_file}
        sed -i -e "s|@complete_dir@|${shared_folder}/complete|g" ${cfg_file}
    done
    # Watch directory
    sed -i -e "s|\"enabled_plugins\": \[\],|\"enabled_plugins\": \[\n        \"AutoAdd\"\n    \], \n|g" ${CFG_FILE}
    sed -i -e "s|@watch_dir@|${shared_folder}/watch|g" ${CFG_WATCH}
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
        OLD_INCOMPLETE_FOLDER=`sed -n 's/.*"download_location"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_FILE}`
        OLD_COMPLETE_FOLDER=`sed -n 's/.*"move_completed_path"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_FILE}`
        OLD_WATCH_FOLDER=`sed -n 's/.*"autoadd_location"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_FILE}`
        #
        NEW_INCOMPLETE_FOLDER="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/incomplete"
        NEW_COMPLETE_FOLDER="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/complete"
        NEW_WATCH_FOLDER="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/watch"

        # Older versions of Deluge on DSM <= 6 must
        # be updated using a newer configuration

        # Backup current old version of core.conf and autoadd.conf
        cp -p ${CFG_FILE} ${CFG_FILE}.bak.$(date +%Y%m%d%H%M)
        cp -p ${CFG_WATCH} ${CFG_WATCH}.bak.$(date +%Y%m%d%H%M)

        # Copy new "default" version of core.conf
        cp -p ${CFG_FILE}.new ${CFG_FILE}
        cp -p ${CFG_WATCH}.new ${CFG_WATCH}

        # Reset to default installation
        deluge_default_install

        # add group (DSM6)
        if [ -n "${NEW_INCOMPLETE_FOLDER}" ] && [ -d "${NEW_INCOMPLETE_FOLDER}" ]; then
            set_syno_permissions "${NEW_INCOMPLETE_FOLDER}" "${GROUP}"
        fi
        if [ -n "${NEW_COMPLETE_FOLDER}" ] && [ -d "${NEW_COMPLETE_FOLDER}" ]; then
            set_syno_permissions "${NEW_COMPLETE_FOLDER}" "${GROUP}"
        fi
        if [ -n "${NEW_WATCHED_FOLDER}" ] && [ -d "${NEW_WATCHED_FOLDER}" ]; then
            set_syno_permissions "${NEW_WATCHED_FOLDER}" "${GROUP}"
        fi

        # Migrate data to the new download paths except
        # already completed files as may be large volume
        shopt -s dotglob # copy hidden folder/files too
        if [ -n "${OLD_INCOMPLETE_FOLDER}" ] \
             && [ "$OLD_INCOMPLETE_FOLDER" != "$NEW_INCOMPLETE_FOLDER" ] \
             && [ "$OLD_INCOMPLETE_FOLDER" != "$OLD_COMPLETE_FOLDER" ]; then
            mkdir -p "$NEW_INCOMPLETE_FOLDER"
            echo "mv -nv $OLD_INCOMPLETE_FOLDER/* $NEW_INCOMPLETE_FOLDER/"
            #mv -nv "$OLD_INCOMPLETE_FOLDER"/* "$NEW_INCOMPLETE_FOLDER/"
        fi
        if [ -n "${OLD_WATCH_FOLDER}" ] && [ "$OLD_WATCH_FOLDER" != "$NEW_WATCH_FOLDER" ]; then
            mkdir -p "$NEW_WATCH_FOLDER"
            echo "mv -nv $OLD_WATCH_FOLDER/* $NEW_WATCH_FOLDER"
            #mv -nv "$OLD_WATCH_FOLDER"/* "$NEW_WATCH_FOLDER/"
        fi
        shopt -u dotglob
    fi
}
