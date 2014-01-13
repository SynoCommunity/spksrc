#!/bin/sh

# Package
PACKAGE="etherpad"
DNAME="Etherpad"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
NODE_DIR="/usr/local/node"
PATH="${INSTALL_DIR}/bin:${NODE_DIR}/bin:${PATH}"
USER="etherpad"
INSTALLDEPS="${INSTALL_DIR}/share/etherpad/bin/installDeps.sh"
ETHERPAD_PID="${INSTALL_DIR}/var/etherpad.pid"
NODE_PID="${INSTALL_DIR}/var/node.pid"
LOG_FILE="${INSTALL_DIR}/var/log/etherpad.log"


start_daemon ()
{
    # Prevent issues with saving PID if deps need updating (e.g. first run)
    su - ${USER} -c "PATH=${PATH} ${INSTALLDEPS}" || exit 1
    # Start Etherpad via server.js. Config file will be found automatically.
    su - ${USER} -c "cd ${INSTALL_DIR}/share/etherpad && PATH=${PATH} node ${INSTALL_DIR}/share/etherpad/node_modules/ep_etherpad-lite/node/server.js" & echo $! > ${ETHERPAD_PID}
    sleep 5
    ps -w | grep "ep_etherpad-lite/node/server.js" | grep -v grep |awk '{print $1}' > ${NODE_PID}

}

stop_daemon ()
{
    kill `cat ${ETHERPAD_PID}`
    kill `cat ${NODE_PID}`
    wait_for_status 1 20 
    if [ $? -eq 1 ]; then
        kill -9 `cat ${ETHERPAD_PID}`
        kill -9 `cat ${NODE_PID}`
    fi
    rm -f ${ETHERPAD_PID} ${NODE_PID}
}

daemon_status ()
{
    ETHERPAD_RUNNING=0
    NODE_RUNNING=0
    if [ -f ${ETHERPAD_PID} ] && kill -0 `cat ${ETHERPAD_PID}` > /dev/null 2>&1; then
        ETHERPAD_RUNNING=1
    fi
    if [ -f ${NODE_PID} ] && kill -0 `cat ${NODE_PID}` > /dev/null 2>&1; then
        NODE_RUNNING=1
    fi
    [ ${ETHERPAD_RUNNING} -eq 1 -a ${NODE_RUNNING} -eq 1 ] || return 1
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


