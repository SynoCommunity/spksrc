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

	exit 0
}

postupgrade ()
{
    rm -f $UPGRAGE_FILE
    exit 0
}
