PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

TORBIN="${SYNOPKG_PKGDEST}/bin/tor"
TORCONF="${SYNOPKG_PKGDEST}/var/torrc"

SERVICE_COMMAND="${TORBIN} -f ${TORCONF} --pidfile ${PID_FILE}"

service_postinst ()
{

    #rename configuration depending on install mode
    if $TOR_EXIT == true ; then
        mv ${SYNOPKG_PKGDEST}/var/torrc.exit ${SYNOPKG_PKGDEST}/var/torrc
    elif $TOR_NONEXIT == true ; then
        mv ${SYNOPKG_PKGDEST}/var/torrc.noexit ${SYNOPKG_PKGDEST}/var/torrc
    else
        mv ${SYNOPKG_PKGDEST}/var/torrc.bridge ${SYNOPKG_PKGDEST}/var/torrc
    fi

    exit 0
}
