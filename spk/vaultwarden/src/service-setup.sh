
ENV_FILE_DEFAULT="${SYNOPKG_PKGVAR}/env.default"
CONFIG_FILE_TEMPLATE=${SYNOPKG_PKGVAR}/template.config.json

ENV_FILE="${SYNOPKG_PKGVAR}/.env"
CONFIG_FILE=${SYNOPKG_PKGVAR}/config.json

export ENV_FILE=${ENV_FILE}
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/vaultwarden"
SVC_WRITE_PID=yes
SVC_BACKGROUND=yes

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Create default env file
        cp -f ${ENV_FILE_DEFAULT} ${ENV_FILE}
        if [ ! -e ${ENV_FILE} ]; then
            echo "Failed to create env file: ${ENV_FILE}"
        fi

        # Create config file with values from wizard
        cp -f ${CONFIG_FILE_TEMPLATE} ${CONFIG_FILE}
        if [ -e ${CONFIG_FILE} ]; then
            if [ -z "${wizard_admin_token}" ]; then
                disable_admin_token=true
            else
                disable_admin_token=false
            fi
            sed -e "s|@@domain@@|${wizard_domain}|g"  \
                -e "s|@@admin_token@@|${wizard_admin_token}|g"  \
                -e "s|\"@@disable_admin_token@@\"|${disable_admin_token}|g"  \
                -i ${CONFIG_FILE}
        else
            echo "Failed to create config file: ${CONFIG_FILE}"
        fi
    fi
}
