USER=${SYNOPKG_PKGNAME}
PRIV_PREFIX=sc-
SYNOUSER_PREFIX=svc-
if [ -n "${SYNOPKG_DSM_VERSION_MAJOR}" -a "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 6 ]; then EFF_USER="${SYNOUSER_PREFIX}${USER}"; else EFF_USER="${PRIV_PREFIX}${USER}"; fi
# Service port
SERVICE_PORT=${SYNOPKG_PKGPORT}
# start-stop-status script redirect stdout/stderr to LOG_FILE
LOG_FILE="${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}.log"
# Service command has to deliver its pid into PID_FILE
PID_FILE="${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}.pid"

# Invoke shell function if available
call_func ()
{
    FUNC=$1
    if type "$FUNC" | grep -q 'function' 2>/dev/null; then
        echo "Invoke $FUNC" >> ${INST_LOG}
        eval ${FUNC}
    fi
}

PYTHON_DIR="/usr/local/python3"
GIT_DIR="/usr/local/git"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
HOME="${SYNOPKG_PKGDEST}/var"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
GIT="${GIT_DIR}/bin/git"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
MEDUSA="${SYNOPKG_PKGDEST}/var/Medusa/start.py"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"
FORK_URL="https://github.com/pymedusa/Medusa.git"
BRANCH="master"
CFG_REMOTE_URL="remote_url = ${FORK_URL}"
CFG_WEB_PORT="web_port = ${SYNOPKG_PKGPORT}"

GROUP="sc-download"
LEGACY_GROUP="sc-media"

SERVICE_COMMAND="${PYTHON} ${MEDUSA} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGDEST}/var/"

service_preinst ()
{
  echo 'No service pre-install routine' > ${INST_LOG}
}

service_prestart ()
{
  export LANG=en_US.UTF-8 
}

service_postinst ()
{
  echo "Create a Python3 virtualenv" >> ${INST_LOG}
  ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG} 2>&1
  echo "Clone the repository" >> ${INST_LOG}
  ${GIT} clone --depth 10 --recursive -q -b ${BRANCH} ${FORK_URL} ${SYNOPKG_PKGDEST}/var/Medusa >>  ${INST_LOG} 2>&1 
}

service_preuninst ()
{
  echo 'No service pre-uninstall routine' > ${INST_LOG}
}

service_postuninst ()
{
  echo 'No service pre-uninstall routine' >> ${INST_LOG}
}
service_preugrade ()
{
  echo 'No service pre-upgrade routine' > ${INST_LOG}
}

service_postupgrade ()
{
  echo 'No service post-upgrade routine' >> ${INST_LOG}
}
