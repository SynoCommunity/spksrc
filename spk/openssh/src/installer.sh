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

# Find the CPU architecture
synoinfo=`get_key_value /etc.defaults/synoinfo.conf unique`
arch=`echo $synoinfo | cut -d_ -f2`
UPGSSLH=/tmp/sslh.upgrade.lock

preinst ()
{
	# Check if the architecture is supported (88f628x, ppc824x, ppc853x, x86)
	if ! echo "|88f6281|ppc824x|ppc853x|x86|" | grep -q "$arch"; then
		echo "Your architecture is not supported by this package. Architecture  : '$arch'. Synology info : '$synoinfo'. Required : 'x86'."
		exit 1
	fi
	exit 0
}

postinst ()
{
	# Create the directory
	mkdir -p /usr/local/scp
	mkdir -p /usr/local/scp/bin

	# Create symlink
	ln -s ${SYNOPKG_PKGDEST}/bin/scp-$arch /usr/local/scp/bin/scp
	ln -s ${SYNOPKG_PKGDEST}/bin/sftp-$arch /usr/local/scp/bin/sftp
	ln -s ${SYNOPKG_PKGDEST}/bin/generate_log.pl /usr/local/scp/bin/generate_log.pl
	ln -s ${SYNOPKG_PKGDEST}/log /usr/local/scp/log

	# Correct the files ownership
	chown -R root:root ${SYNOPKG_PKGDEST}

	# Correct the files permission
	chmod 755 ${SYNOPKG_PKGDEST}/bin/*
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
	rm -Rf /usr/local/scp

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
