
CONFIG_DIR=${SYNOPKG_PKGVAR}/config
CONFIG_DEFAULT_DIR=${SYNOPKG_PKGVAR}/config.default
export MPD_HOST=/var/packages/mpd/var/mpd.socket

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/mympd"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


service_postinst ()
{
    if [ ! -d ${CONFIG_DIR} ]; then
        echo "Initialize configuration in ${CONFIG_DIR} from default config."
        mkdir -p ${CONFIG_DIR}
        $RSYNC --ignore-existing ${CONFIG_DEFAULT_DIR}/ ${CONFIG_DIR}
    fi
}

service_preupgrade()
{
    # Remove legacy mpd_host files to allow migration to socket-based connection
    rm -f "${SYNOPKG_PKGVAR}/state/mpd_host" \
          "${SYNOPKG_PKGVAR}/state/stickerdb_mpd_host"
}
