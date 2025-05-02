
UMURMUR="${SYNOPKG_PKGDEST}/bin/umurmurd"
CFG_FILE="${SYNOPKG_PKGVAR}/umurmur.conf"
SERVICE_COMMAND="${UMURMUR} -c ${CFG_FILE} -p ${PID_FILE}"

OPENSSL="$(which openssl)"
PRIVATE_KEY="${SYNOPKG_PKGVAR}/umurmur.key"
PUBLIC_KEY="${SYNOPKG_PKGVAR}/umurmur.crt"


create_certificate ()
{
    if [ -f "${PRIVATE_KEY}" ] && [ -f "${PUBLIC_KEY}" ]; then
        echo "Found uMurmur certificate. To create a new certificate upon package update you have to delete the existing certificate before."
        exit 0
    fi

    if [ -z "${OPENSSL}" ]; then
        echo "missing openssl to create certificate for uMurmur."
        exit 2
    fi

    # create certificate (use openssl of DSM)
    ${OPENSSL} req -x509 -newkey rsa:4096 -keyout ${PRIVATE_KEY} -nodes -sha256 -days 3653 -out ${PUBLIC_KEY} -batch -config /etc/ssl/openssl.cnf > /dev/null 2>&1

    # Exit with the right code and an explicit message
    if [ $? -ne 0 ]; then
        exit 1
    fi

    echo "Certificate for uMurmur successfully created."
    exit 0
}

service_postinst ()
{
    # Certificate generation
    create_certificate 2>&1
    if [ $? -ne 0 ]; then
        touch ${PRIVATE_KEY}
        touch ${PUBLIC_KEY}
        exit 1
    fi
}

service_preupgrade ()
{
    # Migrate to DSM 7 compatible var folder
    if [ -e "${CFG_FILE}" ]; then
        if $(grep -q "/usr/local/umurmur/var/" "${CFG_FILE}"); then
            echo "Update var folder for DSM 7 compatibility in configuration file."
            sed -e "s,/usr/local/umurmur/var/,/var/packages/umurmur/var/,g" -i "${CFG_FILE}"
        fi
    fi

    # Update log-file name to package name
    if [ -e "${CFG_FILE}" ]; then
        if $(grep -q "umurmurd.log" "${CFG_FILE}"); then
            echo "Update log file name in configuration file."
            sed -e "s,umurmurd.log,umurmur.log,g" -i "${CFG_FILE}"
        fi
    fi

    # Remove nobody user and group from configuration to address changed permission management in DSM6+
    if [ $SYNOPKG_DSM_VERSION_MAJOR -gt 5 ]; then
        if [ -e "${CFG_FILE}" ]; then
            USER_NOBODY=$(grep -e 'username = "nobody";' "${CFG_FILE}" | cut -c1)
            if [ "${USER_NOBODY}" != "" ] && [ "${USER_NOBODY}" != "#" ]; then
                echo "Remove user nobody from umurmur configuration for DSM6+ compatibility."
                sed -e "s,username = \"nobody\";,# username = \"nobody\";,g" -i "${CFG_FILE}"
            fi
            GROUP_NOBODY=$(grep -e 'groupname = "nobody";' "${CFG_FILE}" | cut -c1)
            if [ "${GROUP_NOBODY}" != "" ] && [ "${GROUP_NOBODY}" != "#" ]; then
                echo "Remove group nobody from umurmur configuration for DSM6+ compatibility."
                sed -e "s,groupname = \"nobody\";,# groupname = \"nobody\";,g" -i "${CFG_FILE}"
            fi
        fi
    fi
}
