
# icecast service setup
CFG_FILE="${SYNOPKG_PKGVAR}/icecast.xml"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/icecast -b -c ${CFG_FILE}"
SVC_WRITE_PID=y

service_postupgrade ()
{
    [ -f "${CFG_FILE}" ] || return 0

    # Remove obsolete burst-on-connect; burst-size supersedes it.
    sed -i '/^[[:space:]]*<burst-on-connect>.*<\/burst-on-connect>[[:space:]]*$/d' "${CFG_FILE}"

    # Move a legacy top-level mime-types entry into <paths>.
    awk '
        BEGIN { in_paths = 0; has_mime = 0; mime = "" }
        /^[[:space:]]*<paths>[[:space:]]*$/ {
            in_paths = 1
            print
            next
        }
        /^[[:space:]]*<\/paths>[[:space:]]*$/ {
            if (mime != "" && !has_mime)
                print "        " mime
            in_paths = 0
            print
            next
        }
        in_paths && /<mime-types>/ { has_mime = 1 }
        !in_paths && /^[[:space:]]*<mime-types>.*<\/mime-types>[[:space:]]*$/ {
            mime = $0
            sub(/^[[:space:]]+/, "", mime)
            next
        }
        { print }
    ' "${CFG_FILE}" > "${CFG_FILE}.tmp" && mv "${CFG_FILE}.tmp" "${CFG_FILE}"

    [ -n "${wizard_ic_hostname}" ] && sed -i "s#<hostname>.*</hostname>#<hostname>${wizard_ic_hostname}</hostname>#" "${CFG_FILE}"
    [ -n "${wizard_ic_location}" ] && sed -i "s#<location>.*</location>#<location>${wizard_ic_location}</location>#" "${CFG_FILE}"
    [ -n "${wizard_ic_admin}" ] && sed -i "s#<admin>.*</admin>#<admin>${wizard_ic_admin}</admin>#" "${CFG_FILE}"

    if [ -n "${EFF_USER}" ] && chown "${EFF_USER}" "${CFG_FILE}"; then
        chmod 600 "${CFG_FILE}"
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then  
        # Edit the configuration according to the wizard
        sed -e "s/@username@/${wizard_ic_username:=admin}/g" \
            -e "s/@password@/${wizard_ic_password:=changepassword}/g" \
            -e "s/@hostname@/${wizard_ic_hostname:=localhost}/g" \
            -e "s/@location@/${wizard_ic_location:=Earth}/g" \
            -e "s/@admin@/${wizard_ic_admin:=icemaster@localhost}/g" \
            -i ${CFG_FILE}

        # Add an explicit IPv6 listener only when requested.
        if [ "${wizard_ic_ipv6}" = "true" ]; then
            awk '
                /@ipv6_listen_socket@/ {
                    print "    <listen-socket>"
                    print "        <port>8000</port>"
                    print "        <bind-address>::</bind-address>"
                    print "    </listen-socket>"
                    next
                }
                { print }
            ' "${CFG_FILE}" > "${CFG_FILE}.tmp" && mv "${CFG_FILE}.tmp" "${CFG_FILE}"
        else
            sed -i '/@ipv6_listen_socket@/d' "${CFG_FILE}"
        fi
    fi

    if [ -f "${CFG_FILE}" ] && [ -n "${EFF_USER}" ] && chown "${EFF_USER}" "${CFG_FILE}"; then
        chmod 600 "${CFG_FILE}"
    fi
}
