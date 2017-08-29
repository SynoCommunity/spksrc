PKG_NAME = squid
PKG_VERS_MAJOR = 3.5
PKG_VERS_MINOR = 27
PKG_VERS = $(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.squid-cache.org/Versions/v3/$(PKG_VERS_MAJOR)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/$(PKG_NAME) cross/berkeleydb

HOMEPAGE = http://www.squid-cache.org/
COMMENT  = Squid is a fully-featured HTTP/1.0 proxy which is almost HTTP/1.1 compliant.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = myPreConfigure

CONFIGURE_ARGS  = $(TC_CONFIGURE_ARGS) --prefix=$(INSTALL_PREFIX) --enable-icap-client --disable-strict-error-checking --cache-file=config.cache

HOSTCFGEN_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/src/cf_gen
HOSTCFGEN = $(WORK_DIR)/$(PKG_DIR)/src/cf_gen

# Compile
PRE_COMPILE_TARGET = myPreCompile

include ../../mk/spksrc.cross-cc.mk

myPreConfigure:
	echo "squid_cv_gnu_atomics=no" > $(WORK_DIR)/$(PKG_DIR)/config.cache
	echo "ac_cv_dbopen_libdb=yes" >> $(WORK_DIR)/$(PKG_DIR)/config.cache

myPreCompile:
	cp $(HOSTCFGEN_NATIVE) $(HOSTCFGEN)
