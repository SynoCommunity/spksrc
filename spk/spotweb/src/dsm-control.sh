#!/bin/sh

# Others
PACKAGE_DIR="/var/packages/$SYNOPKG_PKGNAME"
SWEnabled="${PACKAGE_DIR}/enabled"
SWDir="${PACKAGE_DIR}/target"
SWDesktop="/usr/syno/synoman/webman/3rdparty/Spotweb"
PKG_APP_PATH="${PACKAGE_DIR}/target/app"
DSM_INDEX_ADD="/usr/syno/bin/pkgindexer_add"
DSM_INDEX_DEL="/usr/syno/bin/pkgindexer_del"

CheckEnv() {
	[ -f "/etc.defaults/VERSION" ] || exit 1
	DSM_VERSION=`grep ^majorversion= /etc.defaults/VERSION | cut -d'"' -f2`
	[ -z "$DSM_VERSION" ] && exit 1

	# DSM 4 use different config
	if [ $DSM_VERSION -eq 4 ]; then
		RunWeb=`/bin/get_key_value /etc/synoinfo.conf runweb`
		RunMySQL=`/bin/get_key_value /etc/synoinfo.conf runmysql`
		if [ ! -d /var/services/web -o "x$RunWeb" != "xyes" ]; then
			echo "Please enable Web Station first." > $SYNOPKG_TEMP_LOGFILE
			exit 1
		fi
		if [ "x$RunMySQL" != "xyes" ]; then
			echo "Please enable MySQL first." > $SYNOPKG_TEMP_LOGFILE
			exit 1
		fi
	else
		if [ ! -f /var/packages/MariaDB/enabled ]; then
			echo "Please run MariaDB first." > $SYNOPKG_TEMP_LOGFILE
			exit 1
		fi
	fi
}

StartDaemons() {
	CheckEnv
	rm -f $SWDesktop
	if [ -n "$SYNOPKG_DSM_VERSION_MAJOR" -a $SYNOPKG_DSM_VERSION_MAJOR -ge 4 ]; then
		ln -sf ${SWDir}/app $SWDesktop
		${DSM_INDEX_ADD} ${PKG_APP_PATH}
	fi
}

StopDaemons() {
	if [ -n "$SYNOPKG_DSM_VERSION_MAJOR" -a $SYNOPKG_DSM_VERSION_MAJOR -ge ]; then
		${DSM_INDEX_DEL} ${PKG_APP_PATH}
	fi
	rm -f $SWDesktop
}

case "$1" in
	start)
		if [ ! -f "${SWEnabled}" ]; then
			exit 0
		fi
	    StartDaemons
		
		;;
	stop)
		if [ -f "${SWEnabled}" ]; then
			exit 0
		fi
		StopDaemons

		;;
	restart)
		StopDaemons
		sleep 1
		StartDaemons
		;;
	status)
		if [ -f "${SWEnabled}" ]; then
			exit 0
		fi
		exit 1
		;;
	log) 
		echo ""
		;;  
	*)
		echo "Usage: $0 {start|stop|restart|status}" >&2
		exit 1
		;;
esac

exit 0
