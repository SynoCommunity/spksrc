
# Optional (soft) ffmpeg: use the newest installed SynoCommunity ffmpeg package, if any,
# so Navidrome finds both ffmpeg and ffprobe (needed for transcoding decisions).
# Deliberately not a SPK_DEPENDS: direct play works without it.
FFMPEG_DIR=""
for _ff_pkg in ffmpeg8 ffmpeg7 ffmpeg6 ffmpeg5 ffmpeg4 ffmpeg; do
    _ff_bin="/var/packages/${_ff_pkg}/target/bin"
    if [ -x "${_ff_bin}/ffmpeg" ] && [ -x "${_ff_bin}/ffprobe" ]; then
        FFMPEG_DIR="${_ff_bin}"
        break
    fi
done
unset _ff_pkg _ff_bin
if [ -n "${FFMPEG_DIR}" ]; then
    PATH="${FFMPEG_DIR}:${PATH}"
fi

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
