PKG_NAME = qemu
PKG_VERS = 9.0.1
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

# x64-7.2:
# cross/glib fails to build glib 2.78.4 and glib 2.66.8 (all glib versions built with meson):
#  glib/gnulib/meson.build:313:2: ERROR: Problem encountered: frexp() is missing or broken beyond repair, and we have nothing to replace it with
