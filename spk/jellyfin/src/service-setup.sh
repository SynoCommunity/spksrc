# configure font variables
export FONTCONFIG_PATH="${SYNOPKG_PKGVAR}/fonts"
export XDG_CACHE_HOME="${SYNOPKG_PKGVAR}/fonts"
export XDG_CONFIG_HOME="${SYNOPKG_PKGDEST}/share/dejavu"
export XDG_DATA_HOME="${SYNOPKG_PKGDEST}/share/dejavu"

JELLYFIN_ARGS="--service \
--package-name synology \
-d ${SYNOPKG_PKGVAR}/data \
-C ${SYNOPKG_PKGVAR}/cache \
-c ${SYNOPKG_PKGVAR}/config \
-l ${SYNOPKG_PKGVAR}/log \
-w ${SYNOPKG_PKGDEST}/web \
--ffmpeg /var/packages/ffmpeg7/target/bin/ffmpeg"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/share/jellyfin ${JELLYFIN_ARGS}"

SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst() {
    if [ "$SYNOPKG_DSM_VERSION_MAJOR" -ge 7 ]; then
        mkdir -p --mode=0777 "${SYNOPKG_PKGVAR}/data/transcodes"
    fi
}

validate_preupgrade() {
    # Extract version numbers (strip build suffix, e.g. 10.11.0-1 → 10.11.0)
    previous="${SYNOPKG_OLD_PKGVER%%-*}"
    current="${SYNOPKG_PKGVER%%-*}"

    # Restrict upgrades to 10.11.x
    case "$current" in
        10.11.*)
            case "$previous" in
                10.10.7)
                    # Only this path needs a backup
                    SC_BACKUP_CONFIG=y
                    export SC_BACKUP_CONFIG
                    return 0
                    ;;
                10.11.*)
                    # Allowed path, but no backup needed
                    return 0
                    ;;
                *)
                    echo "ERROR: Upgrades to Jellyfin 10.11.x are only supported from 10.10.7 or another 10.11.x version."
                    echo "Current version: $previous → Target version: $current"
                    echo "Please update to 10.10.7 first, then upgrade to 10.11.x."
                    exit 1
                    ;;
            esac
            ;;
        *)
            # All other upgrade targets allowed
            return 0
            ;;
    esac
}

service_save() {
    if [ "$SC_BACKUP_CONFIG" = "y" ]; then
        prev="${SYNOPKG_OLD_PKGVER%%-*}"
        ts="$(date +%Y%m%d)"
        archive="${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}_backup_v${prev}_${ts}.tar.gz"
        marker="${SYNOPKG_TEMP_UPGRADE_FOLDER}/.backupfile"

        # Permissions checks
        [ -r "${SYNOPKG_PKGVAR}" ] || { echo "ERROR: Not readable: ${SYNOPKG_PKGVAR}"; return 1; }
        [ -w "${SYNOPKG_TEMP_UPGRADE_FOLDER}" ] || { echo "ERROR: Not writable: ${SYNOPKG_TEMP_UPGRADE_FOLDER}"; return 1; }

        echo "Backing up ${SYNOPKG_PKGNAME} data → ${archive}"
        tar -C "${SYNOPKG_PKGVAR}" -czf "${archive}" . || { echo "ERROR: tar failed"; return 1; }

        SC_BACKUP_FILE="${archive}"
        printf '%s\n' "${SC_BACKUP_FILE}" > "${marker}" || { echo "ERROR: Could not write marker ${marker}"; return 1; }
        echo "Backup created: ${SC_BACKUP_FILE}"
    fi
    return 0
}

service_restore() {
    marker="${SYNOPKG_TEMP_UPGRADE_FOLDER}/.backupfile"
    if [ -f "${marker}" ]; then
        # Read path from marker
        IFS= read -r SC_BACKUP_FILE < "${marker}"
        if [ -f "${SC_BACKUP_FILE}" ]; then
            dest="${SYNOPKG_PKGVAR}/sc_backup"

            # Need to write into package var dir
            [ -w "${SYNOPKG_PKGVAR}" ] || { echo "ERROR: Cannot write to ${SYNOPKG_PKGVAR}"; return 1; }

            mkdir -p "${dest}" || { echo "ERROR: Failed to create ${dest}"; return 1; }
            echo "Preserving backup archive → ${dest}/$(basename "${SC_BACKUP_FILE}")"
            mv -f -- "${SC_BACKUP_FILE}" "${dest}/" || { echo "ERROR: Failed to move backup archive"; return 1; }

            # Clean up the marker now that we’ve moved it
            rm -f -- "${marker}"
        fi
    fi
    return 0
}

