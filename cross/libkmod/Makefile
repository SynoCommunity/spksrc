PKG_NAME = kmod
PKG_VERS = 33
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/snapshot
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/zstd

HOMEPAGE = https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/about/
COMMENT  = kmod is a set of tools to handle common tasks with Linux kernel modules like insert, remove, list, check properties, resolve dependencies and aliases.
LICENSE  = LGPL 2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = kmod_pre_configure
CONFIGURE_ARGS = --disable-manpages

include ../../mk/spksrc.cross-cc.mk

.PHONY: kmod_pre_configure
kmod_pre_configure:
	$(RUN) ./autogen.sh
