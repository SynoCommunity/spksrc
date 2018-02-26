#!/bin/sh

# Source package specific variable and functions
SVC_SETUP=`dirname $0`"/service-setup"
if [ -r "${SVC_SETUP}" ]; then
    . "${SVC_SETUP}"
fi

# Default display name
DNAME="${SYNOPKG_PKGNAME}"

# Others
RTORRENT="${SYNOPKG_PKGDEST}/bin/rtorrent"
PID_FILE="${SYNOPKG_PKGDEST}/var/rtorrent.pid"
LOG_FILE="${SYNOPKG_PKGDEST}/var/rtorrent.log"


start_daemon ()
{
    export HOME=${SYNOPKG_PKGDEST}/var
    start-stop-daemon -S -q -m -b -N 10 -x screen -p ${PID_FILE} -- -D -m ${RTORRENT}
}

stop_daemon ()
{
    start-stop-daemon -K -q -p ${PID_FILE}
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -p ${PID_FILE}
}

daemon_status ()
{
    start-stop-daemon -K -q -t -p ${PID_FILE}
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
            echo "${DNAME} is already running"
            exit 0
        else
            echo "Starting ${DNAME} ..."
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            echo "Stopping ${DNAME} ..."
            stop_daemon
            exit $?
        else
            echo "${DNAME} is not running"
            exit 0
        fi
        ;;
    status)
        if daemon_status; then
            echo "${DNAME} is running"
            exit 0
        else
            echo "${DNAME} is not running"
            exit 1
        fi
        ;;
    log)
        if [ -n "${LOG_FILE}" -a -r "${LOG_FILE}" ]; then
            echo "${LOG_FILE}"
        fi
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