validate_preuninst() {
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        sc_backup="${SYNOPKG_PKGVAR}/sc_backup"
        pkg="${SYNOPKG_PKGNAME:-jellyfin}"
        expected_prefix="${pkg}_backup_v10.10.7_"

        # If no backup folder, proceed normally
        [ -d "${sc_backup}" ] || return 0

        # Look for a matching backup file (e.g., jellyfin_backup_v10.10.7_YYYYMMDD.tar.gz)
        set -- "${sc_backup}/${expected_prefix}"*.tar.gz

        # If no matching file found, just continue uninstall
        [ -e "$1" ] || return 0

        # Optional: detect multiple matches
        [ -e "${2-}" ] && { install_log "WARNING: Multiple backups found, using the first match."; }

        # Valid backup found — mark for restore
        SC_RESTORE_CONFIG=y
        SC_BACKUP_FILE="$1"
        export SC_RESTORE_CONFIG SC_BACKUP_FILE

        install_log "Backup found: ${SC_BACKUP_FILE}"
        return 0
    fi
}

service_preuninst() {
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ "${wizard_restore_data}" = "true" ]; then
        if [ "$SC_RESTORE_CONFIG" = "y" ] && [ -f "$SC_BACKUP_FILE" ]; then
            pkg="${SYNOPKG_PKGNAME:-jellyfin}"
            SC_TEMP_FOLDER="/volume1/@tmp"
            SC_TEMP_UNINSTALL_FOLDER="${SC_TEMP_FOLDER}/${pkg}.tmp"
            marker="${SC_TEMP_UNINSTALL_FOLDER}/.backupfile"

            # Ensure temp dir is writable
            [ -w "${SC_TEMP_FOLDER}" ] || { echo "ERROR: Not writable: ${SC_TEMP_FOLDER}"; return 1; }

            mkdir -p "${SC_TEMP_UNINSTALL_FOLDER}" || {
                echo "ERROR: Failed to create ${SC_TEMP_UNINSTALL_FOLDER}"; return 1; }

            base="$(basename "$SC_BACKUP_FILE")"
            new_path="${SC_TEMP_UNINSTALL_FOLDER}/${base}"

            echo "Staging backup → ${new_path}"
            mv -f -- "$SC_BACKUP_FILE" "$new_path" || {
                echo "ERROR: Failed to move backup to temp location"; return 1; }

            # Persist the staged path for post-uninstall/restore steps
            printf '%s\n' "$new_path" > "${marker}" || {
                echo "ERROR: Could not write marker ${marker}"; return 1; }
        fi
        return 0
    fi
}

service_postuninst() {
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ "${wizard_restore_data}" = "true" ]; then
        pkg="${SYNOPKG_PKGNAME:-jellyfin}"
        SC_TEMP_FOLDER="/volume1/@tmp"
        SC_TEMP_UNINSTALL_FOLDER="${SC_TEMP_FOLDER}/${pkg}.tmp"
        marker="${SC_TEMP_UNINSTALL_FOLDER}/.backupfile"

        if [ -f "${marker}" ]; then
            # Read path from marker
            IFS= read -r SC_BACKUP_FILE < "${marker}"

            if [ -f "${SC_BACKUP_FILE}" ]; then
                echo "Restoring backup from ${SC_BACKUP_FILE} → ${SYNOPKG_PKGVAR}"

                # Clear old data safely
                if [ -d "${SYNOPKG_PKGVAR}" ]; then
                    rm -rf "${SYNOPKG_PKGVAR:?}/"* || {
                        echo "ERROR: Failed to clear ${SYNOPKG_PKGVAR}"
                        return 1
                    }
                fi

                # Extract backup
                tar -xzf "${SC_BACKUP_FILE}" -C "${SYNOPKG_PKGVAR}" || {
                    echo "ERROR: Failed to extract backup archive"
                    return 1
                }

                # Clean up temp uninstall folder
                rm -rf -- "${SC_TEMP_UNINSTALL_FOLDER}"
                echo "Backup restored successfully."
            fi
        fi
        return 0
    fi
}
