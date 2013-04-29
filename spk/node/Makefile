SPK_NAME = node
SPK_VERS = 0.10.5
SPK_REV = 2
SPK_ICON = src/nodejs.png

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Node.js is a platform built on Chrome\'s JavaScript runtime for easily building fast, scalable network applications.
DESCRIPTION_FRE = Node.js is a platform built on Chrome\\\'s JavaScript runtime for easily building fast, scalable network applications.
DISPLAY_NAME = Node.js

ifneq ($(findstring $(ARCH),88f6281 bromolow cedarview x86),$(ARCH))
$(error $(ARCH) is not a supported architecture)
endif

HOMEPAGE   = http://nodejs.org/
LICENSE    = MIT

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

