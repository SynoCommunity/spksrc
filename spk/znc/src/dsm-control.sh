#!/bin/sh

# Package
PACKAGE="znc"
DNAME="ZNC"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="znc"
ZNC="${INSTALL_DIR}/bin/znc"
PID_FILE="${INSTALL_DIR}/var/znc.pid"


start_daemon ()
{
    su - ${RUNAS} -c "${ZNC} -d ${INSTALL_DIR}/var"
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && [ -d /proc/`cat ${PID_FILE}` ]; then
        return 0
    fi
    return 1
}


case $1 in
    start)
        if daemon_status; then
            echo ${DNAME} is already running
            exit 0
        else
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
            exit $?
        else
            echo ${DNAME} is not running
            exit 0
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
        exit 0
        ;;
    *)
        exit 1
        ;;
esac

