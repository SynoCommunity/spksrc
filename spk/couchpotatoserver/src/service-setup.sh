PYTHON_DIR="/var/packages/python/target/bin"
GIT_DIR="/var/packages/git/target/bin"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${GIT_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
VIRTUALENV="${PYTHON_DIR}/virtualenv"
COUCHPOTATOSERVER="${SYNOPKG_PKGDEST}/share/CouchPotatoServer/CouchPotato.py"
CFG_FILE="${SYNOPKG_PKGDEST}/var/settings.conf"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

SERVICE_COMMAND="${PYTHON} ${COUCHPOTATOSERVER} --daemon --pid_file ${PID_FILE} --config_file ${CFG_FILE}"

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

