#!/bin/sh

# Package
PACKAGE="squidguard"
DNAME="SquidGuard"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="squid"
SQUID="${INSTALL_DIR}/sbin/squid"
PID_FILE="${INSTALL_DIR}/var/run/squid.pid"
CFG_FILE="${INSTALL_DIR}/etc/squid.conf"
CLAMD="/var/packages/AntiVirus/target/engine/clamav/sbin/clamd"
CLAMD_CFG="${INSTALL_DIR}/etc/clamd.conf"
CLAMD_PID="${INSTALL_DIR}/var/run/clamd/clamd.pid"
CICAP="${INSTALL_DIR}/bin/c-icap"
CICAP_CFG="${INSTALL_DIR}/etc/c-icap.conf"
CICAP_PID="${INSTALL_DIR}/var/run/c-icap/c-icap.pid"

start_daemon ()
{
    # launch clamd
    nohup ${CLAMD} -c ${CLAMD_CFG} &
    
    # launch c-icap
    ${CICAP} -f ${CICAP_CFG}
       
    # launch squid
    su - ${RUNAS} -c "${SQUID} -f ${CFG_FILE}"
}

stop_daemon ()
{
    # stop squid
    su - ${RUNAS} -c "${SQUID} -f ${CFG_FILE} -k shutdown"
    wait_for_status 1 20
    
    # stop c-icap
    kill `cat ${CICAP_PID}`

    # stop clamd
    kill `ps -w | grep clamd | grep squid | cut -b 1-5`
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && [ -d /proc/`cat ${PID_FILE}` ]; then
        return
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
        sleep 3
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

