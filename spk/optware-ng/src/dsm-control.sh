#!/bin/sh

# Package
PACKAGE="optware-ng"
DNAME="optware-ng"

# Others
VOL="/volume1"
AT="@optware-ng"
TO="${VOL}/${AT}"

INSTALL_DIR="/opt"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
# PATH="${INSTALL_DIR}/bin:${PATH}"
HOME=/root export HOME

OPTWARE="${INSTALL_DIR}/etc/rc.optware"

LOG_FILE="${INSTALL_DIR}/var/log/optware.log"

#exec >> $LOG_FILE 2>&1
#echo $0 "$@"
#env
#ps -fp $PPID
#set -x

start_daemon ()
{
    ${OPTWARE} start >> ${LOG_FILE} 2>&1
}

stop_daemon ()
{
    ${OPTWARE} stop >> ${LOG_FILE} 2>&1
    for PID in ${PIDS}; do
	kill -0 ${PID} ||
	kill -9 ${PID}
    done
}

daemon_status ()
{
    PIDS=$(
	(
	grep -E "${INSTALL_DIR}/|${TO}" /proc/*/cmdline ||
	ls -l /proc/*/fd/* 2> /dev/null | grep -E "> (${TO}|${INSTALL_DIR})"
	) |
	sed '/self/d;s|^/proc/||;s|.* /proc/||;s|/.*||' # | tr '\n' ' '
    )
    [ -n "${PIDS}" ]
}

[ -L ${INSTALL_DIR} ] ||
# ln -s "${TO}" "${INSTALL_DIR}" ||
exit

case $1 in
    start)
        if daemon_status && [ "$2" != force ]
        then
            echo ${DNAME} daemon already running
        else
            echo Starting ${DNAME} ...
            start_daemon
        fi
        ;;
    stop)
        if daemon_status || [ "$2" = force ]
        then
            echo Stopping ${DNAME} ...
            stop_daemon
        else
            echo ${DNAME} is not running
        fi
        ;;
    restart)
        stop_daemon
        start_daemon
        exit $?
        ;;
    status)
        if daemon_status
        then
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
	echo "usage: $0 start|stop|restart|status|log [force]" >&2
        exit 1
        ;;
esac
