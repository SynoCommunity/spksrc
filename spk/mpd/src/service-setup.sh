ORIG_CFG_FILE="${SYNOPKG_PKGDEST}/etc/mpd.conf"
CFG_FILE="${SYNOPKG_PKGHOME}/mpd.conf"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/mpd ${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    # replace "/" character in the folder name to allow search/replace by sed
    echo "${wizard_music_folder}" | sed -e  "s/\//\\\\\//g" >/tmp/wizard_music_folder_value
    MUSICFOLDER=`cat /tmp/wizard_music_folder_value`

    # Edit the configuration according to the wizard
    sed -i -e "s/@music_folder@/$MUSICFOLDER/g" ${ORIG_CFG_FILE}
    sed -i -e "s/@bind_address@/${wizard_bind_address}/g" ${ORIG_CFG_FILE}
    sed -i -e "s/@port@/${wizard_port:=6600}/g" ${ORIG_CFG_FILE}

    # Copy configuration file to home folder
    cp "${ORIG_CFG_FILE}" "${CFG_FILE}"

    # Create .mpd folder
    mkdir "${SYNOPKG_PKGHOME}"/.mpd

    # Create playlists folder
    mkdir "${SYNOPKG_PKGHOME}"/.mpd/playlists
}

