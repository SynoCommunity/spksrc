# no shebang, this file is included by following scripts
# - installer
# - start-stop-status

PYTHON_DIR="/var/packages/python38/target/bin"
VIRTUALENV="${PYTHON_DIR}/python3 -m venv"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

CONFIG_DIR="${SYNOPKG_PKGDEST}/var/config"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/hass -v --config ${CONFIG_DIR} --pid-file ${PID_FILE} --log-file ${LOG_FILE} --daemon"
SVC_CWD="${SYNOPKG_PKGDEST}/var/"
HOME="${SYNOPKG_PKGDEST}/var/"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # Install the wheels
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-input --upgrade --no-index --find-links ${wheelhouse} ${wheelhouse}/*.whl

    mkdir -p "${CONFIG_DIR}"
    # For pip to install pure python module (others have to be provided as wheels in requirement.txt)
    chown -R ${EFF_USER} ${SYNOPKG_PKGDEST}/env
}


# use alternate TMPDIR for service_postinst and start_daemon (start-stop-status)
# /tmp might have <400MB free space
# TMPDIR is supported by pip https://github.com/pypa/pip/issues/4462 ('--build dir' is not supported anymore)
TMPDIR=${SYNOPKG_PKGDEST}/tmp
if [[ ! -e "${TMPDIR}" ]]; then
    mkdir -p "${TMPDIR}"
    chown ${EFF_USER} "${TMPDIR}"
fi
export TMPDIR=${SYNOPKG_PKGDEST}/tmp

