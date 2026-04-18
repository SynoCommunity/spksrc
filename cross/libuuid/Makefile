PKG_NAME = libuuid
PKG_REAL_NAME = util-linux
PKG_VERS = 2.42
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/linux/utils/util-linux/v$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_REAL_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/karelzak/util-linux
COMMENT  = Random collection of Linux utilities. We use this only to build libuuid out of util-linux.
LICENSE  = GPLv2

CONFIGURE_ARGS  = -Dbuild-libuuid=enabled
CONFIGURE_ARGS += -Ddefault_library=shared
#
CONFIGURE_ARGS += -Dncurses=disabled
CONFIGURE_ARGS += -Dreadline=disabled
CONFIGURE_ARGS += -Dbuild-libblkid=disabled
CONFIGURE_ARGS += -Dbuild-libmount=disabled
CONFIGURE_ARGS += -Dbuild-libfdisk=disabled
CONFIGURE_ARGS += -Dbuild-libsmartcols=disabled
CONFIGURE_ARGS += -Dbuild-python=disabled
CONFIGURE_ARGS += -Dbuild-uuidd=disabled
CONFIGURE_ARGS += -Dbuild-plymouth-support=disabled
CONFIGURE_ARGS += -Dprogram-tests=false

include ../../mk/spksrc.cross-meson.mk
