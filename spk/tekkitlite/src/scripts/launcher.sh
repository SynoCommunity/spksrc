#!/bin/sh

#--------MINECRAFT/CRAFTBUKKIT server launcher script
#--------package maintained at pcloadletter.co.uk
 
#--------Allows graceful shutdown of server without CPU-specific binaries
#--------You can send commands to the running server like so:
#--------    echo say Hello players >> /tmp/stdin.minecraft
#--------    echo say Hello players >> /tmp/stdin.craftbukkit

DAEMON_USER=$2
SYNOPKG_PKGDEST=$3
DAEMON_USER_SHORT=`echo ${DAEMON_USER} | cut -c 1-8`
JAR_FILE=${SYNOPKG_PKGDEST}/TekkitLite.jar

case $1 in
  start)
    if [ -f /tmp/stdin.${DAEMON_USER} ]; then
      rm /tmp/stdin.${DAEMON_USER}
    fi
    touch /tmp/stdin.${DAEMON_USER}
    cd ${SYNOPKG_PKGDEST}
    if [ ! -f syno-marker.txt ]; then
      if [ -f server.properties ]; then
        sed -i "s/A Tekkit Lite Server/A Synology Tekkit Lite Server/" server.properties
  
        #ARM CPU lags a lot, so reduce drawing distance from 10 chunks to 6
        cat /proc/cpuinfo | grep "CPU architecture: 5TE" > /dev/null \
         && sed -i "s/^view-distance=10/view-distance=6/" server.properties
  
        #record that these mods have been made
        echo config updated > syno-marker.txt
      fi
    fi
    JAVA_OPTS='-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalPacing -XX:+AggressiveOpts'
    RAM=$((`free | grep Mem: | sed -e "s/^ *Mem: *\([0-9]*\).*$/\1/"`/1024))
    if [ $RAM -le 128 ]; then
      JAVA_MAX_HEAP=80M
    elif [ $RAM -le 256 ]; then
      JAVA_MAX_HEAP=192M			
    elif [ $RAM -le 512 ]; then
      JAVA_MAX_HEAP=448M
    elif [ $RAM -le 1024 ]; then
      JAVA_MAX_HEAP=896M
    elif [ $RAM -le 2048 ]; then
      JAVA_MAX_HEAP=1792M
    elif [ $RAM -gt 2048 ]; then
      JAVA_MAX_HEAP=2048M
    fi
    JAVA_START_HEAP=${JAVA_MAX_HEAP}
    tail -n 0 -f /tmp/stdin.${DAEMON_USER} | java -Xmx${JAVA_START_HEAP} -Xms${JAVA_MAX_HEAP} ${JAVA_OPTS} -jar ${JAR_FILE} nogui
  ;;

  stop)
    echo say shutting down.. >> /tmp/stdin.${DAEMON_USER}
    sleep 5
    echo stop >> /tmp/stdin.${DAEMON_USER}
    sleep 10
    kill -9 `ps | grep "^ *[0-9]* ${DAEMON_USER_SHORT}.*tail -n 0 -f /tmp/stdin.${DAEMON_USER}" | sed -e "s/^ *\([0-9]*\).*$/\1/"`
    if [ -f /tmp/stdin.${DAEMON_USER} ]; then
      rm /tmp/stdin.${DAEMON_USER}
    fi
  ;;
esac
