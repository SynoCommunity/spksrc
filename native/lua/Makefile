PKG_NAME = lua
PKG_VERS = 5.4.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.lua.org/ftp
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.lua.org/
COMMENT = Lua is a powerful, efficient, lightweight, embeddable scripting language.
LICENSE = MIT

CONFIGURE_TARGET = nop
COMPILE_MAKE_OPTIONS = linux
INSTALL_MAKE_OPTIONS = install INSTALL_TOP=$(INSTALL_DIR)

include ../../mk/spksrc.native-cc.mk
