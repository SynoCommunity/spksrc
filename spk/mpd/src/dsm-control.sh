#!/bin/sh

# Package
PACKAGE="mpd"
DNAME="Music Player Daemon"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="${PACKAGE}"
MPD="${INSTALL_DIR}/bin/mpd"
CFG_FILE="${INSTALL_DIR}/etc/mpd.conf"
PID_FILE="${INSTALL_DIR}/var/pid"


start_daemon ()
{
    # Fix permissions
    chown -R :audio /dev/snd /dev/dsp* /dev/mixer*
    chmod g+rwx /dev/snd
    chmod g+rw /dev/snd/* /dev/dsp* /dev/mixer*

    su - ${RUNAS} -c "${MPD} ${CFG_FILE}"
}

stop_daemon ()
{
    su - ${RUNAS} -c "${MPD} ${CFG_FILE} --kill"
}

daemon_status ()
{
    # Check for pid file and an existing process with that pid
    if [ -f ${PID_FILE} ] && [ -d /proc/`cat ${PID_FILE}` ]; then
        return 0
    fi
    return 1
}


case $1 in
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

