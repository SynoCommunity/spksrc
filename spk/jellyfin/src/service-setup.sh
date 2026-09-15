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
--ffmpeg /var/packages/ffmpeg8/target/bin/ffmpeg"

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

    # Restrict upgrades to 10.11.x and 12.x
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
        12.*)
            # Direct upgrades from 10.10.7 and 10.11.x to 12.0 are supported;
            # database changes prevent rolling back, so back up those paths
            case "$previous" in
                10.10.7|10.11.*)
                    SC_BACKUP_CONFIG=y
                    export SC_BACKUP_CONFIG
                    return 0
                    ;;
                12.*)
                    # Allowed path, but no backup needed
                    return 0
                    ;;
                *)
                    echo "ERROR: Upgrades to Jellyfin 12.x are only supported from 10.10.7, 10.11.x or another 12.x version."
                    echo "Current version: $previous → Target version: $current"
                    echo "Please update to 10.10.7 first, then upgrade to 12.x."
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
        # Skip bulk that Jellyfin transparently regenerates on access:
        # previous rollback archives (sc_backup), transient transcode
        # segments, plus the extracted subtitle and attachment caches.
        # Excludes precede the member list so they apply on GNU and BSD
        # tar alike. Everything with user value — including Jellyfin's
        # own scheduled backups — is kept, so a restore loses nothing
        # the user cannot get back untouched.
        BACKUP_EXCLUDES="--exclude=./sc_backup --exclude=./data/transcodes --exclude=./data/data/subtitles --exclude=./data/data/attachments"
        # shellcheck disable=SC2086
        tar -C "${SYNOPKG_PKGVAR}" ${BACKUP_EXCLUDES} -czf "${archive}" . || { echo "ERROR: tar failed"; return 1; }

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

        # If no backup folder, proceed normally
        [ -d "${sc_backup}" ] || return 0

        # Look for a matching backup file (e.g., jellyfin_backup_v10.11.11_YYYYMMDD.tar.gz).
        # Archives are named with the pre-upgrade version, so match any version
        # (10.10.7, 10.11.x, 12.x, ...) rather than a single one.
        set -- "${sc_backup}/${pkg}_backup_v"*.tar.gz

        # If no matching file found, just continue uninstall
        [ -e "$1" ] || return 0

        # Optional: detect multiple matches (one per past upgrade)
        [ -e "${2-}" ] && { install_log "WARNING: Multiple backups found, using the newest match."; }

        # Prefer the newest match: lexical order is chronological here
        # (v10.10.7 < v10.11.x < v12.x, then YYYYMMDD suffixes)
        for SC_BACKUP_FILE in "$@"; do :; done

        # Valid backup found — mark for restore
        SC_RESTORE_CONFIG=y
        export SC_RESTORE_CONFIG SC_BACKUP_FILE

        # Persist the selection where postuninst can find it. NOTE: this
        # must live inside sc_backup/ (which survives uninstall when data
        # is kept) — DSM wipes temp locations such as @apptemp mid-uninstall.
        printf '%s\n' "${SC_BACKUP_FILE}" > "${sc_backup}/.restore-marker" || {
            echo "ERROR: Could not write marker ${sc_backup}/.restore-marker"
            return 1
        }

        install_log "Backup found: ${SC_BACKUP_FILE}"
        return 0
    fi
}

service_postuninst() {
    # NOTE: restore reads straight from sc_backup/ — never stage via temp
    # dirs here. DSM wipes locations such as @apptemp mid-uninstall, so any
    # staging there is destroyed before this function runs and restores
    # would silently never happen.
    sc_backup="${SYNOPKG_PKGVAR}/sc_backup"
    marker="${sc_backup}/.restore-marker"

    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ "${wizard_restore_data}" = "true" ]; then
        if [ ! -f "${marker}" ]; then
            echo "WARNING: Restore requested but no backup marker found; keeping current data."
            return 0
        fi
        # Read path from marker (written by validate_preuninst)
        IFS= read -r SC_BACKUP_FILE < "${marker}"
        rm -f -- "${marker}"

        if [ ! -f "${SC_BACKUP_FILE}" ]; then
            echo "WARNING: Restore requested but backup archive missing (${SC_BACKUP_FILE}); keeping current data."
            return 0
        fi
        # Integrity-check before touching live data (never destroy the
        # only rollback copy on a corrupt archive)
        if ! tar -tzf "${SC_BACKUP_FILE}" >/dev/null 2>&1; then
            echo "WARNING: Backup archive failed integrity check (${SC_BACKUP_FILE}); keeping current data."
            return 0
        fi

        echo "Restoring backup from ${SC_BACKUP_FILE} → ${SYNOPKG_PKGVAR}"

        # Clear old data but keep sc_backup/ itself (holds this and older
        # rollback archives). find (not glob) also catches dotfiles.
        if [ -d "${SYNOPKG_PKGVAR}" ]; then
            find "${SYNOPKG_PKGVAR}" -mindepth 1 -maxdepth 1 ! -name sc_backup -exec rm -rf {} + || {
                echo "ERROR: Failed to clear ${SYNOPKG_PKGVAR}"
                return 1
            }
        fi

        # Extract backup (copy semantics: the archive stays in sc_backup/)
        tar -xzf "${SC_BACKUP_FILE}" -C "${SYNOPKG_PKGVAR}" || {
            echo "ERROR: Failed to extract backup archive"
            return 1
        }
        echo "Backup restored successfully."
        return 0
    fi
    # No restore requested: drop any stale marker so it cannot misfire later
    rm -f -- "${marker}" 2>/dev/null || true
    return 0
}
