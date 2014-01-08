#!/bin/sh

# Package
PACKAGE="etherpad"
DNAME="Etherpad"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
NODE_DIR="/usr/local/node"
PATH="${INSTALL_DIR}/bin:${NODE_DIR}/bin:${PATH}"
USER="etherpad"
ETHERPAD="${INSTALL_DIR}/share/etherpad/bin/run.sh"
CFG_FILE="settings.json"
PID_FILE="${INSTALL_DIR}/var/etherpad.pid"
LOG_FILE="${INSTALL_DIR}/var/log/etherpad.log"


start_daemon ()
{
    su - ${USER} -c "PATH=${PATH} ${ETHERPAD} -s ${CFG_FILE}" & > /dev/null 2>&1
    sleep 10
    ps -w | grep ${ETHERPAD} | grep -v grep |awk '{print $1}' > ${PID_FILE}

}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
    kill `ps -w | grep "etherpad/node_modules/ep_etherpad-lite/node/server.js" | grep -v grep |awk '{print $1}'` > /dev/null 2>&1
    rm -f ${PID_FILE}
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
        else
            echo Starting ${DNAME} ...
            start_daemon
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
        else
            echo ${DNAME} is not running
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
        ;;
    *)
        exit 1
        ;;
esac

