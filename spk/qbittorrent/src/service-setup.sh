# qBittorrent service setup

QBITTORRENT="${SYNOPKG_PKGDEST}/bin/qbittorrent-nox"
CFG_FILE="${SYNOPKG_PKGVAR}/qBittorrent/config/qBittorrent.conf"
PWHASH="${SYNOPKG_PKGDEST}/bin/qbt-pwhash"

SERVICE_COMMAND="${QBITTORRENT} --confirm-legal-notice --profile=${SYNOPKG_PKGVAR} --webui-port=${SERVICE_PORT}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

generate_password_hash() {
    "${PWHASH}" "$1"
}

check_folder_access() {
    folder=$1
    if [ ! -w "${folder}" ] || [ ! -r "${folder}" ]; then
        echo "Warning: ${EFF_USER} does not have read/write access to ${folder}"
        echo "Please grant access via DSM Control Panel > Shared Folder > Edit > Permissions"
        return 1
    fi
    return 0
}

service_postinst() {
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Resolve actual share path with correct case (DSM filesystem is case-insensitive)
        share_path=$(realpath "${SHARE_PATH}" 2>/dev/null || echo "${SHARE_PATH}")

        # Create download directories in share
        mkdir -p "${share_path}/complete" 2>/dev/null
        mkdir -p "${share_path}/incomplete" 2>/dev/null

        # Check access to download folders
        check_folder_access "${share_path}/complete"
        check_folder_access "${share_path}/incomplete"

        # Generate password hash using wizard password
        password_hash=$(generate_password_hash "${wizard_password}")

        # Apply substitutions to config template
        sed -i -e "s|@download_dir@|${share_path}/complete|g" \
               -e "s|@incomplete_dir@|${share_path}/incomplete|g" \
               -e "s|@webui_port@|${SERVICE_PORT}|g" \
               -e "s|@username@|${wizard_username}|g" \
               -e "s|@password_hash@|${password_hash}|g" \
               "${CFG_FILE}"

        echo "qBittorrent configured with username: ${wizard_username}"
        echo "Downloads: ${share_path}/complete"
    fi
}

service_restore() {
    # Add Python path for search functionality if not already configured
    if ! grep -q 'pythonExecutablePath' "${CFG_FILE}" 2>/dev/null; then
        if grep -q '^\[Preferences\]' "${CFG_FILE}"; then
            sed -i '/^\[Preferences\]/a Search\\pythonExecutablePath=/var/packages/python312/target/bin/python3' "${CFG_FILE}"
            echo "Added Python 3.12 path for search functionality"
        fi
    fi
}
