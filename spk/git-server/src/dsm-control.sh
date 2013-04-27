#!/bin/sh

# Package
PACKAGE="git-server"
DNAME="Git Server"

# Others
USER="git"
INSTALL_DIR="/usr/local/${PACKAGE}"
GIT_DIR="/usr/local/git"
DROPBEAR_PID_FILE="${INSTALL_DIR}/var/run/dropbear.pid"
PID_FILE="${INSTALL_DIR}/var/run/git-daemon.pid"
LOG_FILE="${INSTALL_DIR}/var/log/git-daemon.log"
GIT_HOME="${INSTALL_DIR}/var/home"
BASE_PATH="${INSTALL_DIR}/var/home/repositories"

start_daemon ()
{
    su - ${USER} -c "${GIT_DIR}/bin/git daemon --base-path=${BASE_PATH} --pid-file=${PID_FILE} --reuseaddr --verbose --detach ${BASE_PATH}"
    export LD_LIBRARY_PATH=${INSTALL_DIR}/lib
    ${INSTALL_DIR}/sbin/dropbear -w

    # Symlink for gitweb
    ln -s ${GIT_DIR}/share/gitweb /var/services/web/gitweb

    # Symlink apache2 config
    ln -s ${INSTALL_DIR}/etc/gitweb.apache2.conf /usr/syno/etc/sites-enabled-user/

    # Restart Apache
    /usr/syno/etc/rc.d/S97apache-user.sh restart
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
    kill `cat ${DROPBEAR_PID_FILE}`
    rm -f ${PID_FILE}
    rm -f ${DROPBEAR_PID_FILE}

    # Unlink gitweb
    rm -f /var/services/web/gitweb
    rm -f /usr/syno/etc/sites-enabled-user/gitweb.apache2.conf

    # Restart Apache
    /usr/syno/etc/rc.d/S97apache-user.sh restart
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && kill -0 `cat ${PID_FILE}` && [ -f ${DROPBEAR_PID_FILE} ] && kill -0 `cat ${DROPBEAR_PID_FILE}` > /dev/null 2>&1; then
        return
    fi
    if ! `pidof git-daemon`; then
        rm -f ${PID_FILE}
    fi
    if ! `pidof dropbear`; then
        rm -f ${DROPBEAR_PID_FILE}
    fi
    return 1
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
        echo ${LOG_FILE}
        ;;
    *)
        exit 1
        ;;
esac
