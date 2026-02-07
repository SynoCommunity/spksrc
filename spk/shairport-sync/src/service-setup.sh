CFG_FILE="${SYNOPKG_PKGVAR}/shairport-sync.conf"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/shairport-sync -c ${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    # Link ALSA configuration for the daemon to find
    if [ ! -e "${SYNOPKG_PKGVAR}/.asoundrc" ]; then
        ln -sf "${SYNOPKG_PKGDEST}/share/alsa/alsa.conf" "${SYNOPKG_PKGVAR}/.asoundrc"
    fi
}
