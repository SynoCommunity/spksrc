GITEA="${SYNOPKG_PKGDEST}/bin/gitea"
CONF_FILE="${SYNOPKG_PKGVAR}/conf.ini"
PATH="/var/packages/git/target/bin:${PATH}"

if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
    SYNOPKG_PKGHOME="${SYNOPKG_PKGVAR}"
fi

ENV="PATH=${PATH} HOME=${SYNOPKG_PKGHOME}"

SERVICE_COMMAND="env ${ENV} ${GITEA} web --port ${SERVICE_PORT} --pid ${PID_FILE}"
SVC_BACKGROUND=y

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        IP=$(ip route get 1 | awk '{print $(NF);exit}')

        sed -i -e "s|@share_path@|${SHARE_PATH}|g" ${CFG_FILE}
        sed -i -e "s|@ip_address@|${IP:=localhost}|g" ${CFG_FILE}
        sed -i -e "s|@service_port@|${SERVICE_PORT}|g" ${CFG_FILE}
    fi
}

# service_restore is called by post_upgrade before restoring files from ${TMP_DIR}
service_restore ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # make a copy of the new config file before it gets overwritten by restore
        # overwrite existing *.new files in ${TMP_DIR}/ as all files in ${TMP_DIR}/
        # are restored to ${SYNOPKG_PKGVAR}/
        [ -f "${SYNOPKG_PKGVAR}/conf.ini" ] && cp -f ${SYNOPKG_PKGVAR}/conf.ini ${TMP_DIR}/conf.ini.new
    fi
}