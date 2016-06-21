PKG_NAME = lua
PKG_VERS = 5.3.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.lua.org/ftp
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/readline

HOMEPAGE = http://www.lua.org
COMMENT  = Lua is a powerful, efficient, lightweight, embeddable scripting language

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myConfigure:
myCompile:
	$(RUN) $(MAKE) linux MYCFLAGS="$(CFLAGS)" MYLDFLAGS="$(LDFLAGS)" MYLIBS="-lncurses"
myInstall:
	$(RUN) $(MAKE) install INSTALL_TOP=$(STAGING_INSTALL_PREFIX)
