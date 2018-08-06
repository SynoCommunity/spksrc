#!/bin/sh

case $1 in
    start)
        cp $SYNOPKG_PKGDEST/39-libimobiledevice.rules /usr/lib/udev/rules.d/
        udevadm control --reload-rules
        exit 0
        ;;
    stop)
        rm -f /usr/lib/udev/rules.d/39-libimobiledevice.rules
        udevadm control --reload-rules
        exit 0
        ;;
    status)
        ### Check package alive.
        if [ -e /usr/lib/udev/rules.d/39-libimobiledevice.rules ]; then
            exit 0
        else
            exit 1
        fi
        ;;
    log)
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
