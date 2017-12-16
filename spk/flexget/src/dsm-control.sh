#!/bin/sh

# Package
PACKAGE="flexget"
DNAME="FlexGet"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
PYTHON="${INSTALL_DIR}/env/bin/python"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
FLEXGET="${INSTALL_DIR}/env/bin/flexget"
CFG_FILE="${INSTALL_DIR}/var/config.yml"
PID_FILE="${INSTALL_DIR}/var/.config-lock"
LOG_FILE="${INSTALL_DIR}/var/flexget.log"

SC_USER="sc-flexget"
LEGACY_USER="flexget"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


start_daemon ()
{
    su ${USER} -s /bin/sh -c "${FLEXGET} -c ${CFG_FILE} --logfile ${LOG_FILE} daemon start -d"
}

stop_daemon ()
{
    su ${USER} -s /bin/sh -c "${FLEXGET} -c ${CFG_FILE} --logfile ${LOG_FILE} daemon stop"
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && kill -0 `grep PID: ${PID_FILE} | cut -d ' ' -f2` > /dev/null 2>&1; then
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
