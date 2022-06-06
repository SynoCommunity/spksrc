
CFG_FILE="${SYNOPKG_PKGVAR}/mpd.conf"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/mpd ${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    # Edit the configuration according to the wizard
    sed -i -e "s|@music_directory@|${wizard_music_volume}/${wizard_music_folder}|g" ${CFG_FILE}

    # Create playlists folder
    mkdir -p "${SYNOPKG_PKGVAR}/playlists"
}

