#!/bin/sh

# Package
PACKAGE="mono"
DNAME="Mono"
INSTALL_DIR="/usr/local/${PACKAGE}"
INSTALL_LOG="${INSTALL_DIR}/var/install.log"

case "$1" in
	start)
        	exit 0
		;;
	stop)
        	exit 0
		;;
	status)
        	exit 0
		;;
	killall)
		;;
	log)
		echo "${INSTALL_LOG}"
		exit 0		
		;;
	*)
		echo "Usage: $0 [start|stop|status]"
        	exit 1
		;;
esac

#exit 0
