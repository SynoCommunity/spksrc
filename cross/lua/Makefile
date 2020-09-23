PKG_NAME = lua
PKG_VERS = 5.3.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.lua.org/ftp/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses cross/readline

HOMEPAGE = https://www.lua.org/
COMMENT = Lua is a powerful, efficient, lightweight, embeddable scripting language. It supports procedural programming, object-oriented programming, functional programming, data-driven programming, and data description.
LICENSE = MIT

CONFIGURE_TARGET = nop
COMPILE_TARGET = lua_custom_compile
INSTALL_TARGET = lua_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: lua_custom_compile
lua_custom_compile:
	@$(RUN) $(MAKE) linux \
		CC="$(TC_PATH)$(TC_PREFIX)gcc -fPIC \$$(ALLFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/readline" \
		CXX="$(TC_PATH)$(TC_PREFIX)g++ \$$(ALLFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/readline" \
		AR="$(TC_PATH)$(TC_PREFIX)ar rcu \$$(ALLFLAGS)" \
		RANLIB="$(TC_PATH)$(TC_PREFIX)ranlib \$$(ALLFLAGS)" \
		CPPFLAGS="$(CPPFLAGS)" \
		LDFLAGS="$(LDFLAGS) -Wl,--rpath,$(INSTALL_PREFIX)/lib" \
		MYLIBS="-lncurses"

.PHONY: lua_custom_install
lua_custom_install:
	@$(RUN) $(MAKE) install INSTALL_TOP=$(STAGING_INSTALL_PREFIX)

