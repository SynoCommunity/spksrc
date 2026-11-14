#!/bin/sh
# The package has no daemon: "start" rebuilds the tiles from the state kept in var/.
FLAG="${SYNOPKG_PKGVAR}/running"
PYTHON=/usr/bin/python3

case "$1" in
  start)
    if [ ! -x "$PYTHON" ]; then
      [ -n "$SYNOPKG_TEMP_LOGFILE" ] && echo "Cattport needs Python 3, which this DSM doesn't include." >> "$SYNOPKG_TEMP_LOGFILE"
      exit 1
    fi
    "$PYTHON" "${SYNOPKG_PKGDEST}/lib/cattport_start.py" || exit 1
    touch "$FLAG"
    exit 0
    ;;
  stop)
    rm -f "$FLAG"
    exit 0
    ;;
  status)
    [ -f "$FLAG" ] && exit 0
    exit 3
    ;;
  *)
    exit 1
    ;;
esac
