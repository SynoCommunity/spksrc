
# icecast service setup
CFG_FILE="${SYNOPKG_PKGVAR}/icecast.xml"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/icecast -b -c ${CFG_FILE}"
SVC_WRITE_PID=y

escape_sed ()
{
    printf '%s' "$1" | sed 's/[\/&#\\]/\\&/g'
}

escape_value ()
{
    escape_sed "$(printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g')"
}

replace_config_value ()
{
    [ -n "$2" ] || return 0
    sed -i "s#<$1>.*</$1>#<$1>$(escape_value "$2")</$1>#" "${CFG_FILE}"
}

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

    replace_config_value hostname "${wizard_ic_hostname}"
    replace_config_value location "${wizard_ic_location}"
    replace_config_value admin "${wizard_ic_admin}"

    if [ -n "${EFF_USER}" ] && chown "${EFF_USER}" "${CFG_FILE}"; then
        chmod 600 "${CFG_FILE}"
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then  
        # Edit the configuration according to the wizard
        sed -e "s/@username@/$(escape_value "${wizard_ic_username:=admin}")/g" \
            -e "s/@password@/$(escape_value "${wizard_ic_password:=changepassword}")/g" \
            -e "s/@hostname@/$(escape_value "${wizard_ic_hostname:=localhost}")/g" \
            -e "s/@location@/$(escape_value "${wizard_ic_location:=Earth}")/g" \
            -e "s/@admin@/$(escape_value "${wizard_ic_admin:=icemaster@localhost}")/g" \
            -i "${CFG_FILE}"

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
