#!/bin/sh

# Package
PACKAGE="cpuminer"
DNAME="CPUMiner"
# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="cpuminer"
LOG_FILE="${INSTALL_DIR}/var/cpuminer.log"
PID_FILE="${INSTALL_DIR}/var/cpuminer.pid"
DAEMON="${INSTALL_DIR}/bin/minerd"
OPTIONS="-c ${INSTALL_DIR}/var/settings.json -t 1"

start_daemon ()
{
    start-stop-daemon -S -q -m -b -N 10 -c ${USER} -u ${PACKAGE} -p ${PID_FILE} -x ${DAEMON} -- ${OPTIONS} 2> ${LOG_FILE}
}

stop_daemon ()
{
    start-stop-daemon -K -q -u ${PACKAGE} -p ${PID_FILE}
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -p ${PID_FILE}
}

daemon_status ()
{
    start-stop-daemon -K -q -t -u ${PACKAGE} -p ${PID_FILE}
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
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
