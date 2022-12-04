PKG_NAME = sshfs2
PKG_REAL_NAME = sshfs
PKG_VERS = 2.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/sshfs/releases/download/sshfs-$(PKG_VERS)
PKG_DIR = $(PKG_REAL_NAME)-$(PKG_VERS)

DEPENDS = cross/fuse
OPTIONAL_DEPENDS = cross/glib cross/glib-2.58

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# old compilers do not support current cross/glib (with meson build)
DEPENDS += cross/glib-2.58
else
DEPENDS += cross/glib
endif

HOMEPAGE = https://github.com/libfuse/sshfs
COMMENT  = sshfs is a network filesystem client to connect to SSH servers.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
