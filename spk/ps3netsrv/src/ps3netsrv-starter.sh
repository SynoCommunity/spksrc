#!/bin/sh

BIN_FILE="${SYNOPKG_PKGDEST}/bin/ps3netsrv"

if [ -r "${CFG_FILE}" ]; then
    . "${CFG_FILE}"
fi

/bin/stdbuf -o L -e L ${BIN_FILE} "${PS3_DIR}" 2>&1 &
echo "$!" > "${PID_FILE}"
