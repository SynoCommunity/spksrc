
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
KIWIX_SERVE="${SYNOPKG_PKGDEST}/bin/kiwix-serve"
LIBRARY_FILE="${SYNOPKG_PKGVAR}/library.xml"
SVC_WRITE_PID=y
SVC_BACKGROUND=y


SERVICE_COMMAND="${KIWIX_SERVE} --port=${SERVICE_PORT} --library ${LIBRARY_FILE}"

service_postinst ()
{
    if [ ! -f "${LIBRARY_FILE}" ]; then
        cp ${SYNOPKG_PKGDEST}/var/empty_library.xml "${LIBRARY_FILE}"
    fi
}
