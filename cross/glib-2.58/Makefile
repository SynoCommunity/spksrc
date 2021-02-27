PKG_NAME = glib
PKG_VERS = 2.58.3
PKG_SHORT_VERS=$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnome.org/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)

DEPENDS = native/glib-2.58 cross/libffi cross/pcre cross/zlib

HOMEPAGE = https://developer.gnome.org/glib/
COMMENT  = General-purpose utility library (version for older compilers)
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-man --disable-libmount --enable-shared=yes --enable-static=no
CONFIGURE_ARGS += glib_cv_long_long_format=ll glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=yes ac_cv_func_posix_getgrgid_r=yes
CONFIGURE_ARGS += GLIB_GENMARSHAL=$(WORK_DIR)/../../../native/glib/work-native/$(PKG_DIR)/gobject/glib-genmarshal
CONFIGURE_ARGS += GLIB_COMPILE_SCHEMAS=$(WORK_DIR)/../../../native/glib/work-native/$(PKG_DIR)/gio/glib-compile-schemas
CONFIGURE_ARGS += GLIB_COMPILE_RESOURCES=$(WORK_DIR)/../../../native/glib/work-native/$(PKG_DIR)/gio/glib-compile-resources

ADDITIONAL_CFLAGS = -Wno-unused-value

PRE_CONFIGURE_TARGET = glib_pre_configure

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --host=ppc-linux
endif

ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --host=arm-linux
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --host=x86_64-linux-gnu
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --host=i686-linux-gnu
endif

.PHONY: glib_pre_configure
glib_pre_configure: 
	# force autogen to first use internal pcre instead of provided to prevent
	# build failure.  Subsequent default configure will superseed this afterwards
	$(RUN) ./autogen.sh --with-pcre $(CONFIGURE_ARGS)
