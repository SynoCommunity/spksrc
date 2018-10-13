PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
GIT="${GIT_DIR}/bin/git"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
LAZYLIBRARIAN="${SYNOPKG_PKGDEST}/var/LazyLibrarian/LazyLibrarian.py"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"
LOG_FILE="${SYNOPKG_PKGDEST}/var/Logs/lazylibrarian.log"

SERVICE_COMMAND="${PYTHON} ${LAZYLIBRARIAN} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGDEST}/var/"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

service_preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code ${wizard_fork_url:=git://github.com/DobyTang/LazyLibrarian.git} ${wizard_fork_branch:=master} > /dev/null 2>&1; then
        echo "Incorrect fork"
        exit 1
    fi
}

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG} 2>&1

    # Clone the repository for new installs or upgrades
    # Upgrades from the old package had the repo in /share/
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] || [ ! -d "${TMP_DIR}/LazyLibrarian" ]; then
        ${GIT} clone -q -b ${wizard_fork_branch:=master} ${wizard_fork_url:=git://github.com/DobyTang/LazyLibrarian.git} ${SYNOPKG_PKGDEST}/var/LazyLibrarian >> ${INST_LOG} 2>&1
    fi

    # If nessecary, add user also to the old group
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "${LEGACY_GROUP}"

    # Create logs directory, otherwise it doesn't start
    mkdir "$(dirname ${LOG_FILE})" >> ${INST_LOG} 2>&1

    # Remove legacy user
    # Commands of busybox from spk/python
    delgroup "${USER}" "users" >> ${INST_LOG}
    deluser "${USER}" >> ${INST_LOG}
}
