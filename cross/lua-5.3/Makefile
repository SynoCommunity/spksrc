PKG_NAME = lua
PKG_VERS = 5.3.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
# lua.org can be unreachable from CI runners, so fall back to the PUC-Rio tecgraf
# mirror of the official /ftp tree (byte-identical tarball, same checksum).
PKG_DIST_SITE = https://www.lua.org/ftp
PKG_DIST_MIRRORS = https://www.tecgraf.puc-rio.br/lua/ftp
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# domoticz requires Lua 5.3 and pins the version (find_package(Lua 5.3))
# Keep this package for domoticz only, do not bump to 5.4
DEPENDS = cross/ncursesw cross/readline

HOMEPAGE = https://www.lua.org/
COMMENT  = Lua is a powerful, efficient, lightweight, embeddable scripting language.
LICENSE  = MIT

CONFIGURE_TARGET = nop

# install only the headers and static library with the versioned names
# expected by domoticz (lua5.3/lua.h, liblua5.3.a)
INSTALL_TARGET = lua53_install

COMPILE_ARGS += linux
COMPILE_ARGS += CC="$(TC_PATH)$(TC_PREFIX)gcc -fPIC \$$(ALLFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/readline"
COMPILE_ARGS += CXX="$(TC_PATH)$(TC_PREFIX)g++ \$$(ALLFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/readline"
COMPILE_ARGS += AR="$(TC_PATH)$(TC_PREFIX)ar rcu \$$(ALLFLAGS)"
COMPILE_ARGS += RANLIB="$(TC_PATH)$(TC_PREFIX)ranlib \$$(ALLFLAGS)"
COMPILE_ARGS += CPPFLAGS="$(CPPFLAGS)"
COMPILE_ARGS += LDFLAGS="$(LDFLAGS) -Wl,--rpath,$(INSTALL_PREFIX)/lib"
COMPILE_ARGS += MYLIBS="-lncursesw"

include ../../mk/spksrc.cross-cc.mk

.PHONY: lua53_install
lua53_install:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/include/lua5.3 $(STAGING_INSTALL_PREFIX)/lib
	$(RUN) install -m 644 src/lua.h src/lua.hpp src/luaconf.h src/lauxlib.h src/lualib.h $(STAGING_INSTALL_PREFIX)/include/lua5.3/
	$(RUN) install -m 644 src/liblua.a $(STAGING_INSTALL_PREFIX)/lib/liblua5.3.a
