#!/bin/sh

# Package
PACKAGE="gogs"
DNAME="Gogs"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="git"
DAEMON="${INSTALL_DIR}/gogs/gogs"
WORKDIR="${INSTALL_DIR}/var"
GOGS_CUSTOM="${WORKDIR}/custom"
PID_FILE="${WORKDIR}/gogs.pid"
DAEMON_ARGS="web"


start_daemon ()
{
    cd ${WORKDIR}
    start-stop-daemon -b -q -m -o -c ${USER} -u ${USER} -S -p ${PID_FILE} -x \
	env HOME=${WORKDIR} PATH=${PATH} USER=${USER} GOGS_CUSTOM=${GOGS_CUSTOM}  \
	${DAEMON} -- ${DAEMON_ARGS}
}

stop_daemon ()
{
    start-stop-daemon -o -c ${USER} -K -u ${USER} -p ${PID_FILE} -x ${DAEMON}
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -x $DAEMON
    rm -f ${PID_FILE}
}

daemon_status ()
{
    start-stop-daemon -K -q -t -u ${USER} -x ${DAEMON}
    [ $? -eq 0 ] || return 1
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
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
