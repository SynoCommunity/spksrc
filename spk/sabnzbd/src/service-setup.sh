PYTHON_DIR="/usr/local/python"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
SABNZBD="${SYNOPKG_PKGDEST}/share/SABnzbd/SABnzbd.py"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"
UPRGADE_CFG_FILE="${TMP_DIR}/config.ini"
LANGUAGE="env LANG=en_US.UTF-8"

GROUP="sc-download"

SERVICE_COMMAND="${LANGUAGE} ${PYTHON} ${SABNZBD} -f ${CFG_FILE} --pidfile ${PID_FILE} -d"

# Needed to force correct permissions, during update
# Extract the right paths from config file
if [ -r "${UPRGADE_CFG_FILE}" ]; then
    INCOMPLETE_FOLDER=`grep -Po '(?<=download_dir = ).*' ${UPRGADE_CFG_FILE}`
    COMPLETE_FOLDER=`grep -Po '(?<=complete_dir = ).*' ${UPRGADE_CFG_FILE}`
    if [ -n "$(dirname "${INCOMPLETE_FOLDER}")" ]; then
        SHARE_PATH=$(dirname "${INCOMPLETE_FOLDER}")
    fi
fi

set_all_permissions ()
{
    # Fix permissions for EFF_USER and GROUP on DIRNAME
    DIRNAME=$1
    EFF_USER=$2
    GROUP=$3
    echo "Granting '${EFF_USER}' user permissions on ${DIRNAME}" >> ${INST_LOG}
    synoacltool -add "${DIRNAME}" "user:${EFF_USER}:allow:rwxpdDaARWcC-:fd--" >> ${INST_LOG} 2>&1
    echo "Granting '${GROUP}' group permissions on ${DIRNAME}" >> ${INST_LOG}
    synoacltool -add "${DIRNAME}" "group:${GROUP}:allow:rwxpdDaARWcC-:fd--" >> ${INST_LOG} 2>&1
}

service_postinst ()
{
    # Log step
    echo "service_postinst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG}

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Edit the configuration according to the wizard
        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" ${CFG_FILE}
    fi

    # Have to make sure our complete/incomplete dirs have right permissions
    if [ -n "${INCOMPLETE_FOLDER}" ]; then
        set_all_permissions "${INCOMPLETE_FOLDER}" "${EFF_USER}" "${GROUP}"
    fi
    if [ -n "${COMPLETE_FOLDER}" ]; then
        set_all_permissions "${COMPLETE_FOLDER}" "${EFF_USER}" "${GROUP}"
    fi

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN >> ${INST_LOG}
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}
