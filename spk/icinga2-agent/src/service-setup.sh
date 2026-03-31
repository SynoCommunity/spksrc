# Icinga 2 Agent service configuration

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/icinga2 daemon -c ${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

generate_password ()
{
    head -c 32 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 24
}

validate_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if [ -z "${wizard_master_host}" ]; then
            echo "Master server hostname is required"
            exit 1
        fi
    fi
}

service_postinst ()
{
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icinga2/conf.d"
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icinga2/features-enabled"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2/crash"
    mkdir -p "${SYNOPKG_PKGVAR}/cache/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/lib/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/spool/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/spool/icinga2/perfdata"
    mkdir -p "${SYNOPKG_PKGVAR}/run/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/run/icinga2/cmd"

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        master_host="${wizard_master_host}"
        master_port="${wizard_master_port:-5665}"
        agent_name="${wizard_agent_name:-$(hostname)}"
        plugin_dir="${SYNOPKG_PKGDEST}/target/bin"

        # Fetch master's certificate so we trust the master
        mkdir -p "${SYNOPKG_PKGVAR}/lib/icinga2/certs"
        "${SYNOPKG_PKGDEST}/sbin/icinga2" pki save-cert --host "${master_host}" --port "${master_port}" \
            --trustedcert "${SYNOPKG_PKGVAR}/lib/icinga2/certs/trusted-master.crt" 2>/dev/null || true

        # Run node setup - creates CSR and certs (regardless of success, we use our own config)
        NODE_SETUP_ARGS="--cn ${agent_name}"
        NODE_SETUP_ARGS="${NODE_SETUP_ARGS} --endpoint ${master_host},${master_host},${master_port}"
        NODE_SETUP_ARGS="${NODE_SETUP_ARGS} --zone ${agent_name}"
        NODE_SETUP_ARGS="${NODE_SETUP_ARGS} --parent_zone master"
        NODE_SETUP_ARGS="${NODE_SETUP_ARGS} --parent_host ${master_host}"
        NODE_SETUP_ARGS="${NODE_SETUP_ARGS} --trustedcert ${SYNOPKG_PKGVAR}/lib/icinga2/certs/trusted-master.crt"
        NODE_SETUP_ARGS="${NODE_SETUP_ARGS} --accept-commands --accept-config --disable-confd"

        # Run node setup (for CSR generation) - ignore errors
        "${SYNOPKG_PKGDEST}/sbin/icinga2" node setup ${NODE_SETUP_ARGS} 2>&1 || true

        # Always use our templates for config (not node setup's)
        cp "${SYNOPKG_PKGDEST}/share/templates/icinga2.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf"

        sed -e "s|@@PLUGIN_DIR@@|${plugin_dir}|g" \
            -e "s|@@NODE_NAME@@|${agent_name}|g" \
            "${SYNOPKG_PKGDEST}/share/templates/constants.conf" > "${SYNOPKG_PKGVAR}/etc/icinga2/constants.conf"

        sed -e "s|@@MASTER_HOST@@|${master_host}|g" \
            -e "s|@@MASTER_PORT@@|${master_port}|g" \
            -e "s|@@AGENT_NAME@@|${agent_name}|g" \
            "${SYNOPKG_PKGDEST}/share/templates/zones.conf" > "${SYNOPKG_PKGVAR}/etc/icinga2/zones.conf"

        # Copy features-available to features-enabled
        if [ -d "${SYNOPKG_PKGDEST}/etc/icinga2/features-available" ]; then
            cp "${SYNOPKG_PKGDEST}/etc/icinga2/features-available/"*.conf "${SYNOPKG_PKGVAR}/etc/icinga2/features-enabled/" 2>/dev/null || true
        fi

        # Generate API user password
        agent_password=$(generate_password)
        sed -e "s|@@API_PASSWORD@@|${agent_password}|g" \
            "${SYNOPKG_PKGDEST}/share/templates/api-users.conf" > "${SYNOPKG_PKGVAR}/etc/icinga2/conf.d/api-users.conf"

        # Secure config directory
        find "${SYNOPKG_PKGVAR}/etc/icinga2" -type f -exec chmod 640 {} \;
        find "${SYNOPKG_PKGVAR}/etc/icinga2" -type d -exec chmod 750 {} \;
    fi

    return 0
}
