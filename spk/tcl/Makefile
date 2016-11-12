SPK_NAME = tcl
SPK_VERS = 8.6.6
SPK_REV = 6
SPK_ICON = src/tcl.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DISTRIBUTOR = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com/
HELPURL = https://www.tcl.tk/doc/

DESCRIPTION = Tcl \(Tool Command Language\) is a very powerful but easy to learn dynamic programming language, suitable for a very wide range of uses, including web and desktop applications, networking, administration, testing and many more. Open source and business-friendly, Tcl is a mature yet evolving language that is truly cross platform, easily deployed and highly extensible.
RELOAD_UI = no
DISPLAY_NAME = Tcl
STARTABLE = no
CHANGELOG = "1. First Synology package release<br>2. Added symlink /usr/local/tcl, Changed symlinks to /var/packages/tcl/, Removed export LD_LIBRARY_PATH<br>3. Added additional symlinks in /usr/local/lib<br>4. Replaced references in tclConfig.sh with correct values.<br>5. Added patch for correct value of TCL_PACKAGE_PATH.<br>6. Reverted 4 and 5.<br>Compiler and installer now use different prefixes."

HOMEPAGE = http://www.tcl.tk
LICENSE = Custom

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT = src/dsm-control.sh

INSTALL_PREFIX	= /var/packages/$(SPK_NAME)/target

include ../../mk/spksrc.spk.mk

