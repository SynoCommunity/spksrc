#!/bin/sh

# Package
PACKAGE="sickbeard-mp4-automator"
DNAME="SickBeard MP4 Automator"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
USER="sickbeard-custom"
PYTHON="${INSTALL_DIR}/env/bin/python"
GIT="${GIT_DIR}/bin/git"

start_daemon ()
{
    exit 0
}

stop_daemon ()
{
	exit 0
}


case $1 in
    start)
        start_daemon
		exit 0
        ;;
    stop)
        stop_daemon
        exit 0
        ;;
    status)
		exit 0
		;;
	log)
		exit 0
		;;
esac
