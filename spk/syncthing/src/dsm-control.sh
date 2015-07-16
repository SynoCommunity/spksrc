#!/bin/sh

# Package
PACKAGE="syncthing"
DNAME="Syncthing"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="syncthing"
SYNCTHING="${INSTALL_DIR}/bin/syncthing"
CONFIG_DIR="${INSTALL_DIR}/var/"


start_daemon ()
{
    start-stop-daemon -b -o -c ${USER} -S -u ${USER} -x env HOME=${CONFIG_DIR} ${SYNCTHING} -- --home ${CONFIG_DIR}
}

stop_daemon ()
{
    start-stop-daemon -o -c ${USER} -K -u ${USER} -x ${SYNCTHING}
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -x ${SYNCTHING}
}

daemon_status ()
{
    start-stop-daemon -K -q -t -u ${USER}
    [ $? -eq 0 ] || return 1
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
