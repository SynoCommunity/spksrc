#!/bin/sh
# Dark Mode for DSM: package start, stop and status. There is no daemon:
# starting rebuilds the dark stylesheet in the background and marks the theme
# as active. DSM starts the desktop part (taskbar button, user choice) only
# while the package runs; stopping the package turns the theme off.

FLAG="${SYNOPKG_PKGVAR}/enabled"

case "$1" in
    start)
        touch "${FLAG}"
        # At boot the web server may still be starting: allow retries.
        setsid "${SYNOPKG_PKGDEST}/bin/darkmode-regen" 30 </dev/null >/dev/null 2>&1 &
        exit 0
        ;;
    stop)
        rm -f "${FLAG}"
        # DSM keeps linking ui/style.css while the package is stopped: leave
        # an empty dark block there (the next start rebuilds the theme).
        "${SYNOPKG_PKGDEST}/bin/darkmode-regen" --off
        exit 0
        ;;
    status)
        [ -f "${FLAG}" ] && exit 0
        exit 3
        ;;
    log)
        echo "${SYNOPKG_PKGVAR}/regen.log"
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
