PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
HOME="${SYNOPKG_PKGDEST}/var"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
GIT="${GIT_DIR}/bin/git"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
TAUTULLI="${SYNOPKG_PKGDEST}/var/TAUTULLI/Tautulli.py"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"

SERVICE_COMMAND="${PYTHON} ${TAUTULLI} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGDEST}/var/"

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
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Clone the repository
        ${GIT} clone --depth 10 --recursive -q -b ${wizard_fork_branch:=master} ${wizard_fork_url:=git://github.com/Tautulli/Tautulli.git} ${SYNOPKG_PKGDEST}/var/TAUTULLI > /dev/null 2>&1
    fi
}
