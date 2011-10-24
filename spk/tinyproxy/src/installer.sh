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

UPGRADELOCK=/tmp/tinyproxy.upgrade.lock

preinst ()
{
	exit 0
}

postinst ()
{
	# Create the directory
	mkdir -p /usr/local/tinyproxy
	mkdir -p /usr/local/tinyproxy/bin

	# Create symlink
	ln -s ${SYNOPKG_PKGDEST}/bin/tinyproxy /usr/local/tinyproxy/bin/tinyproxy
	ln -s ${SYNOPKG_PKGDEST}/bin/generate_log.pl /usr/local/tinyproxy/bin/generate_log.pl
	ln -s ${SYNOPKG_PKGDEST}/log /usr/local/tinyproxy/log
	ln -s ${SYNOPKG_PKGDEST}/tinyproxy.conf /usr/local/tinyproxy/tinyproxy.conf
	ln -s ${SYNOPKG_PKGDEST}/tinyproxy.conf.tpl /usr/local/tinyproxy/tinyproxy.conf.tpl
	ln -s ${SYNOPKG_PKGDEST}/share /usr/local/tinyproxy/share
	ln -s ${SYNOPKG_PKGDEST}/www /usr/local/tinyproxy/www

	# Correct the files ownership
	chown -R root:root ${SYNOPKG_PKGDEST}

	# Correct the files permission
	chmod 755 ${SYNOPKG_PKGDEST}/bin/*
	chmod 666 ${SYNOPKG_PKGDEST}/tinyproxy.conf
	chmod 777 ${SYNOPKG_PKGDEST}/log

	exit 0
}

preuninst ()
{
	exit 0
}

postuninst ()
{
	# Remove symlink
	rm -Rf /usr/local/tinyproxy

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
