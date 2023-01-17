PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
NZBHYDRA="${SYNOPKG_PKGDEST}/share/nzbhydra/nzbhydra.py"
DB_FILE="${SYNOPKG_PKGDEST}/var/nzbhydra.db"
CONF_FILE="${SYNOPKG_PKGDEST}/var/settings.cfg"

SERVICE_COMMAND="${PYTHON} ${NZBHYDRA} --daemon --nobrowser --database ${DB_FILE} --config ${CONF_FILE} --logfile ${LOG_FILE} --pidfile ${PID_FILE}"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG} 2>&1

    # Remove legacy user
    # Commands of busybox from spk/python
    delgroup "${USER}" "users" >> ${INST_LOG}
    deluser "${USER}" >> ${INST_LOG}
}
