PYTHON_DIR="/usr/local/python"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
SABNZBD="${SYNOPKG_PKGDEST}/share/SABnzbd/SABnzbd.py"
LOG_FILE="${SYNOPKG_PKGDEST}/var/logs/sabnzbd.log"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"
LANGUAGE="env LANG=en_US.UTF-8"

GROUP="sc-download"

SERVICE_COMMAND="${LANGUAGE} ${PYTHON} ${SABNZBD} -f ${CFG_FILE} --pidfile ${PID_FILE} -d"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG}

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Edit the configuration according to the wizard
        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" ${CFG_FILE}
    fi

    # Create logs directory, otherwise it might not start
    mkdir "$(dirname ${LOG_FILE})" >> ${INST_LOG} 2>&1

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN >> ${INST_LOG}
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}

service_postupgrade ()
{
    # Needed to force correct permissions, during update
    # Extract the right paths from config file
    if [ -r "${CFG_FILE}" ]; then
        INCOMPLETE_FOLDER=`sed -n 's/^download_dir[ ]*=[ ]*//p' ${CFG_FILE}`
        COMPLETE_FOLDER= `sed -n 's/^complete_dir[ ]*=[ ]*//p' ${CFG_FILE}`
        WATCHED_FOLDER=`sed -n 's/^dirscan_dir[ ]*=[ ]*//p' ${CFG_FILE}`

        # Apply permissions
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
