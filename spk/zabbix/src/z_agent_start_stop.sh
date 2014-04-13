#!/bin/sh

# Package
PACKAGE="zabbix"
DNAME="Zabbix Agent"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="${PACKAGE}agent"

# Zabbix Others
ZABBIX_AGENTD="${INSTALL_DIR}/sbin/zabbix_agentd"
AGENTD_PID_FILE="${INSTALL_DIR}/var/zabbix_agentd.pid"
LOG_FILE="${INSTALL_DIR}/var/zabbix_agentd.log"
AGENT_FILE="${INSTALL_DIR}/var/agent.enabled"


start_daemon ()
{
    echo -e "" > ${AGENT_FILE}
    su - ${USER} -c "${ZABBIX_AGENTD}"
}

stop_daemon ()
{
    kill `cat ${AGENTD_PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${AGENTD_PID_FILE}`
    rm -f ${AGENTD_PID_FILE}
    rm -f ${AGENT_FILE}
}

daemon_status ()
{
    if [ -f ${AGENTD_PID_FILE} ] && kill -0 `cat ${AGENTD_PID_FILE}` > /dev/null 2>&1; then
        return
    fi
    rm -f ${AGENTD_PID_FILE}
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
