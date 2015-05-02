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

UPGRADELOCK=/tmp/sslh.upgrade.lock

preinst ()
{
	exit 0
}

postinst ()
{
	# Create the directory
	mkdir -p /usr/local/sslh
	mkdir -p /usr/local/sslh/bin
	mkdir -p /usr/local/sslh/pid

	# Create symlink
	ln -s ${SYNOPKG_PKGDEST}/bin/sslh /usr/local/sslh/bin/sslh
	ln -s ${SYNOPKG_PKGDEST}/bin/generate_log.pl /usr/local/sslh/bin/generate_log.pl
	ln -s ${SYNOPKG_PKGDEST}/log /usr/local/sslh/log
	ln -s ${SYNOPKG_PKGDEST}/sslh.ini /usr/local/sslh/sslh.ini
	ln -s ${SYNOPKG_PKGDEST}/lib /usr/local/sslh/lib

	# Correct the files ownership
	chown -R root:root ${SYNOPKG_PKGDEST}

	# Correct the files permission
	chmod 755 ${SYNOPKG_PKGDEST}/bin/*
	chmod 666 ${SYNOPKG_PKGDEST}/sslh.ini
	chmod 777 ${SYNOPKG_PKGDEST}/log
	chmod 777 /usr/local/sslh/pid

	exit 0
}

preuninst ()
{
	exit 0
}

postuninst ()
{
	# Remove symlink
	rm -Rf /usr/local/sslh

	exit 0
}

preupgrade ()
{
	touch $UPGRADELOCK
	exit 0
}

postupgrade ()
{
	rm -f $UPGRADELOCK
	exit 0
}
