
# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

UMURMUR="${SYNOPKG_PKGDEST}/bin/umurmurd"
CFG_FILE="${SYNOPKG_PKGDEST}/var/umurmur.conf"
GEN_CERT="${SYNOPKG_PKGDEST}/sbin/gencert.sh"

SERVICE_COMMAND="${UMURMUR} -c ${CFG_FILE} -p ${PID_FILE}"

service_postinst ()
{
    # Certificate generation
    ${GEN_CERT} >> ${INST_LOG}
    if [ $? -ne 0 ]; then
        exit 1
    fi
}
