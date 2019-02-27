#!/bin/sh

# Package
PACKAGE="emby"
DNAME="Emby"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
TMP_DIR="${SYNOPKG_PKGDEST}/../../.systemfile"
INSTALL_LOG="${INSTALL_DIR}/var/install.log"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="${PACKAGE}"
GROUP="users"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

preinst ()
{
	exit 0
}

install ()
{
	echo "Install ${PKG_NAME}"
	TMP=$1
	NASPROG=$2
	cd ${TMP}
	mkdir target
	tar -C target -xf package.tgz
	rm package.tgz
	mkdir target/var
	mv ${TMP} ${NASPROG}	
	postupgrade
}

init ()
{
	# Link
	APPDIR=$1
	ln -sf ${APPDIR}/target ${INSTALL_DIR}
	# Install busybox stuff
	${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

	# Create user
	#adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

	# Correct the files ownership
	#chown -R ${USER}:root ${SYNOPKG_PKGDEST}

	# Add firewall config
	#${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

	# init icon and redirect
	mkdir -p /var/www/${PKGNAME}
	ln -sf ${APPDIR}/web/* /var/www/${PKGNAME}/
}

start ()
{
	${SSS} start > /dev/null
}

stop ()
{
	${SSS} stop > /dev/null
}

clean ()
{
	# Stop the package
	${SSS} stop > /dev/null

	# Remove package link
	rm -f ${INSTALL_DIR}

	# Remove the user (if not upgrading)
	#if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
	#	delgroup ${USER} ${GROUP}
	#	deluser ${USER}
	#fi

	# Remove firewall config
	#if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
	#	${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
	#fi

	APPDIR=$1
	rm -rf /var/www/${PKGNAME}
}

remove ()
{
	preupgrade

	# Remove Link
	rm -f ${INSTALL_DIR}

	# Remove package
	APPDIR=$1
	rm -rf ${APPDIR}
}

preupgrade ()
{
	# Save some stuff
	rm -fr ${TMP_DIR}/${PACKAGE}
	mkdir -p ${TMP_DIR}/${PACKAGE}
	mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/
}

postupgrade ()
{
	# Restore some stuff
	rm -fr ${INSTALL_DIR}/var
	mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
}

