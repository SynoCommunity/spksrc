SPK_NAME = tcl
SPK_VERS = 8.6.6
SPK_REV = 1
SPK_ICON = src/tcl.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER	= Tcl developer Xchange
MAINTAINER_URL	= https://www.tcl.tk/
DISTRIBUTOR	= SynoCommunity
DISTRIBUTOR_URL	= https://synocommunity.com/
HELPURL		= https://www.tcl.tk/doc/

DESCRIPTION = Tcl \(Tool Command Language\) is a very powerful but easy to learn dynamic programming language, suitable for a very wide range of uses, including web and desktop applications, networking, administration, testing and many more. Open source and business-friendly, Tcl is a mature yet evolving language that is truly cross platform, easily deployed and highly extensible.
RELOAD_UI = no
DISPLAY_NAME = Tcl
STARTABLE = no
CHANGELOG = "First Synology package release"

HOMEPAGE = http://www.tcl.tk
LICENSE = Custom

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

