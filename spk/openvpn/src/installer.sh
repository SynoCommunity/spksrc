#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="openvpn"
DNAME="OpenVPN 2.2.1 (client mode)"

# Common variables
PACKAGE_DEST=$SYNOPKG_PKGDEST
PRIVATE_LOCATION="/usr/local/${PACKAGE}"
PKG_USERCONF_DIR="/usr/local/etc/${PACKAGE}"
PKG_VAR_DIR="/usr/local/var/${PACKAGE}"

UPGRAGE_FILE="/tmp/${PACKAGE}.upgrade"
PACKAGE_VER=$SYNOPKG_PKGVER
OLD_PACKAGE_VER=$PACKAGE_VER
PACKAGE_ERR_MSG=$SYNOPKG_TEMP_LOGFILE
NEW_PACKAGE_VER=`get_key_value "${SYNOPKG_PKGINST_TEMP_DIR}/../INFO" "version"`

PATH="${PRIVATE_LOCATION}/sbin:/bin:/usr/bin" # Avoid ipkg commands

#########################################
# DSM package manager functions

preinst ()
{
    exit 0
}

postinst ()
{
	# creating symbolic link in user preserved area
	if [ -d ${PRIVATE_LOCATION} ]; then
		rm -rf ${PRIVATE_LOCATION}
	fi
	ln -sf "${PACKAGE_DEST}" ${PRIVATE_LOCATION}

	# prepare default config file and var dir
	mkdir -p ${PKG_USERCONF_DIR}
	mkdir -p ${PKG_VAR_DIR}

	if [ ! -e ${PKG_USERCONF_DIR}/client.conf ]; then
		cp ${PRIVATE_LOCATION}/etc/openvpn/client.conf.sample ${PKG_USERCONF_DIR}/client.conf.sample
	fi
	#if [ ! -e ${PKG_USERCONF_DIR}/openvpn/server.conf ]; then
	#	cp ${PRIVATE_LOCATION}/etc/openvpn/server.conf ${PKG_USERCONF_DIR}/server.conf.sample
	#fi
	
	# prepare certificates directory for OpenVPN
	if [ ! -e ${PKG_USERCONF_DIR}/keys/ca.crt ]; then
		mkdir -p ${PKG_USERCONF_DIR}/keys
	fi

    # Correct the files ownership (need to be change in a future release by a dedicated user)
    chown -R root:root ${PACKAGE_DEST}

    # Correct the files permission
    chmod 755 ${PACKAGE_DEST}/sbin/* 
    chmod 666 ${PKG_USERCONF_DIR}/*
    chmod 600 ${PKG_USERCONF_DIR}/keys/*

    exit 0
}

preuninst ()
{    
    exit 0
}

postuninst ()
{
    # Remove the installation directory
	if [ -d ${PRIVATE_LOCATION} ]; then
		rm -rf ${PRIVATE_LOCATION}
	fi
	if [ -d ${PKG_USERCONF_DIR} ]; then
		rm -rf ${PKG_USERCONF_DIR}
	fi
	if [ -d ${PKG_VAR_DIR} ]; then
		rm -rf ${PKG_VAR_DIR}
	fi

	exit 0
}

preupgrade ()
{
    check_version_older() # $1 base version $2 target version
	{
		BASE_VER=$1
		TARGET_VER=$2

		# if no base ver, always reture false
		if [ -z "${BASE_VER}" ]; then
			return 0;
		fi

		# getting major, minor, build
		base_major=`echo ${BASE_VER} | sed 's/^\([0-9]*\)[.-]\([0-9]*\)[.-]\([0-9]*\).*/\1/'`
		base_minor=`echo ${BASE_VER} | sed 's/^\([0-9]*\)[.-]\([0-9]*\)[.-]\([0-9]*\).*/\2/'`
		base_build=`echo ${BASE_VER} | sed 's/^\([0-9]*\)[.-]\([0-9]*\)[.-]\([0-9]*\).*/\3/'`
		target_major=`echo ${TARGET_VER} | sed 's/^\([0-9]*\)[.-]\([0-9]*\)[.-]\([0-9]*\).*/\1/'`
		target_minor=`echo ${TARGET_VER} | sed 's/^\([0-9]*\)[.-]\([0-9]*\)[.-]\([0-9]*\).*/\2/'`
		target_build=`echo ${TARGET_VER} | sed 's/^\([0-9]*\)[.-]\([0-9]*\)[.-]\([0-9]*\).*/\3/'`

		# compare major, version must equal or above limitation
		if [ $target_major -lt $base_major ]; then
			return 1;
		elif [ $target_major -gt $base_major ]; then
			return 0;
		fi
		# compare minor
		if [ $target_minor -lt $base_minor ]; then
			return 1;
		elif [ $target_minor -gt $base_minor ]; then
			return 0;
		fi
		# compare build
		if [ $target_build -lt $base_build ]; then
			return 1;
		else
			return 0;
		fi
	}

	check_version_older ${OLD_PACKAGE_VER} ${NEW_PACKAGE_VER}
	if [ $? -eq "1" ]; then
		echo "Target version [${NEW_PACKAGE_VER}] is older than current [${OLD_PACKAGE_VER}], abort"
		echo "Package version (${NEW_PACKAGE_VER}) is older then installed (${OLD_PACKAGE_VER})." > $PACKAGE_ERR_MSG
		exit 1;
	fi

	touch ${UPGRAGE_FILE}
	OLD_VER_STR="old_version="${OLD_PACKAGE_VER}
	echo ${OLD_VER_STR} >> ${UPGRAGE_FILE}

	exit 0
}

postupgrade ()
{
    rm -f $UPGRAGE_FILE
    exit 0
}
