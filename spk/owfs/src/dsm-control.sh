#!/bin/sh

# Package
PACKAGE="owfs"
DNAME="OWFS"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"

OW_SERVER="${INSTALL_DIR}/bin/owserver"
SERV_PID_FILE="${INSTALL_DIR}/var/owserver.pid"

OW_HTTPD="${INSTALL_DIR}/bin/owhttpd"
HTTPD_PID_FILE="${INSTALL_DIR}/var/owhttpd.pid"

start_daemon ()
{
    ${OW_SERVER} -c ${INSTALL_DIR}/var/owfs.conf --pid-file ${SERV_PID_FILE}
    sleep 1
    ${OW_HTTPD} -c ${INSTALL_DIR}/var/owfs.conf --pid-file ${HTTPD_PID_FILE}
    sleep 1
}

stop_daemon ()
{
    kill `cat ${HTTPD_PID_FILE}`
    wait_for_status 1 20
    rm -f ${HTTPD_PID_FILE}
    kill `cat ${SERV_PID_FILE}`
    wait_for_status 1 20
    rm -f ${SERV_PID_FILE}
}

daemon_status ()
{
    if [ -f ${HTTPD_PID_FILE} ] && [ -d /proc/`cat ${HTTPD_PID_FILE}` ]; then
        if [ -f ${SERV_PID_FILE} ] && [ -d /proc/`cat ${SERV_PID_FILE}` ]; then
            return
        fi
    fi
    return 1
}

wait_for_status ()
{
    counter=$2
    while [ ${counter} -gt 0 ]; do
        daemon_status
        [ $? -eq $1 ] && break
        let counter=counter-1
        sleep 1
    done
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


