OPENLIST="${SYNOPKG_PKGDEST}/bin/openlist --data ${SYNOPKG_PKGVAR}"

SERVICE_COMMAND="${OPENLIST} server"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        JWT_SECRET=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
        
        SITE_URL=$(echo -n "${site_url}" | sed 's|/$||')

        DB_TYPE="${db_type}"
        if [ "${DB_TYPE}" = "sqlite3" ]; then
            DB_HOST=""
            DB_PORT="0"
            DB_USER=""
            DB_PASSWORD=""
            DB_NAME=""
        else
            DB_HOST="${db_host}"
            DB_PORT="${db_port:-0}"
            DB_USER="${db_user}"
            DB_PASSWORD="${db_password}"
            DB_NAME="${db_name}"
        fi

        sed -e "s|%site_url%|${SITE_URL}|g" \
            -e "s|%jwt_secret%|${JWT_SECRET}|g" \
            -e "s|%db_type%|${DB_TYPE}|g" \
            -e "s|%db_host%|${DB_HOST}|g" \
            -e "s|%db_port%|${DB_PORT}|g" \
            -e "s|%db_user%|${DB_USER}|g" \
            -e "s|%db_password%|${DB_PASSWORD}|g" \
            -e "s|%db_name%|${DB_NAME}|g" \
            -e "s|%data%|${SYNOPKG_PKGVAR}|g" \
            -i ${CONFIG_FILE}

        if [ -n "${admin_pass}" ]; then
            ${OPENLIST} admin set "${admin_pass}" 
        fi

    fi
}
