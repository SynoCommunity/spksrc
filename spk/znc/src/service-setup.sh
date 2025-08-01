
# znc service setup
# Sourced by generic installer and start-stop-status scripts

# Set generic service startup, run service in background
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
ZNC="${SYNOPKG_PKGDEST}/bin/znc"
CERT_FILE="${SYNOPKG_PKGVAR}/znc.pem"
SERVICE_COMMAND="${ZNC} -d ${SYNOPKG_PKGVAR}"
SVC_BACKGROUND=yes
CONF_FILE=${SYNOPKG_PKGVAR}/configs/znc.conf
OID_FILE=${SYNOPKG_PKGVAR}/configs/oidentd.conf

# DEBUG
#SERVICE_COMMAND="strace -o ${SYNOPKG_PKGVAR}/znc-strace.log ${ZNC} -d ${SYNOPKG_PKGVAR} --debug --foreground"
#export ZNC_DEBUG_MODULES=1
#export ZNC_DEBUG_SSL=1

service_postinst ()
{
    # Edit the configuration according to the wizard
    sed -i -e "s,@pidfile@,${PID_FILE},g" ${CONF_FILE}
    sed -i -e "s,@certfile@,${CERT_FILE},g" ${CONF_FILE}
    sed -i -e "s,@username@,${wizard_username:=admin},g" ${CONF_FILE}
    sed -i -e "s,@password@,${wizard_password:=admin},g" ${CONF_FILE}
    sed -i -e "s,@zncuser@,${EFF_USER},g" ${OID_FILE}
}

service_prestart ()
{
    # Generate certificate if it does not exist (on first run)
    if [ -e "${CERT_FILE}" ]; then
        echo "Certificate file exists. Starting..."     >> ${LOG_FILE}
    else
        echo "Generating initial certificate file"      >> ${LOG_FILE}
        ${ZNC} -d ${SYNOPKG_PKGVAR} -p                  >> ${LOG_FILE}
        echo "Certificate file created. Starting..."    >> ${LOG_FILE}
    fi
}

