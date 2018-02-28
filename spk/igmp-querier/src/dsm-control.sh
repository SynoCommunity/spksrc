#!/bin/sh

# Package
PACKAGE="igmp-querier"
DNAME="IGMP Querier"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/sbin:${PATH}"
SYNOUPDATE_LOG=/var/log/synopkg.log

case $1 in
	start)
		killall ${PACKAGE} 2> /dev/null
		igmp-querier

		exit 0
	;;
	stop)
		killall ${PACKAGE}

		exit 0
	;;
	status)
		STATUS=$(ps | grep ${PACKAGE} | grep -v grep)
		if [ -z "${STATUS}" ]; then
			exit 3
		else
			exit 0
		fi
	;;
        log)
                echo ${SYNOUPDATE_LOG}
                exit 0
        ;;
        *)
                exit 1
                ;;
esac
