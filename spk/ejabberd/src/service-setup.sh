
# During upgrades, SYNOPKG_PKGDEST is the new package being installed,
# which isn't deployed yet. Use the installed location for ejabberdctl.
EJABBERD_CTL="/var/packages/ejabberd/target/bin/ejabberdctl"
# HOME to place the erlang cookie into
export HOME=${SYNOPKG_PKGVAR}

# Old locations where data may exist from previous versions.
# On DSM 7, target/var is in @appstore while var is in @appdata.
# Use hardcoded installed paths since SYNOPKG_PKGDEST points to the
# new package being installed during upgrades, not the current install.
OLD_VAR_PATH="/var/packages/ejabberd/target/var"
OLD_COOKIE_PATH="/var/packages/ejabberd/target/.erlang.cookie"

validate_preupgrade ()
{
    # Validate admin account if wizard provided credentials
    if [ -n "${wizard_ejabberd_admin_username}" ] && [ -n "${wizard_ejabberd_hostname}" ]; then
        # Determine HOME path based on where the erlang cookie exists
        # Cookie is in target/ (old HOME location) or var/ (new location)
        if [ -f "${OLD_COOKIE_PATH}" ]; then
            EJABBERD_HOME="/var/packages/ejabberd/target"
        else
            EJABBERD_HOME="${SYNOPKG_PKGVAR}"
        fi
        
        # Start ejabberd temporarily to validate the admin account
        # Service was stopped by the framework before validate_preupgrade runs
        # HOME override needed for erlang to find the cookie file
        HOME="${EJABBERD_HOME}" ${EJABBERD_CTL} start
        HOME="${EJABBERD_HOME}" ${EJABBERD_CTL} started
        
        # Validate admin account exists in database
        # HOME override needed for check_account to find the erlang cookie
        if ! HOME="${EJABBERD_HOME}" ${EJABBERD_CTL} check_account "${wizard_ejabberd_admin_username}" "${wizard_ejabberd_hostname}"; then
            HOME="${EJABBERD_HOME}" ${EJABBERD_CTL} stop
            HOME="${EJABBERD_HOME}" ${EJABBERD_CTL} stopped
            echo "Administrator account '${wizard_ejabberd_admin_username}@${wizard_ejabberd_hostname}' not found in ejabberd database."
            exit 1
        fi
        
        HOME="${EJABBERD_HOME}" ${EJABBERD_CTL} stop
        HOME="${EJABBERD_HOME}" ${EJABBERD_CTL} stopped
    fi
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
            # This includes config files and Mnesia database
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

service_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "UPGRADE" ]; then
        if [ "$SYNOPKG_DSM_VERSION_MAJOR" -lt 7 ]; then
            # provide a copy of the new config files 
            # copy to TMP_DIR that will be restored into var, to 
            # prevent final overwriting by previous versions of *.new files
            for config_file in ejabberdctl.cfg ejabberd.yml inetrc; do
                if [ -f ${SYNOPKG_PKGINST_TEMP_DIR}/var/${config_file} ]; then
                    echo "install new config file as: ${config_file}.new"
                    $CP ${SYNOPKG_PKGINST_TEMP_DIR}/var/${config_file} ${TMP_DIR}/${config_file}.new
                fi
            done
        fi
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Add custom hostname to hosts list (below localhost) if not localhost
        if [ "${wizard_ejabberd_hostname}" != "localhost" ]; then
            sed -e "/^  - localhost$/a\\  - ${wizard_ejabberd_hostname}" -i ${SYNOPKG_PKGVAR}/ejabberd.yml
        fi
        # Patch ejabberd.yml with admin user from install wizard
        sed -e "s#@@adminuser@@#${wizard_ejabberd_admin_username}@${wizard_ejabberd_hostname}#g" -i ${SYNOPKG_PKGVAR}/ejabberd.yml

        ${EJABBERD_CTL} start
        ${EJABBERD_CTL} started
        
        ${EJABBERD_CTL} register "${wizard_ejabberd_admin_username}" "${wizard_ejabberd_hostname}" "${wizard_ejabberd_admin_password}"
        
        ${EJABBERD_CTL} stop
        ${EJABBERD_CTL} stopped
    fi
}

service_postupgrade ()
{
    # Add admin ACL if wizard provided credentials (wizard only shown when ACL not configured)
    if [ -n "${wizard_ejabberd_admin_username}" ] && [ -n "${wizard_ejabberd_hostname}" ]; then
        CONFIG_FILE="${SYNOPKG_PKGVAR}/ejabberd.yml"
        ADMIN_JID="${wizard_ejabberd_admin_username}@${wizard_ejabberd_hostname}"
        
        # Add admin ACL section if not already configured
        if ! grep -q "^  admin:" "${CONFIG_FILE}" 2>/dev/null; then
            # Add admin ACL section after loopback, before empty line or next section
            awk -v admin="${ADMIN_JID}" '
                /^  loopback:/ { in_loopback=1 }
                in_loopback && (/^$/ || /^[^ ]/) {
                    print "  admin:"
                    print "    user:"
                    print "      - \"" admin "\""
                    in_loopback=0
                }
                { print }
            ' "${CONFIG_FILE}" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "${CONFIG_FILE}"
        fi
    fi
}
