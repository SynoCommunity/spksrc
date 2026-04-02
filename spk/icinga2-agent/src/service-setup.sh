# Icinga 2 Agent service configuration

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/icinga2 daemon -c ${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Helper: generate random password
generate_password ()
{
    head -c 32 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 24
}

# Helper: copy template file and substitute placeholder variables
copy_config()
{
    src=$1 dest=$2
    shift 2
    cp "${src}" "${dest}"
    while [ $# -gt 0 ]; do
        sed -i "s|$1|g" "${dest}"
        shift
    done
}

# Verify master hostname and port are reachable
validate_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if [ -z "${wizard_master_host}" ]; then
            echo "Master server hostname is required"
            exit 1
        fi

        master_port="${wizard_master_port:-5665}"
        if ! timeout 5 bash -c "echo '' | openssl s_client -connect ${wizard_master_host}:${master_port} -servername ${wizard_master_host} 2>/dev/null | grep -q 'Icinga'" 2>/dev/null; then
            echo "Error: ${wizard_master_host}:${master_port} does not appear to be a valid Icinga 2 master"
            exit 1
        fi
    fi
}

# Register agent with master via Director Self-Service API
register_on_master ()
{
    if [ -z "${wizard_api_key}" ]; then
        echo "No Director API key provided, skipping auto-registration"
        return 1
    fi

    config_file="${SYNOPKG_PKGVAR}/etc/agent-config.conf"
    if [ ! -f "${config_file}" ]; then
        return 1
    fi

    . "${config_file}"

    director_url="https://${cfg_master_host}/icingaweb2/director"

    # Get the agent's own IP address (first non-loopback IP)
    agent_ip=$(ip -4 addr show scope global | grep -oP 'inet \K[\d.]+' | head -1)
    if [ -z "${agent_ip}" ]; then
        agent_ip=$(hostname -I | awk '{print $1}')
    fi

    # Step 1: Register host via Director Self-Service API
    register_result=$(curl -sk -X POST \
        "${director_url}/self-service/register-host?name=${cfg_agent_name}&key=${wizard_api_key}" \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d "{\"address\":\"${agent_ip}\"}" 2>&1)

    host_api_key=$(echo "${register_result}" | grep -oE '[a-f0-9]{40}' | head -1)

    if [ -z "${host_api_key}" ]; then
        echo "Director registration failed: ${register_result}" >&2
        return 1
    fi

    echo "Successfully registered with master via Director"

    # Step 2: Get signing ticket from Director
    ticket_result=$(curl -sk \
        "${director_url}/self-service/ticket?key=${host_api_key}" \
        -H 'Accept: application/json' 2>&1)

    CERT_TICKET=$(echo "${ticket_result}" | tr -d '"' | tr -d '\n' | tr -d '\r')

    if [ -n "${CERT_TICKET}" ] && [ ${#CERT_TICKET} -gt 10 ]; then
        echo "Got certificate signing ticket from Director"
        echo "${CERT_TICKET}" > "${SYNOPKG_PKGVAR}/etc/icinga2/ticket"
        chmod 600 "${SYNOPKG_PKGVAR}/etc/icinga2/ticket"
    else
        echo "Warning: Could not get signing ticket: ${ticket_result}" >&2
    fi

    return 0
}

service_postinst ()
{
    # Create required directories
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icinga2/conf.d"
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icinga2/features-enabled"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2/crash"
    mkdir -p "${SYNOPKG_PKGVAR}/cache/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/lib/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/spool/icinga2/perfdata"
    mkdir -p "${SYNOPKG_PKGVAR}/run/icinga2/cmd"

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        master_host="${wizard_master_host}"
        master_port="${wizard_master_port:-5665}"
        agent_name="${wizard_agent_name:-$(hostname)}"
        plugin_dir="${SYNOPKG_PKGDEST}/target/bin"

        # Fetch master's certificate and extract master zone from certificate CN
        mkdir -p "${SYNOPKG_PKGVAR}/lib/icinga2/certs"
        echo "" | openssl s_client -connect "${master_host}:${master_port}" -servername "${master_host}" 2>/dev/null | openssl x509 > "${SYNOPKG_PKGVAR}/lib/icinga2/certs/trusted-master.crt" 2>/dev/null || true
        master_zone=$(openssl x509 -in "${SYNOPKG_PKGVAR}/lib/icinga2/certs/trusted-master.crt" -subject -noout 2>/dev/null | sed 's/.*CN = //')
        master_zone="${master_zone:-${master_host}}"

        # Save config for use at runtime
        copy_config "${SYNOPKG_PKGDEST}/share/templates/agent-config.conf" "${SYNOPKG_PKGVAR}/etc/agent-config.conf" \
            "@@MASTER_HOST@@" "${master_host}" "@@MASTER_PORT@@" "${master_port}" "@@AGENT_NAME@@" "${agent_name}" "@@MASTER_ZONE@@" "${master_zone}"
        chmod 600 "${SYNOPKG_PKGVAR}/etc/agent-config.conf"

        # Register with Director (creates host, zone, endpoint)
        register_on_master || true

        # Generate private key and self-signed certificate
        openssl genrsa -out "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${agent_name}.key" 2048 2>/dev/null
        openssl req -new -x509 -key "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${agent_name}.key" \
            -out "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${agent_name}.crt" \
            -subj "/CN=${agent_name}" -days 3650 2>/dev/null

        # Copy master's CA cert for trust
        cp "${SYNOPKG_PKGVAR}/lib/icinga2/certs/trusted-master.crt" \
           "${SYNOPKG_PKGVAR}/lib/icinga2/certs/ca.crt" 2>/dev/null || true

        # Request CA-signed certificate if we have a ticket
        TICKET=""
        if [ -f "${SYNOPKG_PKGVAR}/etc/icinga2/ticket" ]; then
            TICKET=$(cat "${SYNOPKG_PKGVAR}/etc/icinga2/ticket" 2>/dev/null)
        fi

        if [ -n "${TICKET}" ] && [ ${#TICKET} -gt 10 ]; then
            echo "Requesting CA-signed certificate from master..."
            ${SYNOPKG_PKGDEST}/sbin/icinga2 pki request \
                --host="${master_host}" \
                --port="${master_port}" \
                --ticket="${TICKET}" \
                --key="${SYNOPKG_PKGVAR}/lib/icinga2/certs/${agent_name}.key" \
                --cert="${SYNOPKG_PKGVAR}/lib/icinga2/certs/${agent_name}.crt" \
                --ca="${SYNOPKG_PKGVAR}/lib/icinga2/certs/ca.crt" \
                --trustedcert="${SYNOPKG_PKGVAR}/lib/icinga2/certs/trusted-master.crt" 2>&1 || true
            echo "Certificate request complete"
        else
            echo "Certificate setup complete for ${agent_name} (self-signed)"
        fi

        # Copy configuration templates
        cp "${SYNOPKG_PKGDEST}/share/templates/icinga2.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf"

        copy_config "${SYNOPKG_PKGDEST}/share/templates/constants.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/constants.conf" \
            "@@PLUGIN_DIR@@" "${plugin_dir}" "@@NODE_NAME@@" "${agent_name}"

        copy_config "${SYNOPKG_PKGDEST}/share/templates/zones.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/zones.conf" \
            "@@MASTER_HOST@@" "${master_host}" "@@MASTER_PORT@@" "${master_port}" "@@AGENT_NAME@@" "${agent_name}" "@@MASTER_ZONE@@" "${master_zone}"

        # Generate API user password
        agent_password=$(generate_password)
        copy_config "${SYNOPKG_PKGDEST}/share/templates/api-users.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/conf.d/api-users.conf" \
            "@@API_PASSWORD@@" "${agent_password}"

        # Secure config directory
        find "${SYNOPKG_PKGVAR}/etc/icinga2" -type f -exec chmod 640 {} \;
        find "${SYNOPKG_PKGVAR}/etc/icinga2" -type d -exec chmod 750 {} \;
    fi

    return 0
}
