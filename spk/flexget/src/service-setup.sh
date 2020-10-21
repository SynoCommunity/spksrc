PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}/bin:${PATH}"

CONFIG_FILE="${SYNOPKG_PKGDEST}/var/config.yml"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/flexget -c ${CONFIG_FILE} --logfile ${LOG_FILE} daemon start"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_CWD="${SYNOPKG_PKGDEST}/var/"
HOME="${SYNOPKG_PKGDEST}/var/"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install the wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    # Copying "config.yml" file to the "var/" folder
    install -m 755 -d ${SYNOPKG_PKGDEST}/var
    install -m 644 ${SYNOPKG_PKGDEST}/share/config.yml ${SYNOPKG_PKGDEST}/var
}
