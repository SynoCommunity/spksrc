PKG_NAME = ntopng
PKG_VERS = 7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ntop/ntopng/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Remarks: BUILD_DEPENDS variable is additionally used to add native node and npm to PATH
BUILD_DEPENDS = native/nodejs-16

DEPENDS  = cross/libcap cross/ndpi cross/curl
DEPENDS += cross/libmaxminddb cross/sqlite cross/mariadb-connector-c
DEPENDS += cross/readline cross/libzmq cross/libxml2 cross/glib cross/groff
DEPENDS += cross/json-c cross/rrdtool cross/lua
DEPENDS += cross/hiredis

HOMEPAGE = https://www.ntop.org/
COMMENT  = High-Speed Web-based Traffic Analysis and Flow Collection.
LICENSE  = GPLv3

include ../../mk/spksrc.common.mk

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
CONFIGURE_ARGS += ac_cv_prog_ac_ct_MARIADB=mariadb_config

ENV += DESTDIR=$(INSTALL_DIR)
# add install/bin folder to path to let ./configure find mysql_config (it is a script and works for cross compile)
# add native node and npm commands to path
NODE_BIN_FOLDER = $(realpath $(WORK_DIR)/../../../$(BUILD_DEPENDS)/work-native/node/bin)
NPM_BIN_FOLDER = $(realpath $(WORK_DIR)/../../../$(BUILD_DEPENDS)/work-native/node/lib/node_modules/npm/bin)
MARIADB_BIN_FOLDER = $(realpath $(WORK_DIR)/mariadb-connector-c/build/NATIVE/bin)
ENV += "PATH=$(PATH):$(MARIADB_BIN_FOLDER):$(NODE_BIN_FOLDER):$(NPM_BIN_FOLDER):$(STAGING_INSTALL_PREFIX)/bin"

# 'make dist' below is npm, and npm compiles the frontend's native addons (node-sass)
# for the node that runs them -- the native one, on the build machine. node-gyp takes
# its architecture from that node, so it emits -m64, which no cross compiler accepts.
# Name the build machine's tools for that step; everything else keeps the cross ones.
NPM_ENV  = CC="$(call native,gcc)" CXX="$(call native,g++)" AR="$(call native,ar)"
NPM_ENV += CPPFLAGS= CFLAGS= CXXFLAGS= LDFLAGS=

# npm gives up on the second failure and the registry is reached hundreds of times here,
# so one reset ends the build. Five tries, and a longer ceiling between them, since what
# fails is a read part-way through a tarball rather than a refused connection.
NPM_ENV += npm_config_fetch_retries=5 npm_config_fetch_retry_maxtimeout=120000

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
	@$(RUN) $(NPM_ENV) $(MAKE) dist
