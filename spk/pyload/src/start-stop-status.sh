#!/bin/sh

# Package
PACKAGE="pyload"
DNAME="pyLoad"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
PYTHON="${INSTALL_DIR}/env/bin/python"
PYLOAD="${INSTALL_DIR}/share/pyload/pyLoadCore.py"
PID_FILE="${INSTALL_DIR}/var/pyload.pid"
CFG_DIR="${INSTALL_DIR}/var"

EXECUTE_SERVICE="${PYTHON} ${PYLOAD} --configdir=${CFG_DIR} --pidfile=${PID_FILE}"


start_daemon ()
{
    ${EXECUTE_SERVICE} --daemon  >> /dev/null 2>&1
}

stop_daemon ()
{
    ${EXECUTE_SERVICE} --quit  >> /dev/null 2>&1
}

daemon_status ()
{
    if [ "$(${EXECUTE_SERVICE} --status)" == "false" ]; then
        return 1;
    else
        return 0;
    fi
}


case $1 in
    start)
        if daemon_status; then
            echo "${DNAME} is already running"
            exit 0
        else
            echo "Starting ${DNAME} ..."
            start_daemon
            status=$?
            echo "Status = ${status}"
            exit ${status}
        fi
        ;;
    stop)
        if daemon_status; then
            echo "Stopping ${DNAME} ..."
            stop_daemon
            status=$?
            echo "Status = ${status}"
            exit ${status}
        else
            echo "${DNAME} is not running"
            exit 0
        fi
        ;;
    status)
        if daemon_status; then
            echo "${DNAME} is running"
            exit 0
        else
            echo "${DNAME} is not running"
            exit 1
        fi
        ;;
    *)
        exit 1
        ;;
esac
