#!/bin/sh

# Package
PACKAGE="museek-plus"
DNAME="Museek+"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="root"
MUSEEKD="${INSTALL_DIR}/bin/museekd"
CFG_FILE="${INSTALL_DIR}/var/config.xml"
PID_FILE="${INSTALL_DIR}/var/museekd.pid"

start_daemon ()
{
    export LD_LIBRARY_PATH=${INSTALL_DIR}/lib
    start-stop-daemon -S -q -m -b -x ${MUSEEKD} -c ${USER} -u ${USER} -p ${PID_FILE} -- \
      -c ${CFG_FILE}
}

stop_daemon ()
{
    start-stop-daemon -K -q -u ${USER} -p ${PID_FILE}
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -p ${PID_FILE}
}

daemon_status ()
{
    start-stop-daemon -K -q -t -u ${USER} -p ${PID_FILE}
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
            exit 0
        else
            echo Starting ${DNAME} ...
            start_daemon
            exit 0
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
    *)
        exit 1
        ;;
esac
