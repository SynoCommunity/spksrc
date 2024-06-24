PKG_NAME = open-vm-tools
PKG_VERS = 11.3.5-18557794
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/vmware/open-vm-tools/releases/download/stable-$(firstword $(subst -, ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# even some archs might sucessfully build, only x86_64 does support VMware virtualization.
UNSUPPORTED_ARCHS = $(i686_ARCHS) $(PPC_ARCHS) $(ARM_ARCHS)

BUILD_DEPENDS = native/glib
DEPENDS = cross/glib-2.58
DEPENDS += cross/libmspack

HOMEPAGE = https://github.com/vmware/open-vm-tools
COMMENT  = open-vm-tools is a set of services and modules that enable several features in VMware products for better management of, and seamless user interactions with, guests.
LICENSE  = GPLv2/LGPLv2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-pam --without-x

# requires glib-genmarshal binary built for host system
NATIVE_GLIB_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/glib/work-native/install/usr/local/bin)
ENV += PATH=$(NATIVE_GLIB_BIN_DIR):$$PATH

include ../../mk/spksrc.cross-cc.mk
