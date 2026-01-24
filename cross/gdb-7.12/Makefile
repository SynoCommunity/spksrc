PKG_NAME = gdb
PKG_VERS = 7.12.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/gdb
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libexpat cross/gmp cross/ncursesw cross/mpfr

HOMEPAGE = https://www.gnu.org/software/gdb/
COMMENT  = The GNU Project Debugger.
LICENSE  = GPLv2/LGPLv2

GNU_CONFIGURE = 1

CONFIGURE_TARGET = gdb_configure
COMPILE_TARGET = gdb_compile
INSTALL_TARGET = gdb_install

CONFIGURE_ARGS  = --enable-host-shared
CONFIGURE_ARGS += --with-system-zlib

include ../../mk/spksrc.common.mk

PLIST_TRANSFORM_SED_ARGS =

# Library is not created for 32-bit non intel archs
ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
ifneq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PLIST_TRANSFORM_SED_ARGS += -e 's?lib:lib/libinproctrace.so??g'
endif
endif

ifneq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
# binary only created for arm
PLIST_TRANSFORM_SED_ARGS += -e 's?bin:bin/run??g'
endif

ifneq ($(strip $(PLIST_TRANSFORM_SED_ARGS)),)
PLIST_TRANSFORM = sed $(PLIST_TRANSFORM_SED_ARGS)
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: gdb_configure
gdb_configure:
	@$(RUN) mkdir -p build
	@$(RUN) ; cd build ; PATH=$(abspath $(TC_PATH)):$$PATH CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" CPPFLAGS="$(CPPFLAGS)" CXXFLAGS="$(CXXFLAGS)" $(WORK_DIR)/$(PKG_DIR)/configure $(REAL_CONFIGURE_ARGS)

.PHONY: gdb_compile
gdb_compile:
	@$(RUN) ; cd build ; PATH=$(abspath $(TC_PATH)):$$PATH $(MAKE)

.PHONY: gdb_install
gdb_install:
	@$(RUN) ; cd build ; PATH=$(abspath $(TC_PATH)):$$PATH $(MAKE) install DESTDIR=$(INSTALL_DIR)
