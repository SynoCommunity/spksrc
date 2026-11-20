
# evaluate version dependent path (do it /bin/sh compatible)
for config_dir in ${SYNOPKG_PKGDEST}/lib/rabbitmq_server-*/sbin; do
    RABBITMQ_SBIN=${config_dir}
    break
done

SERVICE_COMMAND="${RABBITMQ_SBIN}/rabbitmq-server"
SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# HOME to place the erlang cookie into
# Use SYNOPKG_PKGVAR so CLI tools can find it
export HOME=${SYNOPKG_PKGVAR}

# Old locations where data may exist from previous versions.
# On DSM 7, target/var is in @appstore while var is in @appdata.
OLD_VAR_PATH="/var/packages/rabbitmq/target/var"
OLD_COOKIE_PATH="/var/packages/rabbitmq/target/.erlang.cookie"

# RabbitMQ 4.3+ requires the Khepri metadata store. Existing 4.2.x
# installations must enable all stable feature flags and finish the
# Mnesia -> Khepri migration before the upgrade can proceed.
RABBITMQ_OLD_TARGET="/var/packages/rabbitmq/target"
RABBITMQ_OLD_SSS="/var/packages/rabbitmq/scripts/start-stop-status"
RABBITMQ_START_TIMEOUT=120
RABBITMQ_CHECK_TIMEOUT=1800
RABBITMQ_BACKUP_SPACE_MARGIN_PERCENT=10
RABBITMQ_BACKUP_SPACE_MARGIN_KB=51200
RABBITMQ_OLD_STARTED=0

rabbitmq_log ()
{
    if type install_log >/dev/null 2>&1; then
        install_log "$@"
    else
        echo "$@"
    fi
}

rabbitmq_old_stop ()
{
    if [ "${RABBITMQ_OLD_STARTED}" = "1" ]; then
        "${RABBITMQ_OLD_SSS}" stop >/dev/null 2>&1 || true
        RABBITMQ_OLD_STARTED=0
    fi
}

validate_preupgrade ()
{
    [ "${SYNOPKG_PKG_STATUS}" = "UPGRADE" ] || return 0

    RABBITMQ_OLD_STARTED=0
    old_version="${SYNOPKG_OLD_PKGVER%%-*}"
    case "${old_version}" in
        4.2.*)
            ;;
        4.3.*|4.4.*)
            return 0
            ;;
        *)
            echo "RabbitMQ ${SYNOPKG_PKGVER} can only be upgraded from RabbitMQ 4.2.x or newer."
            echo "Upgrade to RabbitMQ 4.2.8 first, then retry this upgrade."
            exit 1
            ;;
    esac

    old_sbin="$(ls -d ${RABBITMQ_OLD_TARGET}/lib/rabbitmq_server-*/sbin 2>/dev/null | head -n 1)"
    RABBITMQ_OLD_CTL="${old_sbin}/rabbitmqctl"

    if [ ! -x "${RABBITMQ_OLD_CTL}" ] || [ ! -x "${RABBITMQ_OLD_SSS}" ]; then
        echo "Unable to find the installed RabbitMQ 4.2.x service."
        echo "Please reinstall RabbitMQ 4.2.8 and retry the upgrade."
        exit 1
    fi

    if "${RABBITMQ_OLD_SSS}" status >/dev/null 2>&1; then
        RABBITMQ_OLD_STARTED=1
    else
        "${RABBITMQ_OLD_SSS}" start >/dev/null 2>&1 || {
            echo "Unable to start the installed RabbitMQ 4.2.x service for the upgrade check."
            exit 1
        }
        RABBITMQ_OLD_STARTED=1
    fi

    waited=0
    old_ready=0
    while [ "${waited}" -lt "${RABBITMQ_START_TIMEOUT}" ]; do
        if HOME="${SYNOPKG_PKGVAR}" "${RABBITMQ_OLD_CTL}" \
            --timeout 10 await_startup >/dev/null 2>&1; then
            old_ready=1
            break
        fi
        sleep 2
        waited=$((waited + 2))
    done
    if [ "${old_ready}" != "1" ]; then
        rabbitmq_old_stop
        echo "RabbitMQ did not become ready for the upgrade check."
        exit 1
    fi

    checks="$(HOME="${SYNOPKG_PKGVAR}" "${RABBITMQ_OLD_CTL}" \
        --timeout "${RABBITMQ_CHECK_TIMEOUT}" eval \
        '{map_size(rabbit_feature_flags:list(disabled, stable)) =:= 0, rabbit_khepri:is_enabled()}.' \
        2>/dev/null | tr -d '[:space:]')"
    rabbitmq_old_stop

    if [ "${checks}" != "{true,true}" ]; then
        echo "RabbitMQ 4.4 requires all stable feature flags and the Khepri metadata store."
        echo "Before upgrading, run:"
        echo "  sudo /var/packages/rabbitmq/target/bin/rabbitmqctl enable_feature_flag all"
        echo "Wait for the Mnesia -> Khepri migration to finish, then retry the upgrade."
        exit 1
    fi

    backup_rabbitmq_data
}

