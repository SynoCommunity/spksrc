#!/bin/sh

<<<<<<< HEAD
# Package
PACKAGE="pyload"
DNAME="pyLoad"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
USER="pyload"
PYTHON="${INSTALL_DIR}/env/bin/python"
PYLOAD="${INSTALL_DIR}/share/pyload/pyLoadCore.py"
LOG_FILE="${INSTALL_DIR}/etc/Logs/log.txt"
PID_FILE="${INSTALL_DIR}/var/pyload.pid"



start_daemon ()
{
    su ${USER} -c "PATH=${PATH} ${PYTHON} ${PYLOAD} --pidfile=${PID_FILE} --daemon"
=======
PATH=/bin:/usr/bin

RUNAS=pyLoad

PYLDIR=/usr/local/pyLoad
PYLPY=$PYLDIR/share/pyLoad/pyLoadCore.py
PYLVAR=/usr/local/var/pyLoad

pylport=`grep -A6 'webinterface - "Webinterface"' $PYLVAR/pyload.conf | tail -n 1 | cut -d' ' -f6`

start_daemon ()
{
    # Launch pyLoad in the background.
    su - $RUNAS -s /bin/sh -c "PATH=$PATH:$PYLDIR/bin $PYLPY --configdir=$PYLVAR --daemon"
>>>>>>> 248a6fd384586733455953aae7a07f51c8b1e03a
}

stop_daemon ()
{
<<<<<<< HEAD
    su ${USER} -c "PATH=${PATH} ${PYTHON} ${PYLOAD} --pidfile=${PID_FILE} --quit"
=======
    # Kill pyLoad.
    su - $RUNAS -s /bin/sh -c "$PYLPY --configdir=$PYLVAR --quit"
>>>>>>> 248a6fd384586733455953aae7a07f51c8b1e03a
}

daemon_status ()
{
<<<<<<< HEAD
    su ${USER} -c "PATH=${PATH} ${PYTHON} ${PYLOAD} --pidfile=${PID_FILE} --status" > /dev/null
}


case $1 in
    start)
        if daemon_status; then
            echo "${DNAME} is already running"
            exit 0
        else
            echo "Starting ${DNAME} ..."
=======
    [ `su $RUNAS -s /bin/sh -c "$PYLPY --configdir=$PYLVAR --status"` != False ]
}

run_in_console ()
{
    # Launch pyLoad in the foreground
    su - $RUNAS -s /bin/sh -c "PATH=$PATH:$PYLDIR/bin $PYLPY --configdir=$PYLVAR"
}

doConfig ()
{
    # Launch pyLoad and go through the setup assitant to set default values
    su - $RUNAS -s /bin/sh -c "PATH=$PATH:$PYLDIR/bin $PYLPY --configdir=$PYLVAR --autosetup" >$PYLVAR/install.log
}

doCgi ()
{
    if daemon_status
    then
        host=`echo $HTTP_HOST | cut -f1 -d:`
        echo Location: http://$host:$pylport/
        echo
        return 0
    else
        return 1
    fi
}

case $1 in
    start)
        if daemon_status
        then
            echo pyLoad is already running
            exit 0
        else
            echo Starting pyLoad ...
>>>>>>> 248a6fd384586733455953aae7a07f51c8b1e03a
            start_daemon
            exit $?
        fi
        ;;
    stop)
<<<<<<< HEAD
        if daemon_status; then
            echo "Stopping ${DNAME} ..."
            stop_daemon
            exit $?
        else
            echo "${DNAME} is not running"
=======
        if daemon_status
        then
            echo Stopping pyLoad ...
            stop_daemon
            exit $?
        else
            echo pyLoad is not running
>>>>>>> 248a6fd384586733455953aae7a07f51c8b1e03a
            exit 0
        fi
        ;;
    status)
<<<<<<< HEAD
        if daemon_status; then
            echo "${DNAME} is running"
            exit 0
        else
            echo "${DNAME} is not running"
=======
        sed -e "s/^\(adminport\)=.*$/\1=$pylport/" -i /var/packages/pyLoad/INFO
        if daemon_status
        then
            echo pyLoad is running
            exit 0
        else
            echo pyLoad is not running
>>>>>>> 248a6fd384586733455953aae7a07f51c8b1e03a
            exit 1
        fi
        ;;
    log)
<<<<<<< HEAD
        if [ -f "${LOG_FILE}" ]; then
            echo "${LOG_FILE}"
        else
            exit 1
        fi
=======
        echo $PYLVAR/Logs/log.txt
        exit 0
        ;;
    console)
        run_in_console
        exit $?
        ;;
    config)
        doConfig
        exit $?
        ;;
    cgi)
        doCgi
        exit $?
>>>>>>> 248a6fd384586733455953aae7a07f51c8b1e03a
        ;;
    *)
        exit 1
        ;;
esac
