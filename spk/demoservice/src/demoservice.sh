#!/bin/sh

PORT=$1
PID_FILE=$2
echo "Starting python -m SimpleHTTPServer ${PORT} at ${SYNOPKG_PKGDEST}"
cd "${SYNOPKG_PKGDEST}"
python -m SimpleHTTPServer ${PORT} &
echo "$!" > "${PID_FILE}"
