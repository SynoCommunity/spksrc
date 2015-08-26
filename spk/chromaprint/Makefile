SPK_NAME = chromaprint
SPK_VERS = 1.2
SPK_REV = 2
SPK_ICON = src/chromaprint.png

DEPENDS  = cross/lame cross/$(SPK_NAME)

STARTABLE = no

BETA = 1

MAINTAINER = SynoCommunity
DESCRIPTION = "Chromaprint is the core component of the AcoustID project. It's a client-side library that implements a custom algorithm for extracting fingerprints from any audio source. "
DISPLAY_NAME = Chromaprint
CHANGELOG = "Fix shared libraries error when using fpcalc"

HOMEPAGE   = http://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
