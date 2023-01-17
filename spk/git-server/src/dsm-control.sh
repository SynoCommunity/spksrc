#!/bin/sh

# Package
PACKAGE="git-server"
DNAME="Git Server"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:${GIT_DIR}/bin:${PATH}"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
DROPBEAR_PID_FILE="${INSTALL_DIR}/var/dropbear.pid"
PID_FILE="${INSTALL_DIR}/var/git-daemon.pid"
LOG_FILE="${INSTALL_DIR}/var/git-daemon.log"
BASE_PATH="${INSTALL_DIR}/var/repositories"

SC_USER="sc-git-server"
LEGACY_USER="git-server"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


start_daemon ()
{
    su ${USER} -s /bin/sh -c "${GIT_DIR}/bin/git daemon --base-path=${BASE_PATH} --pid-file=${PID_FILE} --reuseaddr --verbose --detach ${BASE_PATH}"
    dropbear -r ${INSTALL_DIR}/var/dropbear_rsa_host_key -d ${INSTALL_DIR}/var/dropbear_dss_host_key -w -s -j -k -p 8352 -P ${DROPBEAR_PID_FILE}
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
    kill `cat ${DROPBEAR_PID_FILE}`
    wait_for_status 1 20
    if [ $? -eq 1 ]; then
        kill -9 `cat ${PID_FILE}`
        kill -9 `cat ${DROPBEAR_PID_FILE}`
    fi
    rm -f ${PID_FILE} ${DROPBEAR_PID_FILE}
}

daemon_status ()
{
    GITDAEMON_RUNNING=0
    if [ -f ${PID_FILE} ] && kill -0 `cat ${PID_FILE}` > /dev/null 2>&1; then
        GITDAEMON_RUNNING=1
    fi
    DROPBEAR_RUNNING=0
    if [ -f ${DROPBEAR_PID_FILE} ] && kill -0 `cat ${DROPBEAR_PID_FILE}` > /dev/null 2>&1; then
        DROPBEAR_RUNNING=1
    fi
    [ ${GITDAEMON_RUNNING} -eq 1 -a ${DROPBEAR_RUNNING} -eq 1 ] || return 1
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
