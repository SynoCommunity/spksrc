
# service setup: content is included by following scripts
# - installer
# - start-stop-status

PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

CONFIG_DIR="${SYNOPKG_PKGVAR}/config"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/hass -v --config ${CONFIG_DIR} --log-file ${LOG_FILE}"
SVC_WRITE_PID=y
SVC_BACKGROUND=y
SVC_CWD="${SYNOPKG_PKGVAR}"
HOME="${SYNOPKG_PKGVAR}"


service_postinst ()
{
    separator="===================================================="

    echo ${separator}
    install_python_virtualenv

    echo ${separator}
    echo "Install packages from wheels"
    pip install --no-deps --no-input --no-index ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl

    echo ${separator}
    echo "Install pure python packages from index"
    pip install --no-deps --no-input \
                --requirement ${SYNOPKG_PKGDEST}/share/wheelhouse/requirements-pure.txt

    echo ${separator}
    echo "Install packages for default_config from index"
    pip install --no-deps --no-input \
                --cache-dir ${SYNOPKG_PKGVAR}/pip-cache \
                --requirement ${SYNOPKG_PKGDEST}/share/postinst_default_config_requirements.txt
    if [ $? -ne 0 ]; then
        echo "ERROR: default_config installation failed";
        return;
    fi

    echo ${separator}
    echo "Install packages for homeassistant.components from index"
    pip install --no-deps --no-input \
                --cache-dir ${SYNOPKG_PKGVAR}/pip-cache \
                --requirement ${SYNOPKG_PKGDEST}/share/postinst_components_requirements.txt

    mkdir -p "${CONFIG_DIR}"
}
