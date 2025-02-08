PYTHON_DIR="/var/packages/python311/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

BIN="${SYNOPKG_PKGDEST}/bin"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
SABNZBD="${SYNOPKG_PKGDEST}/share/SABnzbd/SABnzbd.py"
CFG_FILE="${SYNOPKG_PKGVAR}/config.ini"
LANGUAGE="env LANG=en_US.UTF-8"

if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
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
        sed -i -e "s|@shared_folder@|${SHARE_PATH}|g" ${CFG_FILE}
        sed -i -e "s|@script_dir@|${SYNOPKG_PKGVAR}/scripts|g" ${CFG_FILE}

        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
            # DSM7: SABnzbd should not set permissions, but let DSM handle it
            sed -i -e "s|permissions\s*=.*|permissions = ""|g" ${CFG_FILE}
        else
            # DSM6: Create folders with right permissions
            # DSM7: Let SABnzbd create them on first start
            install -m 0775 -o ${EFF_USER} -g ${GROUP} -d "${SHARE_PATH}/incomplete"
            install -m 0775 -o ${EFF_USER} -g ${GROUP} -d "${SHARE_PATH}/complete"
            install -m 0775 -o ${EFF_USER} -g ${GROUP} -d "${SHARE_PATH}/watch"

            # Create logs directory, otherwise it does not start due to permissions errors
            mkdir -p "$(dirname ${LOG_FILE})"
        fi
    fi
}
