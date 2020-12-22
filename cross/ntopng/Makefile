PKG_NAME = ntopng
PKG_VERS = 4.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ntop/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/libcap cross/ndpi cross/curl
DEPENDS += cross/libmaxminddb cross/sqlite cross/libmysqlclient
DEPENDS += cross/readline cross/libzmq cross/libxml2 cross/glib cross/groff
DEPENDS += cross/json-c cross/rrdtool cross/lua

HOMEPAGE = https://www.ntop.org/
COMMENT  = ntopng is the next generation version of the original ntop, a network traffic probe that monitors network usage. ntopng is based on libpcap and it has been written in a portable way in order to virtually run on every Unix platform, MacOSX and on Windows as well.
LICENSE  = GPLv3

include ../../mk/spksrc.archs.mk

SYNOLOGY_OS = DSM
ifeq ($(findstring $(ARCH),$(SRM_ARCHS)),$(ARCH))
SYNOLOGY_OS = SRM
endif

# similar to 'uname -m' on the target plattform (not essential, for information only)
PACKAGE_MACHINE = x86_64

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
PACKAGE_MACHINE = armv5
endif
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
PACKAGE_MACHINE = armv7l
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PACKAGE_MACHINE = armv7
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PACKAGE_MACHINE = aarch64
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
PACKAGE_MACHINE = ppc
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PACKAGE_MACHINE = i686
endif

GNU_CONFIGURE = 1
PRE_PATCH_TARGET = ntopng_pre_patch
PRE_CONFIGURE_TARGET = ntopng_pre_configure
PRE_COMPILE_TARGET = ntopng_pre_compile

CONFIGURE_ARGS  = --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-ndpi-includes=$(STAGING_INSTALL_PREFIX)/include/ndpi
CONFIGURE_ARGS += --with-ndpi-static-lib=$(STAGING_INSTALL_PREFIX)/lib

# let ./configure find mysql_config (it is a script and works for cross compile)
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"
ENV += DESTDIR=$(INSTALL_DIR)

include ../../mk/spksrc.cross-cc.mk

.PHONY: ntopng_pre_patch
ntopng_pre_patch:
	@$(RUN) ./autogen.sh

.PHONY: ntopng_pre_configure
ntopng_pre_configure:
	@$(MSG) "- patch generated configure file to define synology specific package info"
	@$(RUN) sed -i 's|#define PACKAGE_OSNAME "$${OSNAME}"|#define PACKAGE_OSNAME "Synology $(SYNOLOGY_OS) $(TCVERSION)+"|g' ./configure
	@$(RUN) sed -i 's|#define PACKAGE_OS "$${OS}"|#define PACKAGE_OS "$(TC_ARCH)"|g' ./configure
	@$(RUN) sed -i 's|#define PACKAGE_MACHINE "$$MACHINE"|#define PACKAGE_MACHINE "$(PACKAGE_MACHINE)"|g' ./configure
	@$(MSG) "- patch sources to define real version instead of 'major.minor.currentdate', fix github links, reformat copyright date"
	@$(RUN) sed -i "s|PACKAGE_VERSION='.*'|PACKAGE_VERSION='$(PKG_VERS)'|g" ./configure
	@$(RUN) sed -i "s|PACKAGE_STRING='ntopng .*'|PACKAGE_STRING='ntopng $(PKG_VERS)'|g" ./configure
	@$(RUN) sed -i 's|GIT_RELEASE=".*"|GIT_RELEASE="$(PKG_VERS)"|g' ./configure
	@$(RUN) sed -i 's|"https://github.com/ntop/ntopng/commit/"..|"https://github.com/ntop/ntopng/releases/tag/"..|g' ./scripts/lua/about.lua
	@$(RUN) sed -i 's|"http://www.d3js.org|"http://d3js.org|g' ./scripts/lua/about.lua
	@$(RUN) sed -i 's|"(C) 1998-\(..\) ntop.org"|"(C) 1998-20\1 ntop.org"|g' ./include/ntop_defines.h
	@$(RUN) sed -i 's|copy; 1998-\(..\) - ntop.org"|copy; 1998-20\1 - ntop.org"|g' ./src/LuaEngine.cpp
	@$(RUN) sed -i 's|"Welcome to %s %s v.%s - (C) 1998-\(..\) ntop.org"|"Welcome to %s %s v.%s - (C) 1998-20\1 ntop.org"|g' ./src/Ntop.cpp

.PHONY: ntopng_pre_compile
ntopng_pre_compile:
	@$(MSG) "- patch generated Makefile to ignore third-party libs and use cross/* packages instead"
	@$(RUN) sed -i 's|LIB_TARGETS = $$(LUA_LIB)|LIB_TARGETS =|g' ./Makefile
	@$(RUN) sed -i 's|$$(LIBPCAP) $$(LUA_LIB) $$(LIBRRDTOOL_LIB)|$$(LIBPCAP) $$(LIBRRDTOOL_LIB)|g' ./Makefile
	@$(RUN) sed -i 's| -l   -L/| -L/|g' ./Makefile
	@$(RUN) sed -i 's| -l   -lexpat -L/| -lexpat -L/|g' ./Makefile
	@$(RUN) sed -i 's| -lssl -lssl | -lssl -lcurl -llua -lmysqlclient |g' ./Makefile
	@$(RUN) sed -i 's|-L/usr/local/lib -lrt -lz -ldl -lcurl |-L/usr/local/lib -lrt -lz -ldl |g' ./Makefile
	@$(RUN) sed -i 's|-L/usr/local/lib -lcap -lrt -lz -ldl -lcurl |-L/usr/local/lib -lcap -lrt -lz -ldl |g' ./Makefile
