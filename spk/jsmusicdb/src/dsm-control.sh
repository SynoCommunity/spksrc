#!/bin/sh

# Others
PACKAGE_DIR="/var/packages/$SYNOPKG_PKGNAME"
SWEnabled="${PACKAGE_DIR}/enabled"
SWDir="${PACKAGE_DIR}/target"
SWDesktop="/usr/syno/synoman/webman/3rdparty/JSMusicDB"
PKG_APP_PATH="${PACKAGE_DIR}/target/ui"
DSM_INDEX_ADD="/usr/syno/bin/pkgindexer_add"
DSM_INDEX_DEL="/usr/syno/bin/pkgindexer_del"

StartDaemons() {
	CheckEnv
	rm -f $SWDesktop
	if [ -n "$SYNOPKG_DSM_VERSION_MAJOR" -a $SYNOPKG_DSM_VERSION_MAJOR -ge 4 ]; then
		ln -sf ${SWDir}/ui $SWDesktop
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
