#!/bin/sh

# Package
PACKAGE="iodine"
DNAME="iodine"

# Others
INSTALL_DIR="/var/packages/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
PID_FILE="${INSTALL_DIR}/iodine.pid"
DAEMON=${INSTALL_DIR}/target/sbin/iodined
LIB=${INSTALL_DIR}/target/lib
CONFIG=${INSTALL_DIR}/etc/config

start_daemon ()
{
    . ${CONFIG}
    LD_LIBRARY_PATH=${LIB} ${DAEMON} -u nobody -P ${PASSWORD} -F ${PID_FILE} ${IP} ${TOPDOMAIN}
    /sbin/iptables -A POSTROUTING -t nat -s ${IP} -j MASQUERADE
}

stop_daemon ()
{
    . ${CONFIG}
    kill `cat ${PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
    rm -f ${PID_FILE}
    /sbin/iptables -D POSTROUTING -t nat -s ${IP} -j MASQUERADE
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
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
