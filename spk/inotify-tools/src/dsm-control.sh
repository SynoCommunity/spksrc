#!/bin/sh

# Package
PACKAGE="inotify-tools"
# Others
INSTALL_DIR="/usr/local/${PACKAGE}/bin/"
WAIT_TARGET="/usr/bin/inotifywait"
WATCH_TARGET="/usr/bin/inotifywatch"
start_daemon ()
{
  if [ ! -e "${INOTI_TARGET}" ]; then
    ln -s ${INSTALL_DIR}/inotifywait ${WAIT_TARGET}
    ln -s ${INSTALL_DIR}/inotifywatch ${WATCH_TARGET}
  fi
}

stop_daemon ()
{
  rm -f ${WAIT_TARGET}
  rm -f ${WATCH_TARGET}
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
    if [ -e ${WAIT_TARGET} ]; then
      exit 0
    else
      exit 1
    fi
    ;;
  log)
    exit 0
    ;;
esac

