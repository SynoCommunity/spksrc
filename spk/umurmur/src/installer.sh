#!/bin/sh
# Copyright 2010 Antoine Bertin
# <diaoulael [ignore this] at users.sourceforge period net>
#
# This file is part of syno-packager.
#
# syno-packager is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# syno-packager is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with syno-packager.  If not, see <http://www.gnu.org/licenses/>.

# Common
UMDIR=/usr/local/umurmur
UMVAR=$UMDIR/var
UMLIB=$UMDIR/lib
UMSHR=$UMDIR/share
UMETC=$UMDIR/etc
UMBIN=$UMDIR/bin
UMEXE=$UMBIN/umurmurd
UMCRT=$UMBIN/gencert.sh
SUEXE=/bin/su
PSEXE=ps
SYNO3APP=/usr/syno/synoman/webman/3rdparty
UMUSR=root

# Files
UMLOG=$UMVAR/umurmur.log

preinst ()
{
	exit 0
}

postinst ()
{
	# Correct the files ownership
	chown -R root:root ${SYNOPKG_PKGDEST}

	# Create the view directory
	mkdir -p $UMDIR
	mkdir -p /usr/local/bin

	# Create symlinks to the installation ditectory
	ln -s ${SYNOPKG_PKGDEST}/bin $UMBIN
	ln -s ${SYNOPKG_PKGDEST}/lib $UMLIB
	ln -s ${SYNOPKG_PKGDEST}/share $UMSHR
	ln -s ${SYNOPKG_PKGDEST}/var $UMVAR
	ln -s ${SYNOPKG_PKGDEST}/etc $UMETC

	# Create symlink
	ln -s $UMEXE /usr/local/bin/`basename $UMEXE`

	# Correct the files permission
	chmod 555 /usr/local/umurmur/bin/*
	chmod 555 /usr/local/umurmur/lib/*	

	# Log installation was successful
	echo `date`" : uMurmur SPK successfuly installed" >>  $UMLOG

	# Certificate generation
	$UMCRT > /dev/null
	if [ $? -ne 0 ]; then
		echo `date`" : Certificate generation failed" >> $UMLOG
	else
		echo `date`" : Certificate generation was successful" >> $UMLOG
	fi

	exit 0
}

preuninst ()
{
	exit 0
}

postuninst ()
{
	# Remove symlink
	rm -f /usr/local/bin/`basename $UMEXE`

	# Remove symlinks from /usr/local/umurmur
	rm -f $UMBIN
	rm -f $UMLIB
	rm -f $UMSHR
	rm -f $UMVAR
	rm -f $UMETC

	# Remove the view directory
	rmdir /usr/local/umurmur

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
