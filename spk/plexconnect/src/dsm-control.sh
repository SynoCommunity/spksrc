#!/bin/sh

# Package
PACKAGE="plexconnect"
DNAME="PlexConnect"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
DATA_DIR="${INSTALL_DIR}"
PYTHON_DIR="/usr/local/python"
PYTHON="${PYTHON_DIR}/bin/python"
PATH="${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="${PACKAGE}"
PROG_PY="${INSTALL_DIR}/share/PlexConnect/PlexConnect.py"
LOG_FILE="${INSTALL_DIR}/var/PlexConnect.log"

start_daemon ()
{
    # Launch the application in the background as root so we can open the dns port
    su -c "PATH=${PATH} ${PYTHON} ${PROG_PY}" &
}

stop_daemon ()
{
    # Kill the application
    kill `ps w | grep ${PACKAGE} | grep -v -E 'stop|grep' | awk '{print $1}'`
}


daemon_status ()
{
   ${INSTALL_DIR}/app/updateInfo
   if [ `ps w | grep ${PACKAGE} | grep -v -E 'status|grep' | wc -l` -gt 0 ]
    then
        return 0
    else
        return 1
    fi
}

case $1 in
    start)
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        ;;
    stop)
            echo Stopping ${DNAME} ...
			stop_daemon
            exit 0
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
			exit 0
        ;;
    *)
        exit 1
        ;;
esac
