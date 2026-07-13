PKG_NAME = glibc
PKG_VERS = 2.37
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/glibc/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://www.gnu.org/software/libc/
COMMENT  = The GNU C Library (glibc)
LICENSE  = GPLv2/LGPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.common.mk

# glibc must be built outside its source tree: opt in to an out-of-tree build.
BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)-build

# glibc sets its prefix at configure time, so install only needs DESTDIR.
INSTALL_ARGS = install DESTDIR=$(INSTALL_DIR)

CONFIGURE_ARGS  = --enable-shared
CONFIGURE_ARGS += --enable-kernel=$(word 1,$(subst ., ,$(TC_KERNEL))).$(word 2,$(subst ., ,$(TC_KERNEL)))
CONFIGURE_ARGS += --disable-timezone-tools
CONFIGURE_ARGS += --disable-crypt
CONFIGURE_ARGS += --disable-build-nscd
CONFIGURE_ARGS += --disable-nscd
CONFIGURE_ARGS += --disable-werror
CONFIGURE_ARGS += --enable-stack-protector=strong
CONFIGURE_ARGS += --with-headers=$(TC_WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE)
CONFIGURE_ARGS += ac_cv_prog_MAKEINFO=false

ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
