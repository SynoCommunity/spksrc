#!/bin/sh

# Package
PACKAGE="gateone"
DNAME="GateOne"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
PYTHON="${INSTALL_DIR}/env/bin/python"
GATEONE="${INSTALL_DIR}/gateone/gateone.py"
CFG_FILE="${INSTALL_DIR}/var/conf/gateone.conf"
PID_FILE="${INSTALL_DIR}/var/gateone.pid"
RUNAS="gateone"

start_daemon()
{
    perl ${INSTALL_DIR}/var/conf/setConf.pl
	cp  /usr/syno/etc/ssl/ssl.crt/server.crt ${INSTALL_DIR}/var/
	cp /usr/syno/etc/ssl/ssl.key/server.key ${INSTALL_DIR}/var/
	chown -R ${RUNAS}:users ${INSTALL_DIR}/var/*

    PATH=${PATH} nohup ${PYTHON} ${GATEONE} --pid_file=${PID_FILE} --config=${CFG_FILE} --uid=`awk -v val=${RUNAS} -F ":" '$1==val{print $3}' /etc/passwd` --gid=`awk -v val=users -F ":" '$1==val{print $3}' /etc/group` > ${INSTALL_DIR}/var/gateone_startup.log &
}

stop_daemon()
{
    kill `cat ${PID_FILE}`
    wait_for_status 1 20
    rm -f ${PID_FILE}
}

daemon_status()
{
    if [ -f ${PID_FILE} ] && [ -d /proc/`cat ${PID_FILE}` ]; then
        return 0
    fi
    return 1
}

wait_for_status()
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
    restart)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
        else
            echo ${DNAME} is not running
        fi
 	sleep 2
	if daemon_status; then
            echo ${DNAME} is already running
        else
            echo Starting ${DNAME} ...
            start_daemon
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


