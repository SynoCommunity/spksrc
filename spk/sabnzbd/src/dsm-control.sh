#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="sabnzbd"
PYTHON_DIR="/usr/local/python26"
PYTHON_VAR_DIR="/usr/local/var/python26"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
VAR_DIR="/usr/local/var/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin" # Avoid ipkg commands

RUNAS="${PACKAGE}"
SABNZBD="${INSTALL_DIR}/share/SABnzbd/SABnzbd.py"
SABCFG="${VAR_DIR}/config.ini"
LOG_FILE="${VAR_DIR}/logs/sabnzbd.log"

# Get the connection info from SABnzbd's config.ini
if [ -e ${PYTHON_DIR}/bin/python ]
then
    eval `${PYTHON_DIR}/bin/python -s -S -c "
from sys import path, stdout
path.append ('${INSTALL_DIR}/share/SABnzbd/sabnzbd/utils')
from configobj import ConfigObj
miscCfg = ConfigObj ('${SABCFG}')['misc']
try :            port=miscCfg['port']
except KeyError: port='8080'
try :            username=miscCfg['username']
except KeyError: username=''
try :            password=miscCfg['password']
except KeyError: password=''
try :            apikey=miscCfg['api_key']
except KeyError: apikey=''
stdout.write (' port=' + port +
              ' username=' + username +
              ' password=' + password +
              ' apikey=' + apikey)"`
fi

if [ -n ${username} ]
then
    auth="--user=${username} --password=${password}"
fi

start_daemon ()
{
    # Launch SABnzbd in the background.
    su - ${RUNAS} -c "PATH=${PATH} ${SABNZBD} -f ${SABCFG} -d"
    counter=20
    while [ ${counter} -gt 0 ] 
    do
        daemon_status && break
        let counter=counter-1
        sleep 1
    done
    ln -sf $0 ${PYTHON_VAR_DIR}/run/${PACKAGE}-ctl
}

stop_daemon ()
{
    rm -f ${PYTHON_VAR_DIR}/run/${PACKAGE}-ctl

    wget -q --spider ${auth} "http://localhost:${port}/sabnzbd/api?mode=shutdown&apikey=${apikey}" > /dev/null

    # Wait until SABnzbd has initiated its shutdown.
    counter=20
    while [ ${counter} -gt 0 ] 
    do
        daemon_status || break
        let counter=counter-1
        sleep 1
    done
    sleep 5 # Let it die
}

daemon_status ()
{
    if [ -e ${PYTHON_DIR}/bin/python ]
    then
        wget -q --spider ${auth} http://localhost:${port}/ > /dev/null
    else
        return 1
    fi
}

run_in_console ()
{
    su - ${RUNAS} -c "PATH=${PATH} ${SABNZBD} -f ${SABCFG}"
}

case $1 in
    start)
        if daemon_status
        then
            echo SABnzbd daemon already running
            exit 0
        else
            echo Starting SABnzbd ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status
        then
            echo Stopping SABnzbd ...
            stop_daemon
            exit $?
        else
            echo SABnzbd is not running
            exit 0
        fi
        ;;
    restart)
        stop_daemon
        start_daemon
        exit $?
        ;;
    status)
        sed -e "s/^\(adminport\)=.*$/\1=${port}/" -i /var/packages/SABnzbd/INFO
        if daemon_status
        then
            echo SABnzbd is running
            exit 0
        else
            echo SABnzbd is not running
            exit 1
        fi
        ;;
    console)
        run_in_console
        exit $?
        ;;
    log)
        echo ${LOG_FILE}
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
