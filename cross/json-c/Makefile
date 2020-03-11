PKG_NAME = json-c
PKG_VERS = 0.12-20140410
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/json-c/json-c/archive/
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/json-c/
COMMENT  = JSON-C implements a reference counting object model that allows you to easily construct JSON objects in C, output them as JSON formatted strings and parse JSON formatted strings back into the C representation of JSON objects.
LICENSE  = https://github.com/json-c/json-c/blob/master/COPYING

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = json-c_pre_configure
CONFIGURE_ARGS = ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes


include ../../mk/spksrc.cross-cc.mk

.PHONY: json-c_pre_configure
json-c_pre_configure:
	$(RUN) ./autogen.sh
	export ac_cv_func_malloc_0_nonnull=yes && export ac_cv_func_realloc_0_nonnull=yes
