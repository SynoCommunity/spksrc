PKG_NAME = ntopng
PKG_VERS = 7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ntop/ntopng/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/libcap cross/ndpi cross/curl
DEPENDS += cross/libmaxminddb cross/sqlite
DEPENDS += cross/libzmq
DEPENDS += cross/json-c cross/rrdtool cross/lua
DEPENDS += cross/hiredis
DEPENDS += cross/ntopng-dist

HOMEPAGE = https://www.ntop.org/
COMMENT  = High-Speed Web-based Traffic Analysis and Flow Collection.
LICENSE  = GPLv3

# ntopng 7.0 is C++17; GCC < 7 cannot compile it.
MIN_GCC_VERSION = 7

include ../../mk/spksrc.common.mk

SYNOLOGY_OS = DSM
ifeq ($(findstring $(ARCH),$(SRM_ARCHS)),$(ARCH))
SYNOLOGY_OS = SRM
endif

ADDITIONAL_LDFLAGS = -llua
# similar to 'uname -m' on the target plattform (not essential, for information only)
PACKAGE_MACHINE = x86_64

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PACKAGE_MACHINE = armv7
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PACKAGE_MACHINE = aarch64
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PACKAGE_MACHINE = i686
endif

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = ntopng_pre_configure

CONFIGURE_ARGS  = --with-ndpi-includes=$(STAGING_INSTALL_PREFIX)/include/ndpi
CONFIGURE_ARGS += --with-ndpi-static-lib=$(STAGING_INSTALL_PREFIX)/lib

ENV += DESTDIR=$(INSTALL_DIR)

include ../../mk/spksrc.cross-cc.mk

.PHONY: ntopng_pre_configure
ntopng_pre_configure:
	@$(MSG) "- RUN autogen to create configure file"
	@$(RUN) ./autogen.sh
	@$(MSG) "- PATCH sources to fix github links, reformat copyright date and define synology machine and os info"
	@$(RUN) sed 's|"https://github.com/ntop/ntopng/commit/" |"https://github.com/ntop/ntopng/releases/tag/" |g' -i.orig ./scripts/lua/modules/lua_utils_get.lua
	@$(RUN) sed 's|"(C) 1998-\(..\) ntop.org"|"(C) 1998-20\1 ntop.org"|g' -i.orig ./include/ntop_defines.h
	@$(RUN) sed 's|copy; 1998-\(..\) - ntop"|copy; 1998-20\1 - ntop"|g' -i.orig ./src/LuaEngineNtop.cpp
	@$(RUN) sed 's|, PACKAGE_OS, PACKAGE_MACHINE|, "Synology $(SYNOLOGY_OS) $(TCVERSION)+", "$(PACKAGE_MACHINE)"|g' -i ./src/LuaEngineNtop.cpp
	@$(RUN) sed 's|PACKAGE_MACHINE|"$(TC_ARCH)"|g' -i ./src/LuaEngineNtop.cpp
	@$(RUN) sed 's|PACKAGE_OS|"$(SYNOLOGY_OS) $(TCVERSION)+"|g' -i ./src/LuaEngineNtop.cpp
