PKG_NAME = glib
PKG_SHORT_VERS = 2.55
PKG_VERS = $(PKG_SHORT_VERS).2
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnome.org/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)

DEPENDS = native/glib native/python3 cross/libiconv cross/libffi cross/pcre cross/zlib

HOMEPAGE = http://developer.gnome.org/glib/
COMMENT  = General-purpose utility library
LICENSE  = GPLv2

GNU_CONFIGURE = 1

PYTHON_PATH = $(HOME)/spksrc/native/python3/work-native/install/usr/local/bin
ENV += PATH=$(PYTHON_PATH):$$PATH
CONFIGURE_ARGS = --enable-installed-tests=no --enable-always-build-tests=no 
CONFIGURE_ARGS += --enable-gtk-doc-html=no --enable-man=no  --enable-libmount=no --with-pcre=internal
CONFIGURE_ARGS += --with-pic  --with-libiconv=gnu
CONFIGURE_ARGS += --with-python="$(PYTHON_PATH)/python3"
CONFIGURE_ARGS += glib_cv_long_long_format=ll glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=yes ac_cv_func_posix_getgrgid_r=yes
CONFIGURE_ARGS += GLIB_GENMARSHAL=$(WORK_DIR)/../../../native/glib/work-native/$(PKG_DIR)/gobject/glib-genmarshal
CONFIGURE_ARGS += GLIB_COMPILE_SCHEMAS=$(WORK_DIR)/../../../native/glib/work-native/$(PKG_DIR)/gio/glib-compile-schemas
CONFIGURE_ARGS += GLIB_COMPILE_RESOURCES=$(WORK_DIR)/../../../native/glib/work-native/$(PKG_DIR)/gio/glib-compile-resources

ADDITIONAL_CFLAGS = -Wno-unused-value

include ../../mk/spksrc.cross-cc.mk
