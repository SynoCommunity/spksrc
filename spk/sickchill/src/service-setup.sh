PYTHON_DIR="/usr/local/python3"
GIT_DIR="/usr/local/git"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
HOME="${SYNOPKG_PKGDEST}/var"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
GIT="${GIT_DIR}/bin/git"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
SICKCHILL="${SYNOPKG_PKGDEST}/var/SickChill/SickChill.py"
SC_DATA_DIR="${SYNOPKG_PKGDEST}/var/data"
SC_CFG_FILE="${SC_DATA_DIR}/config.ini"

GROUP="sc-download"

SERVICE_COMMAND="${PYTHON} ${SICKCHILL} --daemon --nolaunch --pidfile ${PID_FILE} --config ${SC_CFG_FILE} --datadir ${SC_DATA_DIR}"

service_preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code ${wizard_fork_url:=git://github.com/SickChill/SickChill.git} ${wizard_fork_branch:=master} > /dev/null 2>&1; then
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
        ${GIT} clone --depth 10 --recursive -q -b ${wizard_fork_branch:=master} ${wizard_fork_url:=git://github.com/SickChill/SickChill.git} ${SYNOPKG_PKGDEST}/var/SickChill > /dev/null 2>&1
    fi
}
