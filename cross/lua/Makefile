PKG_NAME = lua
PKG_VERS = 5.4.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.lua.org/ftp
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/readline

HOMEPAGE = https://www.lua.org/
COMMENT = Lua is a powerful, efficient, lightweight, embeddable scripting language. It supports procedural programming, object-oriented programming, functional programming, data-driven programming, and data description.
LICENSE = MIT

CONFIGURE_TARGET = nop
INSTALL_ARGS = install INSTALL_TOP=$(STAGING_INSTALL_PREFIX)

COMPILE_ARGS += linux-readline
COMPILE_ARGS += CC="$(call tc,gcc) -fPIC \$$(ALLFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/readline"
COMPILE_ARGS += CXX="$(call tc,g++) \$$(ALLFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/readline"
COMPILE_ARGS += AR="$(call tc,ar) rcu \$$(ALLFLAGS)"
COMPILE_ARGS += RANLIB="$(call tc,ranlib) \$$(ALLFLAGS)"
COMPILE_ARGS += CPPFLAGS="$(CPPFLAGS)"
COMPILE_ARGS += LDFLAGS="$(LDFLAGS) -Wl,--rpath,$(INSTALL_PREFIX)/lib"
COMPILE_ARGS += MYLIBS="-lncursesw"

include ../../mk/spksrc.cross-cc.mk
