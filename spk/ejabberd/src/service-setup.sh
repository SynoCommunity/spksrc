
# During upgrades, SYNOPKG_PKGDEST is the new package being installed,
# which isn't deployed yet. Use the installed location for ejabberdctl.
EJABBERD_CTL="/var/packages/ejabberd/target/bin/ejabberdctl"
# HOME to place the erlang cookie into
export HOME="${SYNOPKG_PKGVAR}"

# Old locations where data may exist from previous versions.
# On DSM 7, target/var is in @appstore while var is in @appdata.
# Use hardcoded installed paths since SYNOPKG_PKGDEST points to the
# new package being installed during upgrades, not the current install.
OLD_VAR_PATH="/var/packages/ejabberd/target/var"
OLD_COOKIE_PATH="/var/packages/ejabberd/target/.erlang.cookie"

CERT_DIR="${SYNOPKG_PKGVAR}/ssl"
CERT_FILE="${CERT_DIR}/server.pem"
OPENSSL="${OPENSSL:-$(command -v openssl 2>/dev/null || true)}"
[ -n "${OPENSSL}" ] || OPENSSL="${SYNOPKG_PKGDEST}/bin/openssl"

get_xmpp_host ()
{
    sed -n '/^hosts:/,/^[^[:space:]]/{
        /^[[:space:]]*-[[:space:]]*/{
            s/^[[:space:]]*-[[:space:]]*//
            s/"//g
            p
            q
        }
    }' "${1:-${SYNOPKG_PKGVAR}/ejabberd.yml}"
}

create_certificate ()
{
    [ -s "${CERT_FILE}" ] && return 0

    cert_host="${wizard_ejabberd_hostname}"
    [ -n "${cert_host}" ] || cert_host="$(get_xmpp_host "${1:-${SYNOPKG_PKGVAR}/ejabberd.yml}")"
    [ -n "${cert_host}" ] || cert_host="localhost"

    if [ -z "${OPENSSL}" ] || [ ! -x "${OPENSSL}" ]; then
        echo "openssl not found; cannot create a TLS certificate for ejabberd." >&2
        return 1
    fi

    mkdir -p "${CERT_DIR}" || return 1
    chmod 700 "${CERT_DIR}" || return 1
    if ! "${OPENSSL}" req -x509 -batch -nodes -newkey rsa:4096 \
            -keyout "${CERT_FILE}" -out "${CERT_FILE}" -days 3650 \
            -subj "/CN=${cert_host}" >/dev/null 2>&1; then
        rm -f "${CERT_FILE}"
        echo "Failed to create a TLS certificate for ejabberd." >&2
        return 1
    fi

    chmod 600 "${CERT_FILE}" || return 1
    if [ -n "${EFF_USER}" ]; then
        chown "${EFF_USER}:${EFF_USER}" "${CERT_FILE}" 2>/dev/null || true
    fi
    echo "Created self-signed certificate for ${cert_host} at ${CERT_FILE}."
    return 0
}

rewrite_config ()
{
    config_file="$1"
    shift
    [ -f "${config_file}" ] || return 0
    if awk "$@" "${config_file}" > "${config_file}.tmp"; then
        mv "${config_file}.tmp" "${config_file}"
    else
        rm -f "${config_file}.tmp"
        return 1
    fi
}

remove_certfiles_placeholder ()
{
    rewrite_config "${1}" '
        /^certfiles:$/ { skip=1; next }
        skip { skip=0; next }
        { print }
    '
}

add_certfiles ()
{
    [ -f "${CONFIG_FILE}" ] || return 0
    grep -q '^certfiles:' "${CONFIG_FILE}" && return 0
    create_certificate "${CONFIG_FILE}" || return 1
    rewrite_config "${CONFIG_FILE}" -v cert="${CERT_FILE}" '
        BEGIN { print "certfiles:"; print "  - " cert; print "" }
        { print }
    '
}

add_ca_file ()
{
    [ -f "${CONFIG_FILE}" ] || return 0
    grep -q '^ca_file:' "${CONFIG_FILE}" && return 0
    rewrite_config "${CONFIG_FILE}" '
        BEGIN { print "ca_file: /etc/ssl/certs/ca-certificates.crt"; print "" }
        { print }
    '
}

