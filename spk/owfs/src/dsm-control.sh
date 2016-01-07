#!/bin/sh

# Package
PACKAGE="owfs"
DNAME="OWFS"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="owfs"
OW_SERVER="${INSTALL_DIR}/bin/owserver"
SERV_PID_FILE="${INSTALL_DIR}/var/owserver.pid"

OW_HTTPD="${INSTALL_DIR}/bin/owhttpd"
HTTPD_PID_FILE="${INSTALL_DIR}/var/owhttpd.pid"

start_daemon ()
{
    su - ${USER} -c "PATH=${PATH} ${OW_SERVER} -c ${INSTALL_DIR}/var/owfs.conf --pid-file ${SERV_PID_FILE}"
    sleep 1
    su - ${USER} -c "PATH=${PATH} ${OW_HTTPD} -c ${INSTALL_DIR}/var/owfs.conf --pid-file ${HTTPD_PID_FILE}"
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
    if [ -f ${HTTPD_PID_FILE} ] && kill -0 `cat ${HTTPD_PID_FILE}` > /dev/null 2>&1; then
        if [ -f ${SERV_PID_FILE} ] && kill -0 `cat ${SERV_PID_FILE}` > /dev/null 2>&1; then
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


