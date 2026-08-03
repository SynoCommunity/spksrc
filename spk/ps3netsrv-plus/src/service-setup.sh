SVC_BACKGROUND=yes
SVC_WRITE_PID=yes
SVC_WAIT_TIMEOUT=20

validate_preinst()
{
    if [ "${SYNOPKG_PKG_STATUS}" != "INSTALL" ]; then
        return 0
    fi
    case "${wizard_port}" in
        ''|*[!0-9]*)
            echo "Invalid NETISO port."
            exit 1
            ;;
    esac
    if [ "${wizard_port}" -lt 1024 ] || [ "${wizard_port}" -gt 65535 ]; then
        echo "NETISO port must be between 1024 and 65535."
        exit 1
    fi
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        PORT_TOOL=""
        for PORT_TOOL_PATH in /usr/syno/bin/servicetool /usr/syno/sbin/servicetool; do
            if [ -x "${PORT_TOOL_PATH}" ]; then
                PORT_TOOL=${PORT_TOOL_PATH}
                break
            fi
        done
        if [ -n "${PORT_TOOL}" ]; then
            PORT_RESULT=$("${PORT_TOOL}" --conf-port-conflict-check --tcp "${wizard_port}" 2>&1)
            case "${PORT_RESULT}" in
                *"IsConflict: true"*|*"IsConflict:true"*)
                    PORT_OWNER=$(printf '%s\n' "${PORT_RESULT}" | sed -n 's/.*ServiceName:[[:space:]]*//p')
                    if [ "${PORT_OWNER}" = "ps3netsrv-plus" ]; then
                        install_log "Ignoring the existing ps3netsrv-plus registration for port ${wizard_port}."
                    else
                        echo "NETISO port ${wizard_port} is registered by ${PORT_OWNER:-another service}. Choose another port or remove the owning service."
                        exit 1
                    fi
                    ;;
                *"IsConflict: false"*|*"IsConflict:false"*) ;;
                *) install_log "Unable to verify NETISO port ${wizard_port}: ${PORT_RESULT}" ;;
            esac
        else
            install_log "Unable to verify NETISO port ${wizard_port}: servicetool was not found."
        fi
    fi
}

service_postinst()
{
    if [ "${SYNOPKG_PKG_STATUS}" != "INSTALL" ]; then
        return 0
    fi
    printf '%s\n' "${wizard_shared_folder_name}" > "${SYNOPKG_PKGVAR}/install.share" || exit 1
    printf '%s\n' "${wizard_library_subdir}" > "${SYNOPKG_PKGVAR}/install.subdir" || exit 1
    printf '%s\n' "${wizard_port}" > "${SYNOPKG_PKGVAR}/install.port" || exit 1
    : > "${SYNOPKG_PKGVAR}/install.pending" || exit 1
    chmod 0600 "${SYNOPKG_PKGVAR}/install.share" "${SYNOPKG_PKGVAR}/install.subdir" "${SYNOPKG_PKGVAR}/install.port" "${SYNOPKG_PKGVAR}/install.pending" || exit 1
    if [ -n "${SHARE_PATH}" ] && [ -d "${SHARE_PATH}" ]; then
        "${SYNOPKG_PKGDEST}/bin/ps3netsrv-plus" init --share "${SHARE_PATH}" --subdir "${wizard_library_subdir}" --port "${wizard_port}" || exit 1
        rm -f "${SYNOPKG_PKGVAR}/install.pending"
    fi
    chown "${EFF_USER}:http" "${SYNOPKG_PKGVAR}" || exit 1
    chmod 0750 "${SYNOPKG_PKGVAR}" || exit 1
}

service_prestart()
{
    if [ -f "${SYNOPKG_PKGVAR}/install.pending" ] || [ ! -f "${SYNOPKG_PKGVAR}/config.json" ]; then
        SHARE_NAME=$(cat "${SYNOPKG_PKGVAR}/install.share") || exit 1
        SUBDIR=""
        if [ -r "${SYNOPKG_PKGVAR}/install.subdir" ]; then
            SUBDIR=$(cat "${SYNOPKG_PKGVAR}/install.subdir") || exit 1
        fi
        PORT=$(cat "${SYNOPKG_PKGVAR}/install.port") || exit 1
        SHARE_PATH=$(realpath "/var/packages/${SYNOPKG_PKGNAME}/shares/${SHARE_NAME}") || exit 1
        "${SYNOPKG_PKGDEST}/bin/ps3netsrv-plus" init --share "${SHARE_PATH}" --subdir "${SUBDIR}" --port "${PORT}" || exit 1
        rm -f "${SYNOPKG_PKGVAR}/install.pending"
    fi
    chown "${EFF_USER}:http" "${SYNOPKG_PKGVAR}" "${SYNOPKG_PKGVAR}/bridge.key" "${SYNOPKG_PKGVAR}/run" || exit 1
    chmod 0750 "${SYNOPKG_PKGVAR}" || exit 1
    chmod 0640 "${SYNOPKG_PKGVAR}/bridge.key" || exit 1
    chmod 2770 "${SYNOPKG_PKGVAR}/run" || exit 1
}
