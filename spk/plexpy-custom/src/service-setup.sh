PYTHON_DIR="/usr/local/python3/bin"
GIT_DIR="/usr/local/git/bin"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${GIT_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
GIT="${GIT_DIR}/git"
VIRTUALENV="${PYTHON_DIR}/virtualenv"
PLEXPY="${SYNOPKG_PKGDEST}/var/plexpy/PlexPy.py"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"

SERVICE_COMMAND="${PYTHON} ${PLEXPY} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGDEST}/var/"

GROUP="sc-download"
LEGACY_GROUP="sc-media"


service_preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code ${wizard_fork_url:=git://github.com/Tautulli/Tautulli.git} ${wizard_fork_branch:=master} > /dev/null 2>&1; then
        echo "Incorrect fork"
        exit 1
    fi
}

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG} 2>&1

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Clone the repository
        ${GIT} clone -q -b ${wizard_fork_branch:=master} ${wizard_fork_url:=git://github.com/Tautulli/Tautulli.git} ${SYNOPKG_PKGDEST}/var/plexpy >> ${INST_LOG} 2>&1
    fi

    # Remove legacy user
    # Commands of busybox from spk/python
    delgroup "${USER}" "users" >> ${INST_LOG}
    deluser "${USER}" >> ${INST_LOG}
}
