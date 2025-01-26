PKG_NAME = ntopng
PKG_VERS = 6.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ntop/ntopng/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Remarks: BUILD_DEPENDS is additionally used to add native node and npm to PATH
BUILD_DEPENDS = native/nodejs_16

DEPENDS  = cross/libcap cross/ndpi cross/curl
DEPENDS += cross/libmaxminddb cross/sqlite cross/mysql-connector-c
DEPENDS += cross/readline cross/libzmq cross/libxml2 cross/glib cross/groff
DEPENDS += cross/json-c cross/rrdtool cross/lua
DEPENDS += cross/hiredis

# cross/ndpi and or cross/libcap not supported:
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://www.ntop.org/
COMMENT  = High-Speed Web-based Traffic Analysis and Flow Collection.
LICENSE  = GPLv3

include ../../mk/spksrc.archs.mk

SYNOLOGY_OS = DSM
ifeq ($(findstring $(ARCH),$(SRM_ARCHS)),$(ARCH))
SYNOLOGY_OS = SRM
endif

RW_LOCKS_SUPPORTED = yes
ADDITIONAL_LIBRARIES = -lcurl -llua
# similar to 'uname -m' on the target plattform (not essential, for information only)
PACKAGE_MACHINE = x86_64

ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
PACKAGE_MACHINE = armv7l
RW_LOCKS_SUPPORTED = no
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PACKAGE_MACHINE = armv7
RW_LOCKS_SUPPORTED = no
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PACKAGE_MACHINE = aarch64
RW_LOCKS_SUPPORTED = no
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
PACKAGE_MACHINE = ppc
RW_LOCKS_SUPPORTED = no
# for qoriq:
ADDITIONAL_LIBRARIES += -latomic
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PACKAGE_MACHINE = i686
RW_LOCKS_SUPPORTED = no
endif

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = ntopng_pre_configure
PRE_COMPILE_TARGET = ntopng_pre_compile
PRE_INSTALL_TARGET = ntopng_pre_install

CONFIGURE_ARGS  = --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-ndpi-includes=$(STAGING_INSTALL_PREFIX)/include/ndpi
CONFIGURE_ARGS += --with-ndpi-static-lib=$(STAGING_INSTALL_PREFIX)/lib
CONFIGURE_ARGS += my_cv_rw_locks_supported=$(RW_LOCKS_SUPPORTED)

ENV += DESTDIR=$(INSTALL_DIR)
# add install/bin folder to path to let ./configure find mysql_config (it is a script and works for cross compile)
# add native node and npm commands to path
NODE_BIN_FOLDER = $(realpath $(WORK_DIR)/../../../$(BUILD_DEPENDS)/work-native/node/bin)
NPM_BIN_FOLDER = $(realpath $(WORK_DIR)/../../../$(BUILD_DEPENDS)/work-native/node/lib/node_modules/npm/bin)
ENV += "PATH=$(PATH):$(NODE_BIN_FOLDER):$(NPM_BIN_FOLDER):$(STAGING_INSTALL_PREFIX)/bin"

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

.PHONY: ntopng_pre_compile
ntopng_pre_compile:
	@$(MSG) "- PATCH generated Makefile to link with additional (cross/*) libraries"
	@$(RUN) sed 's| -lssl  *-lssl | -lssl $(ADDITIONAL_LIBRARIES) |g' -i.orig ./Makefile

.PHONY: ntopng_pre_install
ntopng_pre_install:
	@$(MSG) "- COMPILE ntopng frontend (shared/ntopng/httpdocs/dist)"
	@$(RUN) $(MAKE) dist
