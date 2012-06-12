#!/bin/sh

# Package
PACKAGE="pyload"
DNAME="pyLoad Download Manager"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="pyload"
PYTHON="${INSTALL_DIR}/env/bin/python"
PYLOAD="${INSTALL_DIR}/share/pyLoad/pyLoadCore.py"
CFG_FILES="${INSTALL_DIR}/var/"
PID_FILE="${INSTALL_DIR}/var/pyload.pid"
LOG_FILE="${INSTALL_DIR}/var/Logs/log.txt"


start_daemon()
{
    su - ${RUNAS} -c "PATH=${PATH} ${PYTHON} ${PYLOAD} --daemon --pidfile=${PID_FILE}  --configdir=${CFG_FILES}"
}

stop_daemon()
{
    for pid_file in ${PID_FILE}; do
        kill `cat ${pid_file}`
    done
    wait_for_status 1 20
    rm -f ${PID_FILE}
}

daemon_status()
{
    for pid_file in ${PID_FILE}; do
        if [ -f ${pid_file} ] && [ -d /proc/`cat ${pid_file}` ]; then
            return 0
        fi
    done
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

