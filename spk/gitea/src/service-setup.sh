GITEA="${SYNOPKG_PKGDEST}/bin/gitea"
CFG_FILE="${SYNOPKG_PKGVAR}/conf.ini"
PATH="/var/packages/git/target/bin:${PATH}"

if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
    SYNOPKG_PKGHOME="${SYNOPKG_PKGVAR}"
fi

ENV="PATH=${PATH} HOME=${SYNOPKG_PKGHOME}"

SERVICE_COMMAND="env ${ENV} ${GITEA} web --port ${SERVICE_PORT} --config ${CFG_FILE} --pid ${PID_FILE}"
SVC_BACKGROUND=y

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        IP=$(ip route get 1 | awk '{print $(NF);exit}')

        sed -i -e "s|@share_path@|${SHARE_PATH}|g" ${CFG_FILE}
        sed -i -e "s|@appdata_path@|${SYNOPKG_PKGVAR}|g" ${CFG_FILE}
        sed -i -e "s|@ip_address@|${IP:=localhost}|g" ${CFG_FILE}
        sed -i -e "s|@service_port@|${SERVICE_PORT}|g" ${CFG_FILE}
    fi
    # Relocate data paths written by previous versions into the wipe zone
    # (@appstore, removed on every upgrade) to persistent storage. Only
    # our own old default is rewritten; custom user paths are untouched,
    # and a second run is a no-op. The old prefix is derived from the
    # install location so installs on any volume are covered.
    sed -i -e "s|${SYNOPKG_PKGDEST}/bin/data|${SYNOPKG_PKGVAR}/data|g" ${CFG_FILE}
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

# service_preupgrade runs from the new package's scripts before the old
# install is removed (verified on DSM 7.1). Rescue AppData written to the
# old location inside @appstore (wiped later in this upgrade) into
# persistent storage, where the config now points.
service_preupgrade ()
{
    OLD_DATA_DIR="${SYNOPKG_PKGDEST}/bin/data"
    NEW_DATA_DIR="${SYNOPKG_PKGVAR}/data"
    if [ -d "${OLD_DATA_DIR}" ]; then
        if [ -d "${NEW_DATA_DIR}" ]; then
            echo "AppData already present at ${NEW_DATA_DIR}, leaving it in place"
        else
            echo "Migrating AppData from ${OLD_DATA_DIR} to ${NEW_DATA_DIR}"
            mv "${OLD_DATA_DIR}" "${NEW_DATA_DIR}"
        fi
    fi
    return 0
}
