#!/bin/sh

# Package
PACKAGE="boxbackup-client"
DNAME="Box Backup Client"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:${PATH}"
USER="root"
BBACKUPD="${INSTALL_DIR}/sbin/bbackupd"
CFG_FILE="${INSTALL_DIR}/var/bbackupd.conf"
PID_FILE="${INSTALL_DIR}/var/run/bbackupd.pid"


start_daemon ()
{
    if [ -f ${CFG_FILE} ]; then
        su ${USER} -s /bin/sh -c "${BBACKUPD} -c ${CFG_FILE}"
    else
        echo "Use /usr/local/boxbackup-client/sbin/syno-bbackupd-config to configure Box Backup Client" >&2
    fi
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
