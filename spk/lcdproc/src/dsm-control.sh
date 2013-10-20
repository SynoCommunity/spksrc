#!/bin/sh

# Package
PACKAGE="lcdproc"
DNAME="lcdproc"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${PATH}:${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
DAEMON="${INSTALL_DIR}/sbin/LCDd"
CLIENT="${INSTALL_DIR}/bin/lcdproc"
#PID_FILE="/var/run/lcdproc.pid"
CONF_FILE="${INSTALL_DIR}/etc/LCDd.conf"
LOG_FILE="${INSTALL_DIR}/lcdproc.log"
PID=`pidof LCDd`
PID_CLIENT=`pidof lcdproc`

start_daemon ()
{
    ${DAEMON} -c ${CONF_FILE}
    sleep 1
    ${CLIENT}
}

stop_daemon ()
{
    if daemon_status; then
        echo Stopping ${DNAME} ...
	kill ${PID}
        wait_for_status 1 20 || kill -9 ${PID}
    else
        echo ${DNAME} is not running
        exit 0
    fi

    test -e ${PID_FILE} || rm -f ${PID_FILE}
}

daemon_status ()
{
    if [ ! -z "${PID}" ] && kill -0 $PID > /dev/null 2>&1; then
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
            stop_daemon
            exit $?
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
    log)
        echo ${LOG_FILE}
        ;;
    *)
        exit 1
        ;;
esac
