BIN="${SYNOPKG_PKGDEST}/bin"
PYTHON_DIR="/var/packages/python38/target/bin"
PATH="${BIN}:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/python3 -m venv"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
SABNZBD="${SYNOPKG_PKGDEST}/share/SABnzbd/SABnzbd.py"
CFG_FILE="${SYNOPKG_PKGVAR}/config.ini"
LANGUAGE="env LANG=en_US.UTF-8"

GROUP="sc-download"

SERVICE_COMMAND="${LANGUAGE} ${PYTHON} -OO ${SABNZBD} -f ${CFG_FILE} --pidfile ${PID_FILE} -d"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # Install wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Edit the configuration according to the wizard
        sed -i -e "s|@download_dir@|${wizard_volume:=/volume1}/${wizard_download_dir:=downloads}|g" ${CFG_FILE}
        sed -i -e "s|@script_dir@|${SYNOPKG_PKGVAR}/scripts|g" ${CFG_FILE}
    fi

    # Create logs directory, otherwise it does not start due to permissions errors
    mkdir -p "$(dirname ${LOG_FILE})"

    # Install nice/ionice
    ${BIN}/busybox --install ${BIN}
}

service_postupgrade ()
{
    if [ -r "${CFG_FILE}" ]; then
        # DSM6 -> DSM7 migration
        sed -i -e "s|script_dir\s*=\s*/usr/local/sabnzbd/var/scripts|script_dir = ${SYNOPKG_PKGVAR}/scripts|g" ${CFG_FILE}
        if [ "/var/packages/sabnzbd/target/var" != "${SYNOPKG_PKGVAR}" ]; then
            sed -i -e "s|script_dir\s*=\s*/var/packages/sabnzbd/target/var/scripts|script_dir = ${SYNOPKG_PKGVAR}/scripts|g" ${CFG_FILE}
        fi
        # update download folder from wizard (wizard is used to add the package user to the shared folder)
        sed -i -e "s|download_dir\s*=.*|download_dir = ${wizard_volume:=/volume1}/${wizard_download_dir:=downloads}|g" ${CFG_FILE}

        # add group (DSM6)
        INCOMPLETE_FOLDER=$(sed -n 's/^download_dir[ ]*=[ ]*//p' ${CFG_FILE})
        COMPLETE_FOLDER=$(sed -n 's/^complete_dir[ ]*=[ ]*//p' ${CFG_FILE})
        WATCHED_FOLDER=$(sed -n 's/^dirscan_dir[ ]*=[ ]*//p' ${CFG_FILE})

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
}
