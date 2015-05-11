PKG_NAME = LuaJIT
PKG_VERS = 2.0.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://luajit.org/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://luajit.org/
COMMENT  = LuaJIT is a Just-In-Time Compiler (JIT) for the Lua programming language.

CONFIGURE_TARGET = nope
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

LICENSE  = http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
include ../../mk/spksrc.cross-cc.mk


myCompile:
	$(RUN) make CROSS=$(TC_PATH)$(TC_PREFIX) LDFLAGS="-Wl,-export-dynamic" CFLAGS= HOST_CC="gcc"


myInstall:
	$(RUN) make install DPREFIX=$(STAGING_INSTALL_PREFIX)


