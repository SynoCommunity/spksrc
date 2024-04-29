# Define python311 binary path
PYTHON_DIR="/var/packages/python311/target/bin"
# Define git binary path
GIT_DIR="/var/packages/git/target/bin"
# Add local bin, virtualenv along with python311 and git to the default PATH
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${GIT_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
GIT="${GIT_DIR}/git"
PLEXPY="${SYNOPKG_PKGVAR}/plexpy/PlexPy.py"
CFG_FILE="${SYNOPKG_PKGVAR}/config.ini"

SERVICE_COMMAND="${PYTHON} ${PLEXPY} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGVAR}"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

validate_preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code ${wizard_fork_url:=https://github.com/Tautulli/Tautulli.git} ${wizard_fork_branch:=master} > /dev/null 2>&1; then
        echo "Incorrect fork"
        exit 1
    fi
}

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Clone the repository
        ${GIT} clone -q -b ${wizard_fork_branch:=master} ${wizard_fork_url:=https://github.com/Tautulli/Tautulli.git} ${SYNOPKG_PKGVAR}/plexpy
    fi
}

