#!/bin/sh

# Package
PACKAGE="gateone"
DNAME="GateOne"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
PYTHON="${INSTALL_DIR}/env/bin/python"
GATEONE="${INSTALL_DIR}/env/bin/gateone"
SETTINGS_DIR="${INSTALL_DIR}/var/conf.d"
PID_FILE="${INSTALL_DIR}/var/gateone.pid"
USER="gateone"


start_daemon ()
{
    # Copy certificate
    cp  /usr/syno/etc/ssl/ssl.crt/server.crt /usr/syno/etc/ssl/ssl.key/server.key ${INSTALL_DIR}/ssl/
    chown ${USER} ${INSTALL_DIR}/ssl/*

    su - ${USER} -c "PATH=${PATH} nohup ${PYTHON} ${GATEONE} --settings_dir=${SETTINGS_DIR} > ${INSTALL_DIR}/var/gateone_startup.log &"
}

stop_daemon ()
{
    su - ${USER} -c "PATH=${PATH} ${PYTHON} ${GATEONE} --kill --settings_dir=${SETTINGS_DIR}"
    wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
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
