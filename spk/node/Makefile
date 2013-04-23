SPK_NAME = node
SPK_VERS = 0.10.4
SPK_REV = 2
SPK_ICON = src/resized-nodejs-logo.png

DEPENDS  = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Node.js is a platform built on Chrome\'s JavaScript runtime for easily building fast, scalable network applications.
DESCRIPTION_FRE = Node.js is a platform built on Chrome\\\'s JavaScript runtime for easily building fast, scalable network applications.
DESCRIPTION_SPN = Node.js
DISPLAY_NAME = Node.js

#SUPPORTED_ARCHS = 88f6281 bromolow cedarview x86

HOMEPAGE   = http://nodejs.org/
LICENSE    = MIT

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

BUSYBOX_CONFIG  = nice
# Add ionice for ARCHs that support it
ifeq ($(findstring $(ARCH),88f6281 qoriq),$(ARCH))
BUSYBOX_CONFIG += ionice
endif
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

