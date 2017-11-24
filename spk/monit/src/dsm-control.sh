#!/bin/sh

# Package
PACKAGE="monit"
DNAME="Monit"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
CFG_FILE="${INSTALL_DIR}/var/monitrc"
PID_FILE="${INSTALL_DIR}/var/monit.pid"
LOG_FILE="${INSTALL_DIR}/var/monit.log"


start_daemon ()
{
    #run as root with verbose logging
    PATH=${PATH} monit -c ${CFG_FILE} -l ${LOG_FILE}
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
    reload)
        if daemon_status; then
            echo reloading ${DNAME} config ...
            PATH=${PATH} monit -c ${CFG_FILE} -l ${LOG_FILE} reload
        else
            echo ${DNAME} is not running
        fi
        ;;
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
