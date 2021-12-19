#!/bin/sh

BIN_FILE="${SYNOPKG_PKGDEST}/bin/ps3netsrv"

if [ -r "${CFG_FILE}" ]; then
    . "${CFG_FILE}"
fi

/bin/stdbuf --output=L --error=L ${BIN_FILE} "${PS3_DIR}" "${SERVICE_PORT}" 2>&1 &
echo "$!" > "${PID_FILE}"
