# File Browser service setup

# https://help.synology.com/developer-guide/integrate_dsm/fhs.html
if [ -z "${SYNOPKG_PKGHOME}" ]; then
    SYNOPKG_PKGHOME="${SYNOPKG_PKGVAR}"
fi

export HOME="${SYNOPKG_PKGHOME}"

FILEBROWSER="${SYNOPKG_PKGDEST}/bin/filebrowser"
DATABASE="${SYNOPKG_PKGHOME}/filebrowser.db"

SERVICE_COMMAND="${FILEBROWSER} --address 0.0.0.0 --port ${SERVICE_PORT} --root / --log ${LOG_FILE} --database ${DATABASE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst()
{
    # Only initialize on fresh install, not upgrade
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if [ -n "${wizard_username}" ] && [ -n "${wizard_password}" ]; then
            echo "Initializing File Browser database with provided credentials"

            # Initialize the database with config
            ${FILEBROWSER} config init \
                --database="${DATABASE}" \
                --address=0.0.0.0 \
                --port=${SERVICE_PORT} \
                --root=/ \
                --log="${LOG_FILE}"

            # Add the admin user with provided password
            ${FILEBROWSER} users add "${wizard_username}" "${wizard_password}" \
                --database="${DATABASE}" \
                --perm.admin=true

            echo "File Browser initialized with user: ${wizard_username}"
        fi
    fi
}
