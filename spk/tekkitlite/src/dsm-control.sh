#!/bin/sh

#--------MINECRAFT/CRAFTBUKKIT start-stop-status script
#--------package maintained at pcloadletter.co.uk

DAEMON_USER="`echo ${SYNOPKG_PKGNAME} | awk {'print tolower($_)'}`"
DAEMON_ID="${SYNOPKG_PKGNAME} daemon user"
ENGINE_SCRIPT="/var/packages/${SYNOPKG_PKGNAME}/scripts/launcher.sh"
DAEMON_USER_SHORT=`echo ${DAEMON_USER} | cut -c 1-8`

daemon_status ()
{
    ps | grep "^ *[0-9]* ${DAEMON_USER_SHORT} .*java" > /dev/null
}

daemon_start ()
{
    DAEMON_HOME="`cat /etc/passwd | grep "${DAEMON_ID}" | cut -f6 -d':'`"
    
    #set the current timezone for Java so that log timestamps are accurate
    #we need to use the modern timezone names so that Java can figure out DST
    SYNO_TZ=`cat /etc/synoinfo.conf | grep timezone | cut -f2 -d'"'`
    SYNO_TZ=`grep "^${SYNO_TZ}" /usr/share/zoneinfo/Timezone/tzname | sed -e "s/^.*= //"`
    grep "^export TZ" ${DAEMON_HOME}/.profile > /dev/null \
     && sed -i "s%^export TZ=.*$%export TZ='${SYNO_TZ}'%" ${DAEMON_HOME}/.profile \
     || echo export TZ=\'${SYNO_TZ}\' >> ${DAEMON_HOME}/.profile
    
    su - ${DAEMON_USER} -s /bin/sh -c "${ENGINE_SCRIPT} start ${DAEMON_USER} ${SYNOPKG_PKGDEST} &"
}

daemon_stop ()
{
    su - ${DAEMON_USER} -s /bin/sh -c "${ENGINE_SCRIPT} stop ${DAEMON_USER} ${SYNOPKG_PKGDEST}"	
}

case $1 in
  start)
    if daemon_start ; then    
      exit 0
    else
      exit 1
    fi
  ;;
  
  stop)
    if daemon_stop ; then
      exit 0
    else
      exit 1
    fi
  ;;
  
  status)
    if daemon_status ; then
      exit 0
    else
      exit 1
    fi
  ;;
  
  log)
    echo "${SYNOPKG_PKGDEST}/server.log"
    exit 0
  ;;
esac
