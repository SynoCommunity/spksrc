#!/bin/sh

# Package
PACKAGE="emby"
DNAME="Emby"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="${PACKAGE}"

MONO_PATH="/usr/local/mono/bin"
MONO="${MONO_PATH}/mono"
EXE_FILE="${INSTALL_DIR}/share/emby/MediaBrowser.Server.Mono.exe"
PID_FILE="${INSTALL_DIR}/var/emby.pid"
EXTRA_LIBS="/usr/local/imagemagick/lib:${INSTALL_DIR}/lib"
FFMPEG="/usr/local/ffmpeg/bin"

COMMAND="env PATH=${MONO_PATH}:${PATH} LD_LIBRARY_PATH=${EXTRA_LIBS} ${MONO} -- ${EXE_FILE} -programdata ${INSTALL_DIR}/var -ffmpeg ${FFMPEG}/ffmpeg -ffprobe ${FFMPEG}/ffprobe"

start_daemon ()
{
    start-stop-daemon -c ${USER} -S -q -b -m -p ${INSTALL_DIR}/var/emby.pid -N 10 -x ${COMMAND} > /dev/null
    sleep 2
}

stop_daemon ()
{
    start-stop-daemon -K -q -u ${USER} -p ${INSTALL_DIR}/var/emby.pid
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -p ${INSTALL_DIR}/var/emby.pid
}

daemon_status ()
{
    start-stop-daemon -K -q -t -u ${USER} -p ${INSTALL_DIR}/var/emby.pid
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
        exit 0
        ;;
    *)
        exit 1
        ;;
esac