#!/bin/sh

# Package
PACKAGE="maraschino"
DNAME="Maraschino"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="maraschino"
PYTHON="${INSTALL_DIR}/env/bin/python"
MARASCHINO="${INSTALL_DIR}/share/maraschino/Maraschino.py"
PID_FILE="${INSTALL_DIR}/var/maraschino.pid"
LOG_FILE="${INSTALL_DIR}/var/maraschino.log"
DB_FILE="${INSTALL_DIR}/var/maraschino.db"


start_daemon()
{
    su - ${RUNAS} -c "PATH=${PATH} ${PYTHON} ${MARASCHINO} --daemon --port 8260 --pidfile ${PID_FILE} --database ${DB_FILE} --log ${LOG_FILE}"
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
    log)
        echo ${LOG_FILE}
        ;;
    *)
        exit 1
        ;;
esac
