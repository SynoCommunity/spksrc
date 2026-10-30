PKG_NAME = qemu
PKG_VERS = 10.2.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.qemu.org
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

include ../../mk/spksrc.common.mk
ifneq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
UNSUPPORTED_ARCHS = $(ARCH)
endif

# QEMU requires GCC 7.4 or newer; DSM 7.1 ships GCC 8.5.
MIN_GCC_VERSION = 7.4

DEPENDS  = cross/glib

HOMEPAGE = https://wiki.qemu.org/Features/GuestAgent
COMMENT  = Support for QMP commands and events that terminate and originate respectively within the guest using an agent built as part of QEMU.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-system --disable-user --enable-tools

include ../../mk/spksrc.cross-cc.mk
