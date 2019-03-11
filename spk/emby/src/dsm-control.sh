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
EXE_FILE="${INSTALL_DIR}/share/emby/system/EmbyServer.exe"
PID_FILE="${INSTALL_DIR}/var/emby.pid"
EXTRA_LIBS="${INSTALL_DIR}/lib"
FFMPEG="/usr/local/ffmpeg/bin"

COMMAND="env PATH=${MONO_PATH}:${PATH} LD_LIBRARY_PATH=${EXTRA_LIBS} ${MONO} ${EXE_FILE} -programdata ${INSTALL_DIR}/var -ffmpeg ${FFMPEG}/ffmpeg -ffprobe ${FFMPEG}/ffprobe"

start_daemon ()
{
	#sudo -u ${USER} ${COMMAND}
	"${COMMAND}" & echo $! > ${PID_FILE}
	sleep 2
}

stop_daemon ()
{
	kill $(cat ${PID_FILE})
	wait_for_status 1 20 || kill -9 $(cat ${PID_FILE})
	PID=$(ps w | grep [e]mby | awk '{print $1}')
	if [ $PID -ne "" ]; then
		kill $PID
	fi
	rm ${PID_FILE}
}

daemon_status ()
{
	kill -0 $(cat ${PID_FILE})
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
