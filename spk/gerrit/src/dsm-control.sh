#!/bin/sh

# Package
PACKAGE="gerrit"
DNAME="Gerrit"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${GIT_DIR}/bin:${PATH}"
USER="gerrit"
PID_FILE="${INSTALL_DIR}/logs/gerrit.pid"
LOG_FILE="${INSTALL_DIR}/logs/error_log"

start_daemon ()
{
    su ${USER} -c "PATH=${PATH} ${INSTALL_DIR}/bin/gerrit.sh start"
}

stop_daemon ()
{
    su ${USER} -c "PATH=${PATH} ${INSTALL_DIR}/bin/gerrit.sh stop"
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && kill -0 `cat ${PID_FILE}` >/dev/null 2>&1; then
        return
    fi
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

