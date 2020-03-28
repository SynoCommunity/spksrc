#!/bin/sh

# Default display name
DNAME="${SYNOPKG_PKGNAME}"

# Source package specific variable and functions
SVC_SETUP=`dirname $0`"/service-setup"
if [ -r "${SVC_SETUP}" ]; then
    . "${SVC_SETUP}"
fi

# Required variables to start both processes
# We use Generic Service variables for main deamon
DELUGED="${SYNOPKG_PKGDEST}/env/bin/deluged"
DELUGE_WEB="${SYNOPKG_PKGDEST}/env/bin/deluge-web"
CFG_DIR="${SYNOPKG_PKGDEST}/var/"
PYTHON_EGG_CACHE="${SYNOPKG_PKGDEST}/env/cache"
DELUGE_WEB_PID="${SYNOPKG_PKGDEST}/var/deluge-web.pid"
DELUGE_WEB_LOG="${SYNOPKG_PKGDEST}/var/deluge-web.log"


# We do not need to specify a user,
# since this file is run as the package user anyway
start_daemon ()
{
    # make sure both daemons are stopped
    stop_daemon
    
    start-stop-daemon -S -q -x env PYTHON_EGG_CACHE=${PYTHON_EGG_CACHE} ${DELUGED} \
      -- --config ${CFG_DIR} --logfile ${LOG_FILE} --loglevel info --pidfile ${PID_FILE}
    sleep 3
    start-stop-daemon -S -q -x env PYTHON_EGG_CACHE=${PYTHON_EGG_CACHE} ${DELUGE_WEB} \
      -- --config ${CFG_DIR} --logfile ${DELUGE_WEB_LOG} --loglevel info --pidfile ${DELUGE_WEB_PID}
}

stop_daemon ()
{
    start-stop-daemon -K -q -p ${DELUGE_WEB_PID}  > /dev/null  2>&1
    start-stop-daemon -K -q -p ${PID_FILE}        > /dev/null  2>&1
    wait_for_status 1 20
    if [ $? -eq 1 ]; then
        start-stop-daemon -K -s 9 -q -p ${DELUGE_WEB_PID}  > /dev/null  2>&1
        start-stop-daemon -K -s 9 -q -p ${PID_FILE}        > /dev/null  2>&1
    fi
    rm -f ${PID_FILE} ${DELUGE_WEB_PID}
}

daemon_status ()
{
    start-stop-daemon -K -q -t -p ${DELUGE_WEB_PID}  > /dev/null  2>&1
    DELUGE_WEB_RETVAL=$?
    start-stop-daemon -K -q -t -p ${PID_FILE}        > /dev/null  2>&1
    DELUGED_RETVAL=$?
    [ ${DELUGED_RETVAL} -eq 0 -a ${DELUGE_WEB_RETVAL} -eq 0 ] || return 1
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
