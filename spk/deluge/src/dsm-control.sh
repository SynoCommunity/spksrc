#!/bin/sh

# Package
PACKAGE="deluge"
DNAME="Deluge"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/${PATH}"
USER="deluge"
GROUP="users"
PYTHON="${INSTALL_DIR}/env/bin/python"
DELUGED="${INSTALL_DIR}/env/bin/deluged"
DELUGE_WEB="${INSTALL_DIR}/env/bin/deluge-web"
CFG_DIR="${INSTALL_DIR}/var/"
DELUGED_PID="${INSTALL_DIR}/var/deluged.pid"
DELUGE_WEB_PID="${INSTALL_DIR}/var/deluge-web.pid"
DELUGED_LOG="${INSTALL_DIR}/var/deluged.log"
DELUGE_WEB_LOG="${INSTALL_DIR}/var/deluge-web.log"
PYTHON_EGG_CACHE="${INSTALL_DIR}/env/cache"


start_daemon ()
{
    start-stop-daemon -S -q -x env PYTHON_EGG_CACHE=${PYTHON_EGG_CACHE} ${DELUGED} -c ${USER} -u ${USER} -p ${DELUGED_PID} \
      -- --config ${CFG_DIR} --logfile ${DELUGED_LOG} --loglevel info --pidfile ${DELUGED_PID}
    sleep 3
    start-stop-daemon -S -q -b -m -x env PYTHON_EGG_CACHE=${PYTHON_EGG_CACHE} ${DELUGE_WEB} -c ${USER} -u ${USER} -p ${DELUGE_WEB_PID} \
      -- --config ${CFG_DIR} --logfile ${DELUGE_WEB_LOG} --loglevel info
}

stop_daemon ()
{
    start-stop-daemon -K -q -u ${USER} -p ${DELUGE_WEB_PID}
    start-stop-daemon -K -q -u ${USER} -p ${DELUGED_PID}
    wait_for_status 1 20
    if [ $? -eq 1 ]; then
        start-stop-daemon -K -s 9 -q -u ${USER} -p ${DELUGE_WEB_PID}
        start-stop-daemon -K -s 9 -q -u ${USER} -p ${DELUGED_PID}
    fi
    rm -f ${DELUGED_PID} ${DELUGE_WEB_PID}
}

daemon_status ()
{
    start-stop-daemon -K -q -t -u ${USER} -p ${DELUGE_WEB_PID}
    DELUGE_WEB_RETVAL=$?
    start-stop-daemon -K -q -t -u ${USER} -p ${DELUGED_PID}
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
        echo ${DELUGED_LOG}
        ;;
    *)
        exit 1
        ;;
esac
