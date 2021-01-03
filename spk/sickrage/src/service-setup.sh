PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
HOME="${SYNOPKG_PKGVAR}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
GIT="${GIT_DIR}/bin/git"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
SICKRAGE="${SYNOPKG_PKGVAR}/SickRage/SiCKRAGE.py"
LOG_FILE="${SYNOPKG_PKGVAR}/logs/sickrage.log"
CFG_FILE="${SYNOPKG_PKGVAR}/config.ini"
UPGRADE_CFG_FILE="${TMP_DIR}/config.ini"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

SERVICE_COMMAND="${PYTHON} ${SICKRAGE} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGVAR}/"

service_preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code ${wizard_fork_url:=https://git.sickrage.ca/sickrage/sickrage.git} ${wizard_fork_branch:=master} > /dev/null 2>&1; then
        echo "Incorrect fork"
        exit 1
    fi
}

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Clone the repository, install requirements and configure autoProcessTV
    ${GIT} clone --depth 10 --recursive -b ${wizard_fork_branch:=master} ${wizard_fork_url:=https://git.sickrage.ca/sickrage/sickrage.git} ${SYNOPKG_PKGVAR}/SickRage >> ${INST_LOG} 2>&1

    # PIP install requirements.txt
    if [ -f "${SYNOPKG_PKGVAR}/SickRage/requirements.txt" ]; then
        ${SYNOPKG_PKGDEST}/env/bin/pip install -U --build ${SYNOPKG_PKGDEST}/build --force-reinstall -r ${SYNOPKG_PKGVAR}/SickRage/requirements.txt >> ${INST_LOG} 2>&1
    fi

    # Copy scripts
    cp ${SYNOPKG_PKGVAR}/SickRage/sickrage/autoProcessTV/autoProcessTV.cfg.sample ${SYNOPKG_PKGVAR}/SickRage/sickrage/autoProcessTV/autoProcessTV.cfg
    chmod 777 ${SYNOPKG_PKGVAR}/SickRage/sickrage/autoProcessTV
    chmod 600 ${SYNOPKG_PKGVAR}/SickRage/sickrage/autoProcessTV/autoProcessTV.cfg

    # Create logs directory, otherwise it might not start
    mkdir "$(dirname ${LOG_FILE})" >> ${INST_LOG} 2>&1

    # If nessecary, add user also to the old group before removing it
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "${LEGACY_GROUP}"

    # Remove legacy user
    # Commands of busybox from spk/python
    delgroup "${USER}" "users" >> ${INST_LOG}
    deluser "${USER}" >> ${INST_LOG}
}
