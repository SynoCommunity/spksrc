# shellcheck disable=SC2148
#
# dnscrypt-proxy service setup
#
# This package requires root to bind port 53 for DNS, then drops privileges
# via the user_name setting in the config file.
#
# Reference: https://github.com/DNSCrypt/dnscrypt-proxy
#

# Package paths
SVC_CWD="${SYNOPKG_PKGDEST}"
DNSCRYPT_PROXY="${SYNOPKG_PKGDEST}/bin/dnscrypt-proxy"
PID_FILE="${SYNOPKG_PKGVAR}/dnscrypt-proxy.pid"
CFG_FILE="${SYNOPKG_PKGVAR}/dnscrypt-proxy.toml"

# Ports
MONITORING_PORT="8153"  # Web UI for monitoring DNS queries
BACKUP_PORT="10053"     # Used when DHCP server occupies port 53

# Detect OS type: DSM (DiskStation Manager) vs SRM (Synology Router Manager)
# SRM uses productversion < 3.0 (e.g., 1.2.x), DSM uses >= 6.0
productversion=$(grep '^productversion=' /etc.defaults/VERSION | cut -d= -f2 | tr -d '"')
case "${productversion%%.*}" in
    [012]) OS="srm" ;;
    *) OS="dsm" ;;
esac

# DHCP forwarding config paths differ between DSM and SRM
if [ "$OS" = "dsm" ]; then
    DHCP_PREFIX="dns-dns"
else
    DHCP_PREFIX="dnscrypt-dnscrypt"
fi


#
# Helper functions
#

# Check if something is already using port 53 (typically DHCP server's dnsmasq)
is_port53_in_use() {
    # Check for running DHCP server (uses dnsmasq which binds port 53)
    if [ "$OS" = "srm" ]; then
        ps -w 2>/dev/null | grep -v grep | grep -q "dhcpd.conf"
    else
        ps aux 2>/dev/null | grep -v grep | grep -q "dhcpd.conf"
    fi && return 0
    
    # Also check if port 53 is bound by anything else
    netstat -na 2>/dev/null | grep -q ":53 " && return 0
    
    return 1
}

# Configure DHCP server to forward DNS queries to dnscrypt-proxy
# When DHCP's dnsmasq is running, it handles port 53 and forwards to us on BACKUP_PORT
forward_dns_dhcpd() {
    action="$1"
    conf="/etc/dhcpd/dhcpd-${DHCP_PREFIX}.conf"
    info="/etc/dhcpd/dhcpd-${DHCP_PREFIX}.info"
    
    echo "dns forwarding - ${action}" >> "${LOG_FILE}"
    
    if [ "$action" = "no" ] && [ -f "$conf" ]; then
        echo "enable=no" > "$info"
        /etc/rc.network nat-restart-dhcp >> "${LOG_FILE}" 2>&1
    elif [ "$action" = "yes" ] && is_port53_in_use; then
        echo "server=127.0.0.1#${BACKUP_PORT}" > "$conf"
        echo "enable=yes" > "$info"
        /etc/rc.network nat-restart-dhcp >> "${LOG_FILE}" 2>&1
    fi
}

# Configure the built-in monitoring web UI
configure_monitoring_ui() {
    ui_user="${1:-}"
    ui_pass="${2:-}"
    
    # If [monitoring_ui] section doesn't exist, append it (upgrading from old version)
    if ! grep -q "^\[monitoring_ui\]" "${CFG_FILE}" 2>/dev/null; then
        cat >> "${CFG_FILE}" << UIEOF

[monitoring_ui]
enabled = true
listen_address = "0.0.0.0:${MONITORING_PORT}"
username = "${ui_user}"
password = "${ui_pass}"
UIEOF
    else
        # Update existing section with user's credentials
        sed -i -e "s/^enabled = false/enabled = true/" \
            -e "s/^listen_address = \"127.0.0.1:8080\"/listen_address = \"0.0.0.0:${MONITORING_PORT}\"/" \
            -e "s/^username = \"admin\"/username = \"${ui_user}\"/" \
            -e "s/^password = \"changeme\"/password = \"${ui_pass}\"/" \
            "${CFG_FILE}"
    fi
}


#
# Blocklist management
#

blocklist_setup() {
    mkdir -p "${SYNOPKG_PKGVAR}"
    touch "${SYNOPKG_PKGVAR}/ip-blocklist.txt"
    
    # Download blocklist config if not present (supports both old and new filenames)
    if [ ! -e "${SYNOPKG_PKGVAR}/domains-blocklist.conf" ] && \
       [ ! -e "${SYNOPKG_PKGVAR}/domains-blacklist.conf" ]; then
        wget -t 3 -O "${SYNOPKG_PKGVAR}/domains-blocklist.conf" --https-only \
            https://raw.githubusercontent.com/DNSCrypt/dnscrypt-proxy/master/utils/generate-domains-blocklist/domains-blocklist.conf
    fi
}

blocklist_cron_install() {
    cron_line="3       0       *       *       *       root    /var/packages/dnscrypt-proxy/target/var/update-blocklist.sh"
    
    if [ "$OS" = "dsm" ]; then
        mkdir -p /etc/cron.d
        echo "$cron_line" > /etc/cron.d/dnscrypt-proxy-update-blocklist
    else
        # SRM: append to crontab if not already present
        grep -q "update-blocklist.sh" /etc/crontab || echo "$cron_line" >> /etc/crontab
    fi
    synoservicectl --restart crond
}