# Create a full data-directory backup before the one-way Khepri migration.
backup_rabbitmq_data ()
{
    backup_dir="${SYNOPKG_PKGVAR}/upgrade-backups"
    size_kb="$(du -sk "${SYNOPKG_PKGVAR}" 2>/dev/null | awk '{print $1}')"
    free_kb="$(df -Pk "${SYNOPKG_PKGVAR}" 2>/dev/null | awk 'NR == 2 {print $4}')"

    # Existing backups are excluded from the archive, so do not count them
    # against the space estimate.
    if [ -d "${backup_dir}" ]; then
        backup_dir_kb="$(du -sk "${backup_dir}" 2>/dev/null | awk '{print $1}')"
        size_kb=$((size_kb - backup_dir_kb))
    fi

    if [ -z "${size_kb}" ] || [ -z "${free_kb}" ]; then
        echo "Unable to determine RabbitMQ data size or free disk space."
        exit 1
    fi

    required_kb=$((size_kb + size_kb * RABBITMQ_BACKUP_SPACE_MARGIN_PERCENT / 100 + RABBITMQ_BACKUP_SPACE_MARGIN_KB))
    if [ "${free_kb}" -lt "${required_kb}" ]; then
        echo "Not enough free space to back up the RabbitMQ data directory."
        echo "Data size: ${size_kb} KB, required: ${required_kb} KB, available: ${free_kb} KB."
        echo "Free space or move the RabbitMQ data to a larger volume, then retry the upgrade."
        exit 1
    fi

    mkdir -p "${backup_dir}" || exit 1
    backup_file="${backup_dir}/rabbitmq-data-v${old_version}-$(date +%Y%m%d-%H%M%S).tar.gz"

    rabbitmq_log "Creating RabbitMQ data backup: ${backup_file}"
    if ! tar --exclude='./upgrade-backups' -C "${SYNOPKG_PKGVAR}" -czf "${backup_file}" .; then
        rm -f "${backup_file}"
        echo "Failed to create the RabbitMQ data backup."
        exit 1
    fi

    rabbitmq_log "RabbitMQ data backup created: ${backup_file}"
}

service_save ()
{
    # On DSM 7, SYNOPKG_PKGVAR points to @appdata while target/var is in @appstore
    # Check if paths differ to determine if data migration is needed
    if [ -d "${OLD_VAR_PATH}" ]; then
        OLD_VAR_REAL=$(realpath "${OLD_VAR_PATH}" 2>/dev/null)
        NEW_VAR_REAL=$(realpath "${SYNOPKG_PKGVAR}" 2>/dev/null)
        
        if [ "${OLD_VAR_REAL}" != "${NEW_VAR_REAL}" ]; then
            # Paths differ (DSM 7) - backup entire var directory contents
            # This includes Mnesia database and config files
            $CP "${OLD_VAR_PATH}"/* "${SYNOPKG_TEMP_UPGRADE_FOLDER}/"
            # Mark that we performed a var migration
            touch "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.var_migrated"
        fi
    fi
    
    # Also backup erlang cookie from old HOME location if it exists
    if [ -f "${OLD_COOKIE_PATH}" ]; then
        $CP "${OLD_COOKIE_PATH}" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.erlang.cookie"
    fi
}

service_restore ()
{
    # Restore var directory contents if migration was performed
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.var_migrated" ]; then
        # Restore all backed up var contents to new PKGVAR location
        # Exclude the migration marker file
        for item in "${SYNOPKG_TEMP_UPGRADE_FOLDER}"/*; do
            [ -e "${item}" ] || continue
            basename="$(basename "${item}")"
            [ "${basename}" = ".var_migrated" ] && continue
            $CP "${item}" "${SYNOPKG_PKGVAR}/"
        done
    fi
    
    # Restore erlang cookie to new location if backup exists
    # $CP preserves file attributes so no chmod needed
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.erlang.cookie" ]; then
        $CP "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.erlang.cookie" "${SYNOPKG_PKGVAR}/.erlang.cookie"
    fi
}

service_postinst ()
{
    echo "Set SYS_PREFIX=${SYNOPKG_PKGDEST} in ${RABBITMQ_SBIN}/rabbitmq-defaults"
    sed -i "s%SYS_PREFIX=%SYS_PREFIX=${SYNOPKG_PKGDEST}%g" ${RABBITMQ_SBIN}/rabbitmq-defaults
}
