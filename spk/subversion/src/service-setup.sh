
SERVICE_VARIABLES="${SYNOPKG_PKGVAR}/service-variables"
SERVICE_VARIABLES_TEMPLATE="${SYNOPKG_PKGVAR}/service-variables.template"

service_postinst ()
{
    if [ ! -f "${SERVICE_VARIABLES}" ]; then
        echo "Create ${SERVICE_VARIABLES}"
        cp -f ${SERVICE_VARIABLES_TEMPLATE} ${SERVICE_VARIABLES}
    fi
    
    sed -i -e "s|@@share_path@@|${SHARE_PATH}|g" ${SERVICE_VARIABLES}
}

service_prestart ()
{
    if [ -f "${SERVICE_VARIABLES}" ]; then
        FUNCTIONS=$(dirname $0)"/functions"
        if [ -r "${FUNCTIONS}" ]; then
            . "${FUNCTIONS}"
        fi
        load_variables_from_file "${SERVICE_VARIABLES}"
    fi

    SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/svnserve --daemon --root ${SHARE_PATH} --listen-port ${SERVICE_PORT} --log-file ${LOG_FILE} --pid-file ${PID_FILE}"
}
