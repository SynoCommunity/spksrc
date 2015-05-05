#!/bin/sh

# Package
PACKAGE="gamez"
DNAME="Gamez"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
DATA_DIR="${INSTALL_DIR}/var/"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="gamez"
PYTHON="${INSTALL_DIR}/env/bin/python"
PY_FILE="${INSTALL_DIR}/Gamez.py"
CFG_FILE="${INSTALL_DIR}/var/Gamez.ini"
PID_FILE="${INSTALL_DIR}/var/Gamez.pid"

start_daemon()
{
    su - ${RUNAS} -c "PATH=${PATH} ${PYTHON} ${PY_FILE} --daemonize --nolaunch --pidfile ${PID_FILE} --config ${CFG_FILE} --port 5290 --datadir ${DATA_DIR}"
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
    rm -f ${PID_FILE}
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
    *)
        exit 1
        ;;
esac
