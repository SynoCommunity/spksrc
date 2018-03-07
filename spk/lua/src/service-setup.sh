#!/bin/sh

# Package
PACKAGE="lua"
DNAME="Lua"



service_preinst ()
{
	exit 0
}

service_postinst ()
{
	echo "Creating startup scripts for Lua executables" >> ${INST_LOG}
	for executable in ${SYNOPKG_PKGDEST}/bin/lua*; do
		echo "LD_LIBRARY_PATH=/var/packages/${PACKAGE}/target/lib:\${LD_LIBRARY_PATH} $executable" > /usr/local/bin/$(basename "$executable")
		chmod 755 /usr/local/bin/$(basename "$executable")
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

service_postuninst ()
{
	# Remove permanent config store for this package
	rm -rf /usr/syno/etc/packages/${PACKAGE}/

	exit 0
}

service_preupgrade ()
{
	exit 0
}

service_postupgrade ()
{
	exit 0
}

