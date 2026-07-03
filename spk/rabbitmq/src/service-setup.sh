
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
