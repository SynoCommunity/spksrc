#!/bin/sh

# Package
PACKAGE="haproxy"
DNAME="HAProxy"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
USER="root" # root is needed to listen on ports <1024, haproxy will drop the privileges after startup
PYTHON="${INSTALL_DIR}/env/bin/python"
HAPROXY="${INSTALL_DIR}/sbin/haproxy"
PID_FILE="${INSTALL_DIR}/var/haproxy.pid"
CFG_FILE="${INSTALL_DIR}/var/haproxy.cfg"


start_daemon ()
{
    su ${USER} -s /bin/sh -c "PATH=${PATH} ${HAPROXY} -f ${CFG_FILE} -p ${PID_FILE}"
}

check_config ()
{
    su ${USER} -s /bin/sh -c "PATH=${PATH} ${HAPROXY} -c -f ${CFG_FILE}" > /dev/null
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
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
    check)
        check_config
        exit 0
        ;;
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
