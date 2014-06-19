#!/bin/sh

#Package
PACKAGE="zabbixagent"
DNAME="Zabbix Agent"

#Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"


#Zabbix Others
ZABBIX_AGENTD="${INSTALL_DIR}/sbin/z_agent_start_stop.sh"
AGENTD_PID_FILE="${INSTALL_DIR}/var/zabbix_agentd.pid"
AGENT_FILE="${INSTALL_DIR}/var/agent.enabled"

start ()
{
   
#Main start, stop scripts
    if [ -f ${AGENT_FILE} ]; then
        ${ZABBIX_AGENTD} start
    fi

}

stop ()
{
    kill `cat ${AGENTD_PID_FILE}`
    wait_for_status 1 20
    if [ $? -eq 1 ]; then
        kill -9 `cat ${AGENTD_PID_FILE}`
    fi
    rm -f ${AGENTD_PID_FILE}
    rm -f ${ZABBIX_UI}
}

case $1 in
    start)
        start
        exit 0
    ;;
    stop)
        stop
        exit 0
    ;;
    status)
        exit 0
    ;;
    log)
        exit 0
    ;;
esac