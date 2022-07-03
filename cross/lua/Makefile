PKG_NAME = lua
PKG_VERS = 5.4.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.lua.org/ftp
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/readline

HOMEPAGE = https://www.lua.org/
COMMENT = Lua is a powerful, efficient, lightweight, embeddable scripting language. It supports procedural programming, object-oriented programming, functional programming, data-driven programming, and data description.
LICENSE = MIT

CONFIGURE_TARGET = nop
INSTALL_MAKE_OPTIONS = install INSTALL_TOP=$(STAGING_INSTALL_PREFIX)

COMPILE_MAKE_OPTIONS += linux-readline
COMPILE_MAKE_OPTIONS += CC="$(TC_PATH)$(TC_PREFIX)gcc -fPIC \$$(ALLFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/readline"
COMPILE_MAKE_OPTIONS += CXX="$(TC_PATH)$(TC_PREFIX)g++ \$$(ALLFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/readline"
COMPILE_MAKE_OPTIONS += AR="$(TC_PATH)$(TC_PREFIX)ar rcu \$$(ALLFLAGS)"
COMPILE_MAKE_OPTIONS += RANLIB="$(TC_PATH)$(TC_PREFIX)ranlib \$$(ALLFLAGS)"
COMPILE_MAKE_OPTIONS += CPPFLAGS="$(CPPFLAGS)"
COMPILE_MAKE_OPTIONS += LDFLAGS="$(LDFLAGS) -Wl,--rpath,$(INSTALL_PREFIX)/lib"
COMPILE_MAKE_OPTIONS += MYLIBS="-lncursesw"

include ../../mk/spksrc.cross-cc.mk
