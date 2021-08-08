
# no shebang, this file is included by following scripts
# - installer
# - start-stop-status

PYTHON_DIR="/var/packages/python38/target/bin"
VIRTUALENV="${PYTHON_DIR}/python3 -m venv"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

CONFIG_DIR="${SYNOPKG_PKGVAR}/config"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/hass -v --config ${CONFIG_DIR} --pid-file ${PID_FILE} --log-file ${LOG_FILE} --daemon"
SVC_CWD="${SYNOPKG_PKGVAR}"
HOME="${SYNOPKG_PKGVAR}"


service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env
    
    # ensure current pip (>= 20.3)
    # older versions with old dependency resolver will complain about double dependencies while
    # install is done with local *.whl files and requirements from the index.
    ${SYNOPKG_PKGDEST}/env/bin/python3 -m pip install --upgrade pip

    echo "Install packages from wheels"
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-input --no-index ${wheelhouse}/*.whl
    
    echo "Install packages from index"
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-input --requirement ${SYNOPKG_PKGVAR}/postinst_requirements.txt

    mkdir -p "${CONFIG_DIR}"
}

service_preupgrade ()
{
    # migrate configuration
    # move config folder from DSM<7 to DSM7 destination
    OLD_CONFIG_DIR="${SYNOPKG_PKGDEST}/var/config"
    if [ -d "${OLD_CONFIG_DIR}" ]; then
        # on DSM<7 "${SYNOPKG_PKGDEST}/var" is the same folder as "${SYNOPKG_PKGVAR}"
        if [ "$(realpath ${OLD_CONFIG_DIR})" != "$(realpath ${CONFIG_DIR})" ]; then
            echo "Move configuration from ${OLD_CONFIG_DIR} to ${CONFIG_DIR}"
            mv -f "${OLD_CONFIG_DIR}" "${SYNOPKG_PKGVAR}"
        fi
    fi
}