add_module ()
{
    module_name="$1"
    [ -f "${CONFIG_FILE}" ] || return 0
    grep -q "^  ${module_name}:" "${CONFIG_FILE}" && return 0
    rewrite_config "${CONFIG_FILE}" -v module="${module_name}" '
        /^modules:/ { print; print "  " module ": {}"; next }
        { print }
    '
}

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
    if [ "${SYNOPKG_PKG_STATUS}" = "UPGRADE" ]; then
        if [ "$SYNOPKG_DSM_VERSION_MAJOR" -lt 7 ]; then
            # provide a copy of the new config files 
            # copy to TMP_DIR that will be restored into var, to 
            # prevent final overwriting by previous versions of *.new files
            for config_file in ejabberdctl.cfg ejabberd.yml inetrc; do
                if [ -f "${SYNOPKG_PKGINST_TEMP_DIR}/var/${config_file}" ]; then
                    echo "install new config file as: ${config_file}.new"
                    $CP "${SYNOPKG_PKGINST_TEMP_DIR}/var/${config_file}" "${TMP_DIR}/${config_file}.new"
                fi
            done
        fi
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Add custom hostname to hosts list (below localhost) if not localhost
        if [ "${wizard_ejabberd_hostname}" != "localhost" ]; then
            sed -e "/^  - localhost$/a\\  - ${wizard_ejabberd_hostname}" -i "${SYNOPKG_PKGVAR}/ejabberd.yml"
        fi
        # Patch ejabberd.yml with admin user from install wizard
        sed -e "s#@@adminuser@@#${wizard_ejabberd_admin_username}@${wizard_ejabberd_hostname}#g" -i "${SYNOPKG_PKGVAR}/ejabberd.yml"

        # Generate the self-signed certificate expected by the default config.
        if create_certificate "${SYNOPKG_PKGVAR}/ejabberd.yml"; then
            sed -e "s#@@certfile@@#${CERT_FILE}#g" -i "${SYNOPKG_PKGVAR}/ejabberd.yml"
        else
            echo "WARNING: continuing without a generated TLS certificate." >&2
            remove_certfiles_placeholder "${SYNOPKG_PKGVAR}/ejabberd.yml"
        fi

        ${EJABBERD_CTL} start
        ${EJABBERD_CTL} started
        
        ${EJABBERD_CTL} register "${wizard_ejabberd_admin_username}" "${wizard_ejabberd_hostname}" "${wizard_ejabberd_admin_password}"
        
        ${EJABBERD_CTL} stop
        ${EJABBERD_CTL} stopped
    fi
}

service_postupgrade ()
{
    CONFIG_FILE="${SYNOPKG_PKGVAR}/ejabberd.yml"

    # Add the certificate generated by 26.09 to configs that predate it.
    add_certfiles

    # Use DSM's CA bundle for outbound TLS verification.
    add_ca_file

    # Add modules introduced in 26.09 to existing configurations.
    add_module mod_s2s_bidi
    add_module mod_adhoc_api

    # Use the URL-encoded host placeholder for HTTP uploads when the default
    # placeholder is still present; leave custom put_url values untouched.
    if [ -f "${CONFIG_FILE}" ]; then
        sed -e 's#put_url: https://@HOST@:5443/upload#put_url: https://@HOST_URL_ENCODE@:5443/upload#' \
            -i "${CONFIG_FILE}"
    fi

    # WebAdmin in ejabberd 24.06+ obtains page data through the API.
    # Older configs lack the permissions used by ejabberd_web_admin.
    if [ -f "${CONFIG_FILE}" ] && ! grep -q '"webadmin commands"' "${CONFIG_FILE}"; then
        rewrite_config "${CONFIG_FILE}" '
            /^api_permissions:/ {
                print
                print "  \"webadmin commands\":"
                print "    from: ejabberd_web_admin"
                print "    who: admin"
                print "    what: \"*\""
                print "  \"adhoc commands\":"
                print "    from: mod_adhoc_api"
                print "    who: admin"
                print "    what: \"*\""
                next
            }
            { print }
        '
    fi

    # Add admin ACL if wizard provided credentials (wizard only shown when ACL not configured)
    if [ -n "${wizard_ejabberd_admin_username}" ] && [ -n "${wizard_ejabberd_hostname}" ]; then
        ADMIN_JID="${wizard_ejabberd_admin_username}@${wizard_ejabberd_hostname}"
        
        # Add admin ACL section if not already configured
        if ! grep -q "^  admin:" "${CONFIG_FILE}" 2>/dev/null; then
            # Add admin ACL section after loopback, before empty line or next section
            rewrite_config "${CONFIG_FILE}" -v admin="${ADMIN_JID}" '
                /^  loopback:/ { in_loopback=1 }
                in_loopback && (/^$/ || /^[^ ]/) {
                    print "  admin:"
                    print "    user:"
                    print "      - \"" admin "\""
                    in_loopback=0
                }
                { print }
            '
        fi
    fi
}
