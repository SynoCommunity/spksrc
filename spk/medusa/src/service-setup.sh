PYTHON_DIR="/usr/local/python3"
GIT_DIR="/usr/local/git"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
HOME="${SYNOPKG_PKGDEST}/var"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
GIT="${GIT_DIR}/bin/git"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
MEDUSA="${SYNOPKG_PKGDEST}/var/Medusa/start.py"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"
LANG="en_US.UTF-8"

GIT_BRANCH="master"
GIT_URL="git://github.com/pymedusa/Medusa.git"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

SERVICE_COMMAND="${PYTHON} ${MEDUSA} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGDEST}/var/"

service_preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code $GIT_URL $GIT_BRANCH > /dev/null 2>&1; then
        echo "Incorrect fork"
        exit 1
    fi
}

service_prestart ()
{
    # Fixes sys.getfilesystemencoding returning ascii
    export LANG=${LANG} 
}

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Clone the repository
        ${GIT} clone --depth 10 --recursive -q -b $GIT_BRANCH $GIT_URL ${SYNOPKG_PKGDEST}/var/Medusa > /dev/null 2>&1
        cp ${SYNOPKG_PKGDEST}/var/Medusa/autoProcessTV/autoProcessTV.cfg.sample ${SYNOPKG_PKGDEST}/var/Medusa/autoProcessTV/autoProcessTV.cfg
    fi

    # If nessecary, add user also to the old group before removing it
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "${LEGACY_GROUP}"

    # Remove legacy user
    # Commands of busybox from spk/python
    delgroup "${USER}" "users" >> ${INST_LOG}
    deluser "${USER}" >> ${INST_LOG}
}
