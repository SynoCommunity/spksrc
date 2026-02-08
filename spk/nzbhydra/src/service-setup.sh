PYTHON_DIR="/var/packages/python/target/bin"
GIT_DIR="/var/packages/git/target/bin"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${GIT_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
VIRTUALENV="${PYTHON_DIR}/virtualenv"
NZBHYDRA="${SYNOPKG_PKGDEST}/share/nzbhydra/nzbhydra.py"
DB_FILE="${SYNOPKG_PKGVAR}/nzbhydra.db"
CONF_FILE="${SYNOPKG_PKGVAR}/settings.cfg"

SERVICE_COMMAND="${PYTHON} ${NZBHYDRA} --daemon --nobrowser --database ${DB_FILE} --config ${CONF_FILE} --logfile ${LOG_FILE} --pidfile ${PID_FILE}"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # Remove legacy user
    # Commands of busybox from spk/python
    delgroup "${USER}" "users"
    deluser "${USER}"
}

