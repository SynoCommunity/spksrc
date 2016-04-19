#!/bin/sh
#
# with WIZARD_FILES select log file or not
#

# Package
PACKAGE="gogs"
DNAME="Gogs"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
DIR_GOGS="${INSTALL_DIR}/gogs"
GOGS="${DIR_GOGS}/gogs"
PID_FILE="/var/run/gogs.pid"
LOG_FILE="/var/log/gogs.log"

FILE_CREATE_LOG="${DIR_GOGS}/wizard_create_log"

export HOME=${DIR_GOGS}
#export PATH=$PATH:~/opt/bin  # to Git. Not necessary with Git Server (Synology)
export USER=root
export USERNAME=root

start_daemon ()
{
    if [ -e ${FILE_CREATE_LOG} ]; then
        ${GOGS} web > ${LOG_FILE} 2>&1 &
    else
        ${GOGS} web > /dev/null 2>&1 &
    fi
    echo $! > ${PID_FILE}
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
    rm -f ${PID_FILE}
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && kill -0 `cat ${PID_FILE}` > /dev/null 2>&1; then
        return
    fi
    rm -f ${PID_FILE}
    return 1
}

wait_for_status ()
{
    counter=$2
    while [ ${counter} -gt 0 ]; do
        daemon_status
        [ $? -eq $1 ] && return
        let counter=counter-1
        sleep 1
    done
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
    restart)
        stop_daemon
        start_daemon
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
