#!/bin/sh

DNAME="ZeroTier"
PACKAGE="zerotier"
INSTALL_DIR="/usr/local/${PACKAGE}"
ZT_HOME_DIR="/var/lib/zerotier-one"
ZEROTIER="${INSTALL_DIR}/bin/zerotier-one"
WATCHDOG="${INSTALL_DIR}/bin/zerotier-watchdog.sh"
PID_FILE="${ZT_HOME_DIR}/zerotier-one.pid"
LOG_FILE="/var/log/zerotier-one.log"

start_daemon ()
{
    ${WATCHDOG} stop ;
    ${WATCHDOG} start ;
    sleep 1
    echo "starting" ${SYNOPKG_PKGDEST} >> ${LOG_FILE}
    ${SYNOPKG_PKGDEST}/bin/zerotier-one -d ;
    echo $! >> ${PID_FILE}
}

stop_daemon ()
{
    ${WATCHDOG} stop ;
    pkill zerotier-one
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


case "$1" in
  start)
    if ( pidof zerotier-one ); then 
        echo "${DNAME} is already running"
    else
        echo "$(date) Starting ${DNAME} " >> ${LOG_FILE}
        echo "Starting ${DNAME} " ;
        start_daemon
        echo "$(date) Started ZeroTier" >> ${LOG_FILE} ;
    fi
    ;;
  stop)
    if ( pidof zerotier-one ); then
        echo "$(date) Stopping ${DNAME}" >> ${LOG_FILE}
        echo "Stopping ${DNAME}"
        stop_daemon
        echo "$(date) Stopped ZeroTier" >> ${LOG_FILE} ;
    else
        echo "${DNAME} is not running" ;
    fi
    ;;
  status)
    if ( pidof zerotier-one ); then
        echo "${DNAME} is running."
        exit 0
    else 
        echo "${DNAME} is not running"
        exit 1
    fi
    ;;
  *)
    echo "Usage: /etc/init.d/zerotier {start|stop|status}"
    exit 1
    ;;
esac

