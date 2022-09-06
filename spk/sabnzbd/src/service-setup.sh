PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

BIN="${SYNOPKG_PKGDEST}/bin"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
SABNZBD="${SYNOPKG_PKGDEST}/share/SABnzbd/SABnzbd.py"
CFG_FILE="${SYNOPKG_PKGVAR}/config.ini"
LANGUAGE="env LANG=en_US.UTF-8"

if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
    GROUP="synocommunity"
else
    GROUP="sc-download"
fi

SERVICE_COMMAND="${LANGUAGE} ${PYTHON} -OO ${SABNZBD} -f ${CFG_FILE} --pidfile ${PID_FILE} -d"

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    # Install wheels
    install_python_wheels

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Edit the configuration according to the wizard
        shared_folder="${wizard_volume:=/volume1}/${wizard_download_dir:=downloads}"
        sed -i -e "s|@shared_folder@|${shared_folder}|g" ${CFG_FILE}
        sed -i -e "s|@script_dir@|${SYNOPKG_PKGVAR}/scripts|g" ${CFG_FILE}

        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
            sed -i -e "s|permissions\s*=.*|permissions = ""|g" ${CFG_FILE}
        fi

        # Create logs directory, otherwise it does not start due to permissions errors
        mkdir -p "$(dirname ${LOG_FILE})"
        install -m 0775 -o ${EFF_USER} -g ${GROUP} -d "${shared_folder}/incomplete"
        install -m 0775 -o ${EFF_USER} -g ${GROUP} -d "${shared_folder}/complete"
        install -m 0775 -o ${EFF_USER} -g ${GROUP} -d "${shared_folder}/watch"
    fi

    # Install nice/ionice
    ${BIN}/busybox --install ${BIN}
}

service_postupgrade ()
{
    if [ -r "${CFG_FILE}" ]; then
        # /usr/local/ migration
        sed -i -e "s|script_dir\s*=\s*/usr/local/sabnzbd/var/scripts|script_dir = ${SYNOPKG_PKGVAR}/scripts|g" ${CFG_FILE}
        mkdir -p "${SYNOPKG_PKGVAR}/scripts"

        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
            # DSM6 -> DSM7 migration
            sed -i -e "s|script_dir\s*=\s*/var/packages/sabnzbd/target/var/scripts|script_dir = ${SYNOPKG_PKGVAR}/scripts|g" ${CFG_FILE}
            sed -i -e "s|permissions\s*=.*|permissions = ""|g" ${CFG_FILE}

            OLD_INCOMPLETE_FOLDER=$(sed -n 's/^download_dir\s*=\s*//p' ${CFG_FILE})
            OLD_WATCH_FOLDER=$(sed -n 's/^dirscan_dir\s*=\s*//p' ${CFG_FILE})

            NEW_INCOMPLETE_FOLDER="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/incomplete"
            NEW_COMPLETE_FOLDER="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/complete"
            NEW_WATCH_FOLDER="${wizard_volume:=/volume1}/${wizard_download_dir:=/downloads}/watch"

            # update folders
            sed -i -e "s|complete_dir\s*=.*|complete_dir = ${NEW_COMPLETE_FOLDER}|g" ${CFG_FILE}
            sed -i -e "s|download_dir\s*=.*|download_dir = ${NEW_INCOMPLETE_FOLDER}|g" ${CFG_FILE}
            sed -i -e "s|dirscan_dir\s*=.*|dirscan_dir = ${NEW_WATCH_FOLDER}|g" ${CFG_FILE}

            shopt -s dotglob # copy hidden folder/files too
            if [ -n "${OLD_INCOMPLETE_FOLDER}" ] &&  [ "$OLD_INCOMPLETE_FOLDER" != "$NEW_INCOMPLETE_FOLDER" ]; then
                mkdir -p "$NEW_INCOMPLETE_FOLDER"
                mv -nv "$OLD_INCOMPLETE_FOLDER"/* "$NEW_INCOMPLETE_FOLDER/"
            fi
            if [ -n "${OLD_WATCH_FOLDER}" ] &&  [ "$OLD_WATCH_FOLDER" != "$NEW_WATCH_FOLDER" ]; then
                mkdir -p "$NEW_WATCH_FOLDER"
                mv -nv "$OLD_WATCH_FOLDER"/* "$NEW_WATCH_FOLDER/"
            fi
            shopt -d dotglob

        else
            # add group (DSM6)
            INCOMPLETE_FOLDER=$(sed -n 's/^download_dir\s*=\s*//p' ${CFG_FILE})
            COMPLETE_FOLDER=$(sed -n 's/^complete_dir\s*=\s*//p' ${CFG_FILE})
            WATCHED_FOLDER=$(sed -n 's/^dirscan_dir\s*=\s*//p' ${CFG_FILE})

            if [ -n "${INCOMPLETE_FOLDER}" ] && [ -d "${INCOMPLETE_FOLDER}" ]; then
                set_syno_permissions "${INCOMPLETE_FOLDER}" "${GROUP}"
            fi
            if [ -n "${COMPLETE_FOLDER}" ] && [ -d "${COMPLETE_FOLDER}" ]; then
                set_syno_permissions "${COMPLETE_FOLDER}" "${GROUP}"
            fi
            if [ -n "${WATCHED_FOLDER}" ] && [ -d "${WATCHED_FOLDER}" ]; then
                set_syno_permissions "${WATCHED_FOLDER}" "${GROUP}"
            fi
        fi
    fi
}
