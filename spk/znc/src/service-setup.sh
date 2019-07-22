# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

# Replace generic service startup, run service in background
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
ZNC="${SYNOPKG_PKGDEST}/bin/znc"
CERT_FILE="${SYNOPKG_PKGDEST}/var/znc.pem"
SERVICE_COMMAND="${ZNC} -d ${SYNOPKG_PKGDEST}/var"
SVC_BACKGROUND=yes

service_postinst ()
{
    # Edit the configuration according to the wizard
    sed -i -e "s,@pidfile@,${PID_FILE},g" ${SYNOPKG_PKGDEST}/var/configs/znc.conf
    sed -i -e "s,@certfile@,${CERT_FILE},g" ${SYNOPKG_PKGDEST}/var/configs/znc.conf
    sed -i -e "s,@username@,${wizard_username:=admin},g" ${SYNOPKG_PKGDEST}/var/configs/znc.conf
    sed -i -e "s,@password@,${wizard_password:=admin},g" ${SYNOPKG_PKGDEST}/var/configs/znc.conf
    sed -i -e "s,@zncuser@,${EFF_USER},g" ${SYNOPKG_PKGDEST}/var/configs/oidentd.conf

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}

service_prestart ()
{
    # Generate certificate if it does not exist (on first run)
    if [ -e "${CERT_FILE}" ]; then
        echo "Certificate file exists. Starting..." >> ${LOG_FILE}
    else
        echo "Generating initial certificate file" >> ${LOG_FILE}
        ${ZNC} -d ${SYNOPKG_PKGDEST}/var -p >> ${LOG_FILE}
    fi
}
