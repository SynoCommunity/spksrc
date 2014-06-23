#!/bin/sh

# Package
PACKAGE="dnsmasqproxy"
DNAME="DnsMasq Proxy"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="root"

DNSMASQ_SERVER="${INSTALL_DIR}/sbin/dnsmasq"
DNSMASQ_CONF="${INSTALL_DIR}/etc/dnsmasq.conf"
DNSMASQ_DNSLEASE="${INSTALL_DIR}/var/dnsmasq.lease"
LOG_FILE="${INSTALL_DIR}/var/dnsmasq.log"
SERVER_PID_FILE="${INSTALL_DIR}/var/dnsmasq.pid"



start_daemon ()
{
    # auto creates the ip address to match the synology nas ip
    sed -i '/^dhcp-range/d' ${DNSMASQ_CONF}
    echo "dhcp-range=`hostname -i`,proxy" >> ${DNSMASQ_CONF}

    # bootup
    ${DNSMASQ_SERVER} --user=${USER} --conf-file=${DNSMASQ_CONF} --dhcp-leasefile=${DNSMASQ_DNSLEASE} --log-facility=${LOG_FILE} --pid-file=${SERVER_PID_FILE}
}


stop_daemon ()
{
    kill `cat ${SERVER_PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${SERVER_PID_FILE}`
    rm -f ${SERVER_PID_FILE}
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
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
