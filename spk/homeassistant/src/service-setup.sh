PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}/bin:${PATH}"

CONFIG_DIR="${SYNOPKG_PKGDEST}/var/config"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/hass -v --config ${CONFIG_DIR} --pid-file ${PID_FILE} --log-file ${LOG_FILE} --daemon"
SVC_CWD="${SYNOPKG_PKGDEST}/var/"
HOME="${SYNOPKG_PKGDEST}/var/"

service_postinst ()
{
    # use alternate TMPDIR (as /tmp might have <300MB free space for 'pip install')
    # TMPDIR is supported by pip https://github.com/pypa/pip/issues/4462
    TMPDIR=${SYNOPKG_PKGDEST}/tmp
    mkdir -p "${TMPDIR}"

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install the wheels
    TMPDIR=${SYNOPKG_PKGDEST}/tmp ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    mkdir -p "${CONFIG_DIR}"
    # For pip to install pure python module (others have to be provided as wheels in requirement.txt)
    chown -R ${EFF_USER} ${SYNOPKG_PKGDEST}/env
}
