PKG_NAME = squid
PKG_VERS = 3.1.22
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.squid-cache.org/Versions/v3/3.1/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/$(PKG_NAME) cross/linux-pam

HOMEPAGE = http://www.squid-cache.org/
COMMENT  = Squid is a fully-featured HTTP/1.0 proxy which is almost HTTP/1.1 compliant.
LICENSE  = 

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-arch-native --enable-icap-client --disable-strict-error-checking

HOSTCFGEN_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/src/cf_gen
HOSTCFGEN = $(WORK_DIR)/$(PKG_DIR)/cf_gen

# Compile
PRE_COMPILE_TARGET = myPreCompile

include ../../mk/spksrc.cross-cc.mk

myPreCompile:
	cp $(HOSTCFGEN_NATIVE) $(HOSTCFGEN)
