#!/bin/sh

# Package
PACKAGE="pyload"
DNAME="pyLoad"

PIDFILE="/var/run/pyload.pid"
PYLOADCORE="/usr/local/python/bin/python /usr/local/pyload/share/pyload/pyLoadCore.py --pidfile=${PIDFILE}"
export PATH="/usr/local/pyload/bin:$PATH"

case $1 in
    start)
        if [ -f /usr/syno/etc/ssl/ssl.crt/server.crt -a \
             -f /usr/syno/etc/ssl/ssl.key/server.key ]; then
            ln -s /usr/syno/etc/ssl/ssl.crt/server.crt /usr/local/pyload/etc/ssl.crt
            ln -s /usr/syno/etc/ssl/ssl.key/server.key /usr/local/pyload/etc/ssl.key
            sed -i -e 's/bool https : "Use HTTPS" = \(True|False\)/bool https : "Use HTTPS" = True/' /usr/local/pyload/etc/pyload.conf
        else
            sed -i -e 's/bool https : "Use HTTPS" = \(True|False\)/bool https : "Use HTTPS" = False/' /usr/local/pyload/etc/pyload.conf
        fi
        ${PYLOADCORE} --daemon
        ;;
    stop)
        test "${SYNOPKG_TEMP_LOGFILE}" && exec >${SYNOPKG_TEMP_LOGFILE}
        ${PYLOADCORE} --quit
        ;;
    status)
        test -f /usr/local/pyload/etc/pyload.conf || exit 150
        ${PYLOADCORE} --status && exit 0
        test -f ${PIDFILE} && exit 1
        ;;
    log)
        if [ -f /usr/local/pyload/etc/Logs/log.txt ]; then
            echo "/usr/local/pyload/etc/Logs/log.txt"
        else
            exit 1
        fi
        ;;
    *)
        exit 1
        ;;
esac
