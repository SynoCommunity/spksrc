PKG_NAME = sidplay
PKG_RELE_MAIN = 2
PKG_NAME_FULL = $(PKG_NAME)$(PKG_RELE_MAIN)
PKG_VERS = $(PKG_RELE_MAIN).1.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-libs-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/$(PKG_NAME_FULL)/files/$(PKG_NAME_FULL)/$(PKG_NAME)-libs-$(PKG_VERS)

DEPENDS = cross/libtool

HOMEPAGE = http://sidplay2.sourceforge.net
COMMENT  = Capable of playing all C64 mono and stereo file formats
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-shared
PATCH_TARGET = patch_target myPatch
INSTALL_TARGET = install_target myInstall

include ../../mk/spksrc.cross-cc.mk

myPatch:
	sed -i "s/^AC_DISABLE_SHARED$$/AC_DISABLE_STATIC/g" $(WORK_DIR)/$(PKG_DIR)/builders/hardsid-builder/configure.ac
	sed -i "s/^AC_DISABLE_SHARED$$/AC_DISABLE_STATIC/g" $(WORK_DIR)/$(PKG_DIR)/builders/resid-builder/configure.ac

myInstall:
	ln -sfv ./sidplay/builders/libresid-builder.so $(STAGING_INSTALL_PREFIX)/lib/libresid-builder.so
	ln -sfv ./sidplay/builders/libresid-builder.so.0 $(STAGING_INSTALL_PREFIX)/lib/libresid-builder.so.0
	ln -sfv ./sidplay/builders/libhardsid-builder.so $(STAGING_INSTALL_PREFIX)/lib/libhardsid-builder.so
	ln -sfv ./sidplay/builders/libhardsid-builder.so.0 $(STAGING_INSTALL_PREFIX)/lib/libhardsid-builder.so.0
