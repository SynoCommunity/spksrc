PYTHON_DIR="/var/packages/python/target/bin"
GIT_DIR="/var/packages/git/target/bin"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${GIT_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
VIRTUALENV="${PYTHON_DIR}/virtualenv"
HEADPHONES="${SYNOPKG_PKGDEST}/share/Headphones/Headphones.py"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"

SERVICE_COMMAND="${PYTHON} ${HEADPHONES} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGDEST}/var/"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # If nessecary, add user also to the old group
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "${LEGACY_GROUP}"

    # Remove legacy user
    # Commands of busybox from spk/python
    delgroup "${USER}" "users"
    deluser "${USER}"
}

