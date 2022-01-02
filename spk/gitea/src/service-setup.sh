
GITEA="${SYNOPKG_PKGDEST}/bin/gitea"
CONF_FILE="${SYNOPKG_PKGVAR}/conf.ini"
ENV="HOME=${SYNOPKG_PKGVAR}"
SERVICE_COMMAND="env ${ENV} ${GITEA} web --port 8418 --pid ${PID_FILE}"
SVC_BACKGROUND=y

service_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        if [ ! -d "${wizard_volume}/${wizard_gitea_dir}" ]; then
            mkdir -p "${wizard_volume}/${wizard_gitea_dir}" || {
                echo "Download directory ${wizard_volume}/${wizard_gitea_dir} does not exist."
                exit 1
            }
        fi
        set_syno_permissions "${wizard_volume}/${wizard_gitea_dir}" "${EFF_USER}"
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        IP=$(ip route get 1 | awk '{print $(NF);exit}')
        # Default configuration with shared folder
        {
            echo "[repository]"
            echo "ROOT = ${wizard_volume:=/volume1}/${wizard_gitea_dir:=git}/gitea-repositories"
            echo "[server]"
            echo "LFS_CONTENT_PATH = ${wizard_volume:=/volume1}/${wizard_gitea_dir:=git}/lfs"
            echo "SSH_DOMAIN = ${IP:=localhost}"
            echo "DOMAIN = ${IP:=localhost}"
            echo "ROOT_URL = http://${IP:=localhost}:8418/"
        } > "$CONF_FILE"
    fi
}
