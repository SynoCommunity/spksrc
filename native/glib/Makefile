PKG_NAME = glib
PKG_SHORT_VERS = 2.36
PKG_VERS = $(PKG_SHORT_VERS).1
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnome.org/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)

DEPENDS = native/libffi

HOMEPAGE = http://developer.gnome.org/glib/
COMMENT  = General-purpose utility library
LICENSE  =

GNU_CONFIGURE = 1
ifeq ($(shell uname -m), x86_64)
CONFIGURE_ARGS = LIBFFI_CFLAGS="-I$(WORK_DIR)/../../libffi/work-native/native/include" LIBFFI_LIBS="-L$(WORK_DIR)/../../libffi/work-native/native/lib64 -lffi"
else
CONFIGURE_ARGS = LIBFFI_CFLAGS="-I$(WORK_DIR)/../../libffi/work-native/native/include" LIBFFI_LIBS="-L$(WORK_DIR)/../../libffi/work-native/native/lib -lffi"
endif

include ../../mk/spksrc.native-cc.mk
