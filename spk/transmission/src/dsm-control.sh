#!/bin/sh

PATH=/bin:/usr/bin

TRDIR="/usr/local/transmission"
TREXE="$TRDIR/bin/transmission-daemon"
TRVAR="$TRDIR/var"
TRPID="$TRVAR/transmission.pid"
TRCFG="/usr/local/etc/transmission.cfg"
RUNAS="transmission"

start_daemon ()
{
    # Launch transmission in the background.
    su $RUNAS -s /bin/sh -c "$TREXE -g $TRVAR -x $TRPID"

    # Wait until transmission is ready (race condition here).
    counter=5
    while [ $counter -gt 0 ]
    do
        daemon_status && break
        let counter=counter-1
        sleep 1
    done
}

stop_daemon ()
{
    # Kill transmission.
    kill `cat $TRPID`

    # Wait until transmission is really dead (may take some time).
    counter=20
    while [ $counter -gt 0 ] 
    do
        daemon_status || break
        let counter=counter-1
        sleep 1
    done
}

reload_daemon ()
{
    kill -s HUP `cat $TRPID`
}

daemon_status ()
{
    if [ -f $TRPID ] 
    then
        if [ -d /proc/`cat $TRPID` ]
        then
            return 0
        else
            # PID file exists, but no process has this PID. 
            rm $TRPID
    	fi
    fi
    return 1
}

run_in_console ()
{
    su $RUNAS -s /bin/sh -c "$TREXE -g $TRVAR -f"
}

do_settings ()
{
    su $RUNAS -s /bin/sh -c "$TREXE -g $TRVAR -d 2> $TRVAR/new.settings.json"
    mv $TRVAR/new.settings.json $TRVAR/settings.json
}

# Load the transmission config file if it exists
if [ -e $TRCFG ]
then
    . $TRCFG
fi

case $1 in
    start)
        if daemon_status
        then
            echo Transmission daemon already running
            exit 0
        else
            echo Starting Transmission daemon...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        echo Stopping Transmission daemon...
        stop_daemon
        exit 0
        ;;
    restart)
        stop_daemon
        start_daemon
        exit $?
        ;;
    reload)
        if daemon_status
        then
           reload_daemon
        fi
        exit $?
        ;;
    status)
        if daemon_status
        then
            echo Running
            exit 0
        else
            echo Not running
            exit 1
        fi
        ;;
    log)
        echo $LOGFILE
        exit 0
        ;;
    console)
        run_in_console
        exit $?
        ;;
    settings)
        do_settings
        exit $?
        ;;
    *)
        exit 1
        ;;
esac
