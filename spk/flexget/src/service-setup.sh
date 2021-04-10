PYTHON_DIR="/var/packages/python3/target/bin"
VIRTUALENV="${PYTHON_DIR}/python3 -m venv"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

CONFIG_FILE="${SYNOPKG_PKGDEST}/var/config.yml"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/flexget -c ${CONFIG_FILE} --logfile ${LOG_FILE} daemon start"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_CWD="${SYNOPKG_PKGDEST}/var/"
HOME="${SYNOPKG_PKGDEST}/var/"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # Install the wheels
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index --force-reinstall --find-links ${wheelhouse} ${wheelhouse}/*.whl

    # Copying "config.yml" file to the "var/" folder
    install -m 755 -d ${SYNOPKG_PKGDEST}/var
    install -m 644 ${SYNOPKG_PKGDEST}/share/config.yml ${SYNOPKG_PKGDEST}/var
}

