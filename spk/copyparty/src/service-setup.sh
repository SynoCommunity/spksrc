SVC_BACKGROUND=y
SVC_WRITE_PID=y

PYTHON_DIR="/var/packages/python314/target/bin"

# Optional (soft) ffmpeg: use the newest installed SynoCommunity ffmpeg package, if any.
# Deliberately not a SPK_DEPENDS: file serving works without it, but thumbnails,
# transcoding and ffprobe-based metadata need it.
FFMPEG_DIR=""
for _ff_pkg in ffmpeg8 ffmpeg7 ffmpeg6 ffmpeg5 ffmpeg4 ffmpeg; do
    _ff_bin="/var/packages/${_ff_pkg}/target/bin"
    if [ -x "${_ff_bin}/ffmpeg" ] && [ -x "${_ff_bin}/ffprobe" ]; then
        FFMPEG_DIR="${_ff_bin}"
        break
    fi
done
unset _ff_pkg _ff_bin

PATH="${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${PATH}"
if [ -n "${FFMPEG_DIR}" ]; then
    PATH="${FFMPEG_DIR}:${PATH}"
fi

escape_sed_replacement ()
{
    printf '%s' "$1" | sed -e 's/[\\&|]/\\&/g'
}

service_postinst ()
{
    install_python_virtualenv
    install_python_wheels

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        CONFIG="${SYNOPKG_PKGVAR}/copyparty.conf"
        cp "${SYNOPKG_PKGDEST}/share/copyparty/copyparty.conf" "${CONFIG}"
        ADMIN_USER=$(escape_sed_replacement "${wizard_admin_user}")
        ADMIN_PASS=$(escape_sed_replacement "${wizard_admin_password}")
        SHARE_PATH_ESC=$(escape_sed_replacement "${SHARE_PATH}")
        sed -i -e "s|@USER@|${ADMIN_USER}|g" \
               -e "s|@PASS@|${ADMIN_PASS}|g" \
               -e "s|@SHARE@|${SHARE_PATH_ESC}|g" \
               "${CONFIG}"
        chmod 600 "${CONFIG}"
    fi
}

service_prestart ()
{
    CONFIG="${SYNOPKG_PKGVAR}/copyparty.conf"
    SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/python3 -m copyparty -c ${CONFIG}"
}
