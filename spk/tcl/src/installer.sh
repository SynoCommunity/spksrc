#!/bin/sh

# Package
PACKAGE="tcl"
DNAME="Tcl"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"


preinst ()
{
	exit 0
}

postinst ()
{
	# Create symlinks
	ln -s ${SYNOPKG_PKGDEST}/bin/tclsh8.6 /usr/local/bin/tclsh
	ln -s ${SYNOPKG_PKGDEST}/lib/libtcl8.6.so /usr/local/lib/libtcl.so
	ln -s ${SYNOPKG_PKGDEST}/lib/libtcl8.6.so /usr/local/lib/libtcl8.6.so
	ln -s ${SYNOPKG_PKGDEST}/lib/tcl8.6/ /usr/local/lib/tcl8.6
	export LD_LIBRARY_PATH=/usr/local/lib/

	exit 0
}

preuninst ()
{
	exit 0
}

postuninst ()
{
	# Remove symlinks
	rm -f /usr/local/bin/tclsh
	rm -f /usr/local/lib/libtcl.so
	rm -f /usr/local/lib/libtcl8.6.so
	rm -f /usr/local/lib/tcl8.6

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
