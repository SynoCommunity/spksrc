PKG_NAME = ionice
PKG_REAL_NAME = util-linux
PKG_VERS = 2.40.1
PKG_VERS_MAJOR = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/linux/utils/$(PKG_REAL_NAME)/v$(PKG_VERS_MAJOR)
# use dedicated folder to build independent of other libraries built from util-linux (i.e. libuuid, libmount, libblkid, ionice, misc-util-linux)
PKG_DIR = $(PKG_NAME)/$(PKG_REAL_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)

DEPENDS =

HOMEPAGE = https://github.com/karelzak/util-linux
COMMENT  = Random collection of Linux utilities. We use this only to build ionice out of util-linux.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --without-ncurses
CONFIGURE_ARGS += --without-python
CONFIGURE_ARGS += --disable-asciidoc

include ../../mk/spksrc.archs.mk
ifneq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-year2038
endif

# build ionice only (schedutils = ionice, chrt, taskset)
# chrt, taskset and uclampset are disabled by patch to avoid configure error
CONFIGURE_ARGS += --disable-all-programs --enable-schedutils

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
