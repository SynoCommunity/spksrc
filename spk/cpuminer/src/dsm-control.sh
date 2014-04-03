#!/bin/sh

# Package
PACKAGE="cpuminer"
DNAME="CPUMiner"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="cpuminer"
CPUMINER="${INSTALL_DIR}/bin/minerd"
CFG_FILE="${INSTALL_DIR}/var/settings.json"
LOG_FILE="${INSTALL_DIR}/var/cpuminer.log"
DAEMON_MINER="minerd"

start_daemon ()
{
    su - ${USER} -c "${CPUMINER} -c ${CFG_FILE} -t 1 2> ${LOG_FILE}"
}

stop_daemon ()
{
    PIDS=`pidof ${DAEMON_MINER}`
    kill ${PIDS}
    wait_for_status 1 20 || kill -9 ${PIDS}
}

daemon_status ()
{

    PIDS=`pidof ${DAEMON_MINER}`
    if [ -z "$PIDS" ]; then
        return 1
    fi
    return
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
