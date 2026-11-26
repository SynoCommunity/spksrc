# Filestash keeps all state (config, db, cache, logs) under data/
# relative to CWD, overridable via FILESTASH_PATH. Pin it to the package
# var dir: CWD is not reliable across DSM versions, and anything under
# target/ is destroyed on upgrade while var/ persists.
export FILESTASH_PATH="${SYNOPKG_PKGVAR}/data"

FILESTASH_BIN="${SYNOPKG_PKGDEST}/bin/filestash"

# Optional (soft) ffmpeg: use the newest installed SynoCommunity ffmpeg
# package, if any. File management works without it; thumbnails,
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

if [ -n "${FFMPEG_DIR}" ]; then
    PATH="${FFMPEG_DIR}:${PATH}"
fi

SERVICE_COMMAND="${FILESTASH_BIN}"
SVC_CWD="${SYNOPKG_PKGVAR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_prestart()
{
    mkdir -p "${SYNOPKG_PKGVAR}" "${FILESTASH_PATH}"
}

service_postinst()
{
    # Seed a local backend pointing at the install share so the connect
    # page works out of the box. Only on fresh installs: never touch an
    # existing config (it holds the admin hash, secrets and user edits).
    # Verified: admin setup preserves a preseeded connections entry.
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        CONFIG_FILE="${FILESTASH_PATH}/state/config/config.json"
        if [ ! -f "${CONFIG_FILE}" ] && [ -n "${SHARE_PATH}" ]; then
            mkdir -p "$(dirname "${CONFIG_FILE}")"
            printf '{"connections": [{"type": "local", "label": "%s"}]}' "${SHARE_PATH}" > "${CONFIG_FILE}"
            chown "${EFF_USER:-sc-filestash}" "${CONFIG_FILE}" 2>/dev/null || true
        fi
    fi
}
