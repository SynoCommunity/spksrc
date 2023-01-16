
# service setup: content is included by following scripts
# - installer
# - start-stop-status

PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

CONFIG_DIR="${SYNOPKG_PKGVAR}/config"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/hass -v --config ${CONFIG_DIR} --pid-file ${PID_FILE} --log-file ${LOG_FILE} --daemon"
SVC_CWD="${SYNOPKG_PKGVAR}"
HOME="${SYNOPKG_PKGVAR}"


service_postinst ()
{
    separator="===================================================="

    echo ${separator}
    install_python_virtualenv

    echo ${separator}
    install_python_wheels

    echo ${separator}
    echo "Install packages for default_config from index"
    pip install --no-deps --no-input \
                --cache-dir ${SYNOPKG_PKGVAR}/pip-cache \
                --requirement ${SYNOPKG_PKGDEST}/share/postinst_default_config_requirements.txt

    echo ${separator}
    echo "Install packages for homeassistant.components from index"
    pip install --no-deps --no-input \
                --cache-dir ${SYNOPKG_PKGVAR}/pip-cache \
                --requirement ${SYNOPKG_PKGDEST}/share/postinst_components_requirements.txt

    mkdir -p "${CONFIG_DIR}"
}
