#!/bin/sh

# Package
PACKAGE="gitolite"
DNAME="Gitolite"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:${GIT_DIR}/bin:${PATH}"
USER="gitolite"
DROPBEAR_PID_FILE="${INSTALL_DIR}/var/dropbear.pid"

start_daemon ()
{
	dropbear -r ${INSTALL_DIR}/var/dropbear_rsa_host_key -d ${INSTALL_DIR}/var/dropbear_dss_host_key -w -s -j -k -p 8352 -P ${DROPBEAR_PID_FILE}
}

stop_daemon ()
{
    kill `cat ${DROPBEAR_PID_FILE}`
    wait_for_status 1 20
    if [ $? -eq 1 ]; then
        kill -9 `cat ${DROPBEAR_PID_FILE}`
    fi
    rm -f ${DROPBEAR_PID_FILE}
}

daemon_status ()
{
    DROPBEAR_RUNNING=0
    if [ -f ${DROPBEAR_PID_FILE} ] && kill -0 `cat ${DROPBEAR_PID_FILE}` > /dev/null 2>&1; then
        DROPBEAR_RUNNING=1
    fi
    [ ${DROPBEAR_RUNNING} -eq 1 ] || return 1
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