blocklist_cron_uninstall() {
    if [ "$OS" = "dsm" ]; then
        rm -f /etc/cron.d/dnscrypt-proxy-update-blocklist
    else
        sed -i '/update-blocklist.sh/d' /etc/crontab
    fi
    synoservicectl --restart crond
}


#
# Service lifecycle hooks
#

service_postinst() {
    mkdir -p "${SYNOPKG_PKGVAR}"

    # Only configure on fresh install (config file doesn't exist yet)
    if [ ! -e "${CFG_FILE}" ]; then
        # Copy example configs and offline resolver cache
        cp -f "${SYNOPKG_PKGDEST}"/example-* "${SYNOPKG_PKGVAR}/"
        cp -f "${SYNOPKG_PKGDEST}"/offline-cache/* "${SYNOPKG_PKGVAR}/"
        cp -f "${SYNOPKG_PKGDEST}"/blocklist/* "${SYNOPKG_PKGVAR}/"
        
        # Rename example-* files to their final names
        for file in "${SYNOPKG_PKGVAR}"/example-*.toml; do
            newname=$(basename "$file" | sed 's/^example-//')
            mv "${file}" "${SYNOPKG_PKGVAR}/${newname}"
        done

        # Apply wizard settings: server names (only if user specified non-blank)
        if [ -n "${wizard_servers:-}" ] && [ -n "$(echo "${wizard_servers}" | tr -d ' ')" ]; then
            sed -i "s/# server_names = .*/server_names = [${wizard_servers}]/" "${CFG_FILE}"
        fi

        # Choose port based on whether DHCP server is running
        dns_port="53"
        is_port53_in_use && dns_port="${BACKUP_PORT}"

        # Apply remaining settings
        sed -i -e "s/listen_addresses = .*/listen_addresses = ['0.0.0.0:${dns_port}']/" \
            -e "s/# user_name = .*/user_name = '${EFF_USER:-nobody}'/" \
            -e "s|# log_file = 'dnscrypt-proxy.log'.*|log_file = '${LOG_FILE:-}'|" \
            -e "s/ipv6_servers = .*/ipv6_servers = ${wizard_ipv6:-false}/" \
            "${CFG_FILE}"

        configure_monitoring_ui "${wizard_ui_user:-}" "${wizard_ui_pass:-}"
    fi

    chmod 0755 "${SYNOPKG_PKGVAR}"
    blocklist_setup
}

service_prestart() {
    # Dynamic port switching: automatically adapt when DHCP server is enabled/disabled
    # This allows users to change DHCP settings without reinstalling the package
    current_port=$(sed -n "s/listen_addresses = \\['0.0.0.0:\([0-9]*\)'.*/\1/p" "${CFG_FILE}" 2>/dev/null)
    current_port="${current_port:-53}"
    needed_port="53"
    is_port53_in_use && needed_port="${BACKUP_PORT}"
    
    if [ "$current_port" != "$needed_port" ]; then
        echo "Switching DNS port from ${current_port} to ${needed_port}"
        sed -i "s/listen_addresses = .*/listen_addresses = ['0.0.0.0:${needed_port}']/" "${CFG_FILE}"
    fi

    blocklist_cron_install
    forward_dns_dhcpd "yes"

    # Start dnscrypt-proxy
    cd "$SVC_CWD" || exit 1
    env GOMAXPROCS=1 USER=root HOME=/root "${DNSCRYPT_PROXY}" --config "${CFG_FILE}" --pidfile "${PID_FILE}" &
}

service_poststop() {
    blocklist_cron_uninstall
    forward_dns_dhcpd "no"
}

service_postuninst() {
    blocklist_cron_uninstall
    forward_dns_dhcpd "no"
    rm -f "/etc/dhcpd/dhcpd-${DHCP_PREFIX}.conf" "/etc/dhcpd/dhcpd-${DHCP_PREFIX}.info"
}

service_postupgrade() {
    # Update blocklist generator and offline cache
    cp -f "${SYNOPKG_PKGDEST}"/blocklist/generate-domains-blocklist.py "${SYNOPKG_PKGVAR}/"
    cp -f "${SYNOPKG_PKGDEST}"/offline-cache/* "${SYNOPKG_PKGVAR}/"
    chmod 0755 "${SYNOPKG_PKGVAR}"

    # Clean up old custom UI help files (from versions before built-in monitoring UI)
    if [ -f "${SYNOPKG_PKGDEST}/ui/index.conf" ]; then
        pkgindexer_del "${SYNOPKG_PKGDEST}/ui/helptoc.conf" 2>/dev/null || true
        pkgindexer_del "${SYNOPKG_PKGDEST}/ui/index.conf" 2>/dev/null || true
    fi

    # Fix problematic settings from older package versions
    if grep -q "require_dnssec = true" "${CFG_FILE}" 2>/dev/null; then
        sed -i -e "s/require_dnssec = true/require_dnssec = false/" \
            -e "s/netprobe_timeout = 2/netprobe_timeout = 60/" "${CFG_FILE}"
    fi

    configure_monitoring_ui "${wizard_ui_user:-}" "${wizard_ui_pass:-}"
}
