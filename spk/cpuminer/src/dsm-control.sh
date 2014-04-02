#!/bin/sh

# Package
PACKAGE="cpuminer"
DNAME="CPUMiner"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
USER="cpuminer"
CPUMINER="${INSTALL_DIR}/bin/minerd"
CFG_FILE="${INSTALL_DIR}/var/settings.json"
LOG_FILE="${INSTALL_DIR}/var/cpuminer.log"
DAEMON_MINER="minerd"

start_daemon ()
{
    su - ${USER} -c "${CPUMINER} -c ${CFG_FILE} 2> ${LOG_FILE}"
}

stop_daemon ()
{
    PIDS=`pidof ${DAEMON_MINER}`
    kill ${PIDS}
    wait_for_status 1 20 || kill -9 ${PIDS}
}

daemon_status ()
{
    if [ [ -z `pidof ${DAEMON_MINER}` ] ] then
        return
    fi
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
    restart)
        stop_daemon
        start_daemon
        exit $?
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
