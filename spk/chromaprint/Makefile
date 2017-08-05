SPK_NAME = chromaprint
SPK_VERS = 1.4.2
SPK_REV = 4
SPK_ICON = src/chromaprint.png

DEPENDS  = cross/lame cross/$(SPK_NAME)

STARTABLE = no

MAINTAINER = cytec
DESCRIPTION = "Chromaprint is the core component of the AcoustID project. It's a client-side library that implements a custom algorithm for extracting fingerprints from any audio source. "
DISPLAY_NAME = Chromaprint
CHANGELOG = "1. Update to 1.4.2  2. Replace openssl by gnutls because of rtmpdump"

HOMEPAGE   = http://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
