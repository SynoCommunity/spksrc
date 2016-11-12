#!/bin/sh

# Package
PACKAGE="tcl"
DNAME="Tcl"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PACKAGE_DIR="/var/packages/${PACKAGE}/target"
LOG_FILE="/tmp/${PACKAGE}-sss.log"



preinst ()
{
	exit 0
}

postinst ()
{
	# Create symlinks
	ln -s ${PACKAGE_DIR}/bin/tclsh8.6 /usr/local/bin/tclsh >> ${LOG_FILE} 2>&1
	ln -s ${PACKAGE_DIR}/lib/libtcl8.6.so /usr/local/lib/libtcl.so >> ${LOG_FILE} 2>&1
	ln -s ${PACKAGE_DIR}/lib/libtcl8.6.so /usr/local/lib/libtcl8.6.so >> ${LOG_FILE} 2>&1
	ln -s ${PACKAGE_DIR}/ /usr/local/${PACKAGE} >> ${LOG_FILE} 2>&1

	exit 0
}

preuninst ()
{
	exit 0
}

postuninst ()
{
	# Remove symlinks
	rm -f /usr/local/${PACKAGE}
	rm -f /usr/local/bin/tclsh
	rm -f /usr/local/lib/libtcl.so
	rm -f /usr/local/lib/libtcl8.6.so

	# Remove logfile
	rm -f ${LOG_FILE}

	exit 0
}

preupgrade ()
{
	exit 0
}

postupgrade ()
{
	exit 0
}
