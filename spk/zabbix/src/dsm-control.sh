#!/bin/sh

# Package
PACKAGE="zabbix"
DNAME="Zabbix"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"


# Zabbix Others
ZABBIX_SERVER="${INSTALL_DIR}/sbin/z_server_start_stop.sh"
ZABBIX_PROXY="${INSTALL_DIR}/sbin/z_proxy_start_stop.sh"
ZABBIX_AGENTD="${INSTALL_DIR}/sbin/z_agent_start_stop.sh"

SERVER_PID_FILE="${INSTALL_DIR}/var/zabbix_server.pid"
PROXY_PID_FILE="${INSTALL_DIR}/var/zabbix_proxy.pid"
AGENTD_PID_FILE="${INSTALL_DIR}/var/zabbix_agentd.pid"

SERVER_FILE="${INSTALL_DIR}/var/server.enabled"
PROXY_FILE="${INSTALL_DIR}/var/proxy.enabled"
AGENT_FILE="${INSTALL_DIR}/var/agent.enabled"

start ()
{
# Main start, stop scripts
    if [ -f ${SERVER_FILE} ]; then
        ${ZABBIX_SERVER} start
    fi
    if [ -f ${PROXY_FILE} ]; then
        ${ZABBIX_PROXY} start
    fi
    if [ -f ${AGENT_FILE} ]; then
        ${ZABBIX_AGENTD} start
    fi
}

stop ()
{
    kill `cat ${SERVER_PID_FILE}`
    kill `cat ${PROXY_PID_FILE}`
    kill `cat ${AGENTD_PID_FILE}`
    wait_for_status 1 20
    if [ $? -eq 1 ]; then
        kill -9 `cat ${SERVER_PID_FILE}`
        kill -9 `cat ${PROXY_PID_FILE}`
        kill -9 `cat ${AGENTD_PID_FILE}`
    fi
    rm -f ${SERVER_PID_FILE} ${PROXY_PID_FILE} ${AGENTD_PID_FILE}
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