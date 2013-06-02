#!/bin/sh

# Package
PACKAGE="apt-mirror"
DNAME="APT Mirror"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:$PATH"
RUN_FILE="${INSTALL_DIR}/var/spool/apt-mirror/var/apt-mirror.lock"
LOG_FILE="${INSTALL_DIR}/var/spool/apt-mirror/var/archive-log.0"

start_daemon ()
{
    apt-mirror ${INSTALL_DIR}/etc/mirror.list &
}

stop_daemon ()
{
    kill `pidof apt-mirror`
    rm -f ${RUN_FILE}
}

daemon_status ()
{
    if kill -0 `pidof apt-mirror` > /dev/null 2>&1; then
        return
    fi
    rm -f ${RUN_FILE}
    return 1
}

case $1 in
    start)
        if daemon_status; then
            echo ${DNAME} is already running
        else
            echo Starting ${DNAME} ...
            start_daemon
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
        else
            echo ${DNAME} is not running
        fi
        ;;
    status)
        if daemon_status; then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    log)
        echo ${LOG_FILE}
        ;;
    *)
        exit 1
        ;;
esac
