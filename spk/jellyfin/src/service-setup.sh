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

if [ "$SYNOPKG_DSM_VERSION_MAJOR" -lt 7 ]; then
    GROUP=sc-media
fi

service_postinst ()
{
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
