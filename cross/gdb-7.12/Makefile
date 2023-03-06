PKG_NAME = gdb
PKG_VERS = 7.12.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/gdb
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libexpat cross/gmp cross/ncursesw cross/mpfr

HOMEPAGE = https://www.gnu.org/software/gdb/
COMMENT  = The GNU Project Debugger
LICENSE  = GPLv2/LGPLv2

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

GNU_CONFIGURE = 1

CONFIGURE_TARGET = gdb_configure
COMPILE_TARGET = gdb_compile
INSTALL_TARGET = gdb_install

include ../../mk/spksrc.common.mk

CONFIGURE_ARGS += $(TC_CONFIGURE_ARGS)
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-host-shared
CONFIGURE_ARGS += --with-system-zlib
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
CONFIGURE_ARGS += --localstatedir=$(INSTALL_PREFIX_VAR)
endif

include ../../mk/spksrc.cross-cc.mk

# Library is not created under armv5 and armv7
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
PLIST_TRANSFORM = sed -e 's?lib:lib/libinproctrace.so??g'
# binary only created on armv7
else
PLIST_TRANSFORM = sed -e 's?bin:bin/run??g'
endif

.PHONY: gdb_configure
gdb_configure:
	@$(RUN) mkdir -p build
	@$(RUN) ; cd build ; PATH=$(TC_PATH):$$PATH CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" CPPFLAGS="$(CPPFLAGS)" CXXFLAGS="$(CXXFLAGS)" $(WORK_DIR)/$(PKG_DIR)/configure $(CONFIGURE_ARGS)

.PHONY: gdb_compile
gdb_compile:
	@$(RUN) ; cd build ; PATH=$(TC_PATH):$$PATH make

.PHONY: gdb_install
gdb_install:
	@$(RUN) ; cd build ; PATH=$(TC_PATH):$$PATH make install DESTDIR=$(INSTALL_DIR)
