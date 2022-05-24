
ENV_FILE="${SYNOPKG_PKGVAR}/.env"
ENV_FILE_DEFAULT="${SYNOPKG_PKGVAR}/env.default"
CONFIG_FILE=${SYNOPKG_PKGVAR}/config.json
CONFIG_FILE_TEMPLATE=${SYNOPKG_PKGVAR}/template.config.json

export DATA_FOLDER=${SYNOPKG_PKGVAR}
export WEB_VAULT_FOLDER=${SYNOPKG_PKGDEST}/web-vault/
export ROCKET_PORT=${SERVICE_PORT}
export ROCKET_CLI_COLORS=false
export ROCKET_ADDRESS=0.0.0.0

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/vaultwarden"
SVC_WRITE_PID=yes
SVC_BACKGROUND=yes

# TODO:
# add wizard to use sqlite or define mysql connection


# Load environment variables
#if [ -r "${ENV_FILE}" ]; then
#    . "${ENV_FILE}"
#fi

service_postinst ()
{
    if [ ! -e ${ENV_FILE} ]; then
        # Create default env file
        cp -f ${ENV_FILE_DEFAULT} ${ENV_FILE}
    fi

    if [ ! -e ${CONFIG_FILE} ]; then
        # Create config file with values from wizard
        cp -f ${CONFIG_FILE_TEMPLATE} ${CONFIG_FILE}
        sed -e "s|@@domain@@|${wizard_domain}|g" \
            -e "s|@@admin_token@@|${wizard_admin_token}|g" \
            -i ${CONFIG_FILE}
    else
        echo "Missing config file: ${CONFIG_FILE}"
    fi
}
