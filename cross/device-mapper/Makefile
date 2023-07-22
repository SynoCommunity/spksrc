PKG_NAME = device-mapper
PKG_REAL_NAME = LVM2
PKG_VERS = 1.02.195
PKG_REAL_VERS = 2.03.21
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_REAL_NAME).$(PKG_REAL_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mirrors.kernel.org/sourceware/lvm2
PKG_DIR = $(PKG_REAL_NAME).$(PKG_REAL_VERS)

DEPENDS = cross/libblkid

HOMEPAGE = https://sourceware.org/lvm2/
COMMENT  = Device-mapper userspace library
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-thin=no
CONFIGURE_ARGS += --with-cache=no
CONFIGURE_ARGS += --with-vdo-format=no
CONFIGURE_ARGS += --with-optimisation=-O2
CONFIGURE_ARGS += --enable-pkgconfig
CONFIGURE_ARGS += --disable-selinux
CONFIGURE_ARGS += --disable-readline

COMPILE_MAKE_OPTIONS = $(PKG_NAME)

INSTALL_MAKE_OPTIONS = install_$(PKG_NAME) DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
