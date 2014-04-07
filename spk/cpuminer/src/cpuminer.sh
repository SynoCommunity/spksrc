#!/bin/sh
#
# Script based on this gist :
# https://gist.github.com/rbranson/638792
#
PACKAGE="cpuminer"
INSTALL_DIR="/usr/local/${PACKAGE}"

LOGFILE="${INSTALL_DIR}/var/cpuminer.log"
CPUMINER="${INSTALL_DIR}/bin/minerd"
OPTIONS="-c ${INSTALL_DIR}/var/settings.json -t 1"
 
# Fork off node into the background and log to a file
${CPUMINER} ${OPTIONS} >> ${LOGFILE} 2>&1 </dev/null &
 
# Capture the child process PID
CHILD="$!"
 
# Kill the child process when start-stop-daemon sends us a kill signal
trap "kill $CHILD" exit INT TERM
 
# Wait for child process to exit
wait
~