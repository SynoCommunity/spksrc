GITEA="${SYNOPKG_PKGDEST}/bin/gitea"
CONF_FILE="${SYNOPKG_PKGVAR}/conf.ini"
PATH="/var/packages/git/target/bin:${PATH}"

if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
    SYNOPKG_PKGHOME="${SYNOPKG_PKGDEST}"
fi
ENV="PATH=${PATH} HOME=${SYNOPKG_PKGHOME}"

SERVICE_COMMAND="env ${ENV} ${GITEA} web --port ${SERVICE_PORT} --pid ${PID_FILE}"
SVC_BACKGROUND=y

service_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
        SHARED_FOLDER="${wizard_volume}/${wizard_gitea_dir}"
        if [ ! -d "${SHARED_FOLDER}" ]; then
            mkdir -p "${SHARED_FOLDER}" || {
                echo "Failed to create directory \"${SHARED_FOLDER}\"."
                exit 1
            }
        fi
        set_syno_permissions "${SHARED_FOLDER}" "${EFF_USER}"
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        SHARED_FOLDER="${wizard_volume}/${wizard_gitea_dir}"
        IP=$(ip route get 1 | awk '{print $(NF);exit}')
        # Default configuration with shared folder
        {
            echo "[repository]"
            echo "ROOT = ${SHARED_FOLDER}/gitea-repositories"
            echo "[server]"
            echo "LFS_CONTENT_PATH = ${SHARED_FOLDER}/lfs"
            echo "SSH_DOMAIN = ${IP:=localhost}"
            echo "DOMAIN = ${IP:=localhost}"
            echo "ROOT_URL = http://${IP:=localhost}:${SERVICE_PORT}/"
        } > "$CONF_FILE"
    fi
}
