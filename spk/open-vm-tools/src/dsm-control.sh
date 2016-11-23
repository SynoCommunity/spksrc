#!/bin/sh

SYNOPKG_PKGNAME=${SYNOPKG_PKGNAME:-open-vm-tools}
SYNOPKG_PKGDEST=${SYNOPKG_PKGDEST:-/var/packages/${SYNOPKG_PKGNAME}/target}

DAEMON=${SYNOPKG_PKGDEST}/bin/vmtoolsd
CHECKVM=${SYNOPKG_PKGDEST}/bin/vmware-checkvm
PIDFILE=/var/run/vmtoolsd.pid
CONFILE=/etc/vmware-tools/tools.conf
LOGFILE=/var/log/open-vm-tools.log

export PATH=${PATH}:${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/sbin:${SYNOPKG_PKGDEST}/usr/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}${SYNOPKG_PKGDEST}/lib
# LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SYNOPKG_PKGDEST}/lib/open-vm-tools/plugins/vmsvc
# LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SYNOPKG_PKGDEST}/lib/open-vm-tools/plugins/common

case $1 in
	start)
		if [ ! -x ${CHECKVM} ] || \
			! ${CHECKVM} > /dev/null 2>&1; then
			echo "$(date) NAS is not a virtual machine..." >> ${LOGFILE}
			exit 1
		fi

		${DAEMON} -b ${PIDFILE} -c ${CONFILE} && exit 0
		echo "$(date) Unable to start vmtoolsd..." >> ${LOGFILE}
		rm -f ${PIDFILE}
		exit 1
	;;
	stop)
		if [ -e ${PIDFILE} ]; then
			kill -9 `cat ${PIDFILE}`
			rm -f ${PIDFILE}
		fi
	;;
	status)
		if [ -e ${PIDFILE} ]; then 
			echo "$(date) vmtoolsd ($(cat  ${PIDFILE})) is running..." >> ${LOGFILE}
		else
			echo "$(date) vmtoolsd is not running..." >> ${LOGFILE}
		fi	
	;;
	log)
		echo "${LOGFILE}"
	;;
esac

exit 0

