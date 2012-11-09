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

PACKAGE="midnightcommander"
INSTALL_DIR="/usr/local/${PACKAGE}"


preinst ()
{
	exit 0
}

postinst ()
{
	# Link
	ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

	# Create the directory
	ln -s /usr/local/midnightcommander/bin/mc /usr/local/bin/mc

	exit 0
}

preuninst ()
{
	exit 0
}

postuninst ()
{
	# Remove symlink
	rm -f /usr/local/bin/mc
	rm -f ${INSTALL_DIR}

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
