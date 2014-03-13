#!/bin/sh

# Package
PACKAGE="zabbix"
DNAME="Zabbix Server"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="${PACKAGE}server"

# Zabbix Others
ZABBIX_SERVER="${INSTALL_DIR}/sbin/zabbix_server"
SERVER_PID_FILE="${INSTALL_DIR}/var/zabbix_server.pid"
LOG_FILE="${INSTALL_DIR}/var/zabbix_server.log"
SERVER_FILE="${INSTALL_DIR}/var/server.enabled"


start_daemon ()
{
    echo -e "" > ${SERVER_FILE}
    su - ${USER} -c "LD_LIBRARY_PATH=${INSTALL_DIR}/lib:${INSTALL_DIR}/lib/mysql ${ZABBIX_SERVER}"
}

stop_daemon ()
{
    kill `cat ${SERVER_PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${SERVER_PID_FILE}`
    rm -f ${SERVER_PID_FILE}
    rm -f ${SERVER_FILE}
}

daemon_status ()
{
    if [ -f ${SERVER_PID_FILE} ] && kill -0 `cat ${SERVER_PID_FILE}` > /dev/null 2>&1; then
        return
    fi
    rm -f ${SERVER_PID_FILE}
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
        exit 0
        ;;
     log)
        exit 0
        ;;
esac
