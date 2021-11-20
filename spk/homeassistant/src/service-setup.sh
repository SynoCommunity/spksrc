
# service setup: content is included by following scripts
# - installer
# - start-stop-status

PYTHON_DIR="/var/packages/python310/target/bin"
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
    
    separator="===================================================="
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse

    echo ${separator}
    echo "Install packages from wheels"
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-input --no-index ${wheelhouse}/*.whl

    echo ${separator}
    echo "Install packages for default_config from index"
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-input --requirement ${SYNOPKG_PKGDEST}/share/postinst_default_config_requirements.txt

    echo ${separator}
    echo "Install packages for homeassistant.components from index"
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-input --requirement ${SYNOPKG_PKGDEST}/share/postinst_components_requirements.txt

    mkdir -p "${CONFIG_DIR}"
}
