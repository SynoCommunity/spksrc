#!/bin/sh
  
DAEMON_USER="`echo ${SYNOPKG_PKGNAME} | awk {'print tolower($_)'}`"
DAEMON_ID="${SYNOPKG_PKGNAME} daemon user"
DAEMON_USER_SHORT=`echo ${DAEMON_USER} | cut -c 1-8`

DATABASE_DIR="${SYNOPKG_PKGDEST}/share/data"

daemon_status ()
{
    ps -efa | grep "postgresql" > /dev/null
}


case $1 in
  start)
    su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} -l ${DATABASE_DIR}/logfile start"
    exit 0
  ;;

  stop)
    su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} stop"
    exit 0
  ;;

  status)
    if daemon_status ; then
      exit 0
    else
      exit 1
    fi
  ;;

esac
~         
