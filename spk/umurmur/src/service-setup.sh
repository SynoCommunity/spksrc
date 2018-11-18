
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

service_preupgrade ()
{
    # Adapt log-file configuration to default
    if [ -e "${CFG_FILE}" ]; then
        sed -i -e "s,umurmurd.log,umurmur.log,g" "${CFG_FILE}"
        echo "Set log file location to default in configuration file." >> ${INST_LOG}
    fi

    # Remove nobody user and group from configuration to address changed permission management in DSM6
    if [ $SYNOPKG_DSM_VERSION_MAJOR -gt 5 ]; then
        if [ -e "${CFG_FILE}" ]; then
            TRUNC_UN=`grep -e 'username = "nobody";' "${CFG_FILE}" | cut -c1`
            if [ ! "${TRUNC_UN}" = "#" ] && [ ! "${TRUNC_UN}" = "" ]; then
                sed -i -e "s,username = \"nobody\";,# username = \"nobody\";,g" "${CFG_FILE}"
                echo "Removed user nobody from umurmur configuration for DSM6 compatibility." >> ${INST_LOG}
            fi
            TRUNC_GN=`grep -e 'groupname = "nobody";' "${CFG_FILE}" | cut -c1`
            if [ ! "${TRUNC_GN}" = "#" ] && [ ! "${TRUNC_GN}" = "" ]; then
                sed -i -e "s,groupname = \"nobody\";,# groupname = \"nobody\";,g" "${CFG_FILE}"
                echo "Removed group nobody from umurmur configuration for DSM6 compatibility." >> ${INST_LOG}
            fi
        fi
    fi
}
