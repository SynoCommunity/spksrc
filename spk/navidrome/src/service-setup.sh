
CONFIG_FILE="${SYNOPKG_PKGVAR}/navidrome.toml"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/navidrome --port ${SERVICE_PORT} --configfile=${CONFIG_FILE}"
SVC_WRITE_PID=y
SVC_BACKGROUND=y

service_postinst ()
{
    # update config with values from wizard variables
    sed -e "s|@@wizard_music_folder@@|${SHARE_PATH}|g" \
        -i "${CONFIG_FILE}"
}
