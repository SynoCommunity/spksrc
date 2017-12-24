PYTHON_DIR="/usr/local/python"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
SABNZBD="${SYNOPKG_PKGDEST}/share/SABnzbd/SABnzbd.py"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
LANGUAGE="env LANG=en_US.UTF-8"

SERVICE_COMMAND="${LANGUAGE} ${PYTHON} ${SABNZBD} -f ${CFG_FILE} --pidfile ${PID_FILE} -d"

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

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN >> ${INST_LOG}
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}

service_postupgrade ()
{
    # Log step
    echo "service_postupgrade ${SYNOPKG_PKG_STATUS}" >> $INST_LOG

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG}
}

service_preinst ()
{
    echo "service_preinst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_preuninst ()
{
    echo "service_preuninst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_postuninst ()
{
    echo "service_postuninst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_preupgrade ()
{
    echo "service_preupgrade ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

