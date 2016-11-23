#!/bin/sh

# Package
PACKAGE="optware-ng"
DNAME="optware-ng"

# Others
URL="http://ipkg.nslu2-linux.org/optware-ng/bootstrap"
VOL="/volume1"
AT="@${PACKAGE}"
TO="${VOL}/${AT}"

INSTALL_DIR="/opt"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"

preinst ()
{
    exit 0
}

postinst ()
{
    ARCH=$(
	uname -a |
	awk -F'[ _]' '
	BEGIN {
		map["88f5281"] = \
		map["88f6281"] = \
		map["88f6282"] =	"armv5eabi-ng"
		map["alpine"] = \
		map["alpine4k"] = \
		map["armada370"] = \
		map["armada375"] = \
		map["armada38x"] = \
		map["armadaxp"] = \
		map["comcerto2k"] = \
		map["monaco"] =		"armeabihf"
		map["avoton"] =	\
		map["braswell"] = \
		map["bromolow"] = \
		map["cedarview"] = \
		map["x64"] = \
		map["x86"] =		"i686"
		map["powerpc"] = \
		map["ppc824x"] = \
		map["ppc853x"] = \
		map["ppc854x"] = \
		map["qoriq"] =		"ppc-603e"
		rc = 1
	}
	{
		arch = $(NF-1)
		if (arch in map) {
			print map[arch]
			rc = 0
		}
	}
	END {
		exit rc
	}') ||
    exit

    [ -d "${TO}" ] ||
    mkdir "${TO}" ||
    exit

    [ -L "${INSTALL_DIR}" ] ||
    ln -s "${TO}" "${INSTALL_DIR}" ||
    exit

    grep -q "alllexx" "${INSTALL_DIR}/etc/ipkg.conf" &&
    exit

    wget -O- "${URL}/buildroot-${ARCH}-bootstrap.sh" |
    sed -e "s| data.tar.gz| & --wildcards './opt/*'|" \
	-e '/alllexx.*ipkg/s| > | >> |' \
	-e '/dest.*opt.*ipkg/s|^|#|' |
    sh ||
    exit

    rm -f "${ipk_name}" data.tar.gz

    ipkg install bash

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove symlink
    rm -f "${INSTALL_DIR}"

    exit 0
}

preupgrade ()
{
    # Stop the package
    "${SSS}" stop

    exit 0
}

postupgrade ()
{
    exit 0
}

