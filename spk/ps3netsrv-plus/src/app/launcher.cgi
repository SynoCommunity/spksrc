#!/bin/sh
TOKEN=$(printf '%s' "${QUERY_STRING:-}" | tr '&' '\n' | sed -n 's/^SynoToken=//p' | sed -n '1p')
case "${TOKEN}" in
    *[!A-Za-z0-9._~%+=-]*) TOKEN= ;;
esac
SCRIPT_DIR=$(dirname "${SCRIPT_FILENAME:-$0}")
ASSET_REV=$(cksum "${SCRIPT_DIR}/index.html" | cut -d ' ' -f 1)
case "${ASSET_REV}" in
    *[!0-9]*) ASSET_REV=0 ;;
esac
printf 'Content-Type: application/javascript\r\nCache-Control: no-store, no-cache, must-revalidate, max-age=0\r\nPragma: no-cache\r\nExpires: 0\r\n\r\n'
printf 'window.PS3NETSRV_PLUS_SYNO_TOKEN = "%s";\n' "${TOKEN}"
printf 'window.PS3NETSRV_PLUS_ASSET_REV = "%s";\n' "${ASSET_REV}"
cat "${SCRIPT_DIR}/launcher.js"
