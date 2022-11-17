
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
    echo "Create folder: ${CONFIG_DIR}"
    mkdir -p "${CONFIG_DIR}"

    echo ${separator}
    echo "Install Python virtual environment"
    install_python_virtualenv

    echo ${separator}
    echo "Install packages from wheels"
    pip install --no-deps --no-input --no-index ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl

    echo ${separator}
    echo "Install pure python packages from index"
    pip install --no-deps --no-input \
                --requirement ${SYNOPKG_PKGDEST}/share/wheelhouse/requirements-pure.txt

    echo ${separator}
    echo "Install packages for homeassistant.components from index"
    pip install --no-deps --no-input \
                --requirement ${SYNOPKG_PKGDEST}/share/postinst_components_requirements.txt

}
