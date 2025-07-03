OPENLIST="${SYNOPKG_PKGDEST}/bin/openlist --data ${SYNOPKG_PKGVAR}"
CONFIG_FILE="${SYNOPKG_PKGVAR}/config.json"

SERVICE_COMMAND="${OPENLIST} server"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        JWT_SECRET=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
        
        SITE_URL=$(echo -n "${wizard_site_url}" | sed 's|/$||')

        sed -e "s|%site_url%|${SITE_URL}|g" \
            -e "s|%jwt_secret%|${JWT_SECRET}|g" \
            -e "s|%data%|${SYNOPKG_PKGVAR}|g" \
            -i ${CONFIG_FILE}

        if [ -n "${wizard_admin_password}" ]; then
            ${OPENLIST} admin set "${wizard_admin_password}" 
        fi

    fi
}
