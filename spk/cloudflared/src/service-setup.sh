TOKEN_FILE="${SYNOPKG_PKGVAR}/token"
CONFIG_FILE="${SYNOPKG_PKGVAR}/config.yml"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/cloudflared tunnel --config ${SYNOPKG_PKGVAR}/config.yml run"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst() 
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then

        # Populate config template
        sed -i -e "s|@token@|${wizard_cloudflared_token}|g" \
            -e "s|@management-diagnostics@|${wizard_management_diagnostics}|g" \
            -e "s|@post-quantum@|${wizard_pq}|g" \
            -e "s|@edge-ip-version@|${wizard_edge_ip_version}|g" \
            ${CONFIG_FILE}

    fi
}

service_postupgrade() 
{
    # Migrate from token file if exists
    if [ -e $TOKEN_FILE ]; then
        echo "Migrate token into ${CONFIG_FILE} and delete ${TOKEN_FILE}"
        CLOUDFLARED_TOKEN="$(cat $TOKEN_FILE)"
        rm -f $TOKEN_FILE
        sed -i -e "s|@token@|${CLOUDFLARED_TOKEN}|g" \
            -e "s|@management-diagnostics@|false|g" \
            -e "s|@post-quantum@|false|g" \
            -e "s|@edge-ip-version@|4|g" \
            ${CONFIG_FILE}
    fi
}
