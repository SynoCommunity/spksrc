#!/bin/sh

# Package
PACKAGE="lua"
DNAME="Lua"



service_postinst ()
{
	echo "Creating startup scripts for Lua executables" >> ${INST_LOG}
	for executable in ${SYNOPKG_PKGDEST}/bin/lua*; do
		ln -s "$executable" /usr/local/bin/$(basename "$executable")
	done

	exit 0
}

service_preuninst ()
{
	# Remove startup scripts for the executables
	for executable in ${SYNOPKG_PKGDEST}/bin/lua*; do
		rm /usr/local/bin/$(basename "$executable")
	done

	exit 0
}

