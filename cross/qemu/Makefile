PKG_NAME = qemu
PKG_VERS = 9.2.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.qemu.org
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

include ../../mk/spksrc.common.mk
ifneq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
UNSUPPORTED_ARCHS = $(ARCH)
endif

DEPENDS  = cross/glib
DEPENDS += cross/pixman

HOMEPAGE = https://wiki.qemu.org/Features/GuestAgent
COMMENT  = Support for QMP commands and events that terminate and originate respectively within the guest using an agent built as part of QEMU.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --target-list=x86_64-softmmu

include ../../mk/spksrc.cross-cc.mk
