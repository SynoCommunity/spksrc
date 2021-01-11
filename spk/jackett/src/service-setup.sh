
# Package specific behaviours
# Sourced script by generic installer and start-stop-status scripts

service_prestart ()
{
    # Replace generic service startup
    PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
    JACKETT="${SYNOPKG_PKGDEST}/share/jackett"
    HOME_DIR="${SYNOPKG_PKGDEST}/var"

    echo "Starting Jackett as user ${EFF_USER}" >> ${LOG_FILE}
    COMMAND="env HOME=${HOME_DIR} PATH=${PATH} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${JACKETT} --PIDFile ${PID_FILE}"

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
        su ${EFF_USER} -s /bin/sh -c "${COMMAND}" >> ${LOG_FILE} 2>&1 &
    else
        ${COMMAND} >> ${LOG_FILE} 2>&1 &
    fi
}
