
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
GROUP="sc-restic-rest-server"

# Source installer variables and functions to be available for service start (and not only during installation)
INST_FUNCTIONS=$(dirname $0)"/functions"
if [ -r "${INST_FUNCTIONS}" ]; then
    . "${INST_FUNCTIONS}"
fi

load_variables_from_file "${INST_VARIABLES}"

REST_SERVER_CUSTOM_ARGS_FILE="${WIZARD_DATA_VOLUME}/${WIZARD_DATA_DIRECTORY}/restic_rest_server_custom_args.txt"

service_prestart ()
{
    ARGS=""

    if [ "${WIZARD_APPEND_ONLY}" == "true" ]; then
        ARGS="${ARGS} --append-only"
    fi
    if [ "${WIZARD_PRIVATE_REPOS}" == "true" ]; then
        ARGS="${ARGS} --private-repos"
    fi
    if [ "${WIZARD_PROMETHEUS}" == "true" ]; then
        ARGS="${ARGS} --prometheus"

        if [ "${WIZARD_PROMETHEUS_NO_AUTH}" == "true" ]; then
            ARGS="${ARGS} --prometheus-no-auth"
        fi
    fi
    if [ -f "$REST_SERVER_CUSTOM_ARGS_FILE" -a -r "$REST_SERVER_CUSTOM_ARGS_FILE" ]; then
        CUSTOM_ARGS=`cat ${REST_SERVER_CUSTOM_ARGS_FILE}`
        ARGS="${ARGS} ${CUSTOM_ARGS}"
    fi

    SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/restic-rest-server --listen ":${SERVICE_PORT}" --path ${WIZARD_DATA_VOLUME}/${WIZARD_DATA_DIRECTORY} ${ARGS}"
    SVC_BACKGROUND=y
    SVC_WRITE_PID=y
}

service_postinst ()
{
    touch ${wizard_data_volume}/${wizard_data_directory}/.htpasswd
    touch ${REST_SERVER_CUSTOM_ARGS_FILE}
    echo WIZARD_DATA_VOLUME="${wizard_data_volume}"                 >> ${INST_VARIABLES}
    echo WIZARD_DATA_DIRECTORY="${wizard_data_directory}"           >> ${INST_VARIABLES}
    echo WIZARD_APPEND_ONLY="${wizard_append_only}"                 >> ${INST_VARIABLES}
    echo WIZARD_PRIVATE_REPOS="${wizard_private_repos}"             >> ${INST_VARIABLES}
    echo WIZARD_PROMETHEUS="${wizard_prometheus}"                   >> ${INST_VARIABLES}
    echo WIZARD_PROMETHEUS_NO_AUTH="${wizard_prometheus_no_auth}"   >> ${INST_VARIABLES}
}
