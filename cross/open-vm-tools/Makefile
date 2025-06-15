PKG_NAME = open-vm-tools
PKG_VERS = 11.3.5-18557794
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/vmware/open-vm-tools/releases/download/stable-$(firstword $(subst -, ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Even some archs might sucessfully build, only x86_64 does support VMware virtualization.
UNSUPPORTED_ARCHS = $(i686_ARCHS) $(PPC_ARCHS) $(ARM_ARCHS)

DEPENDS  = cross/glib
DEPENDS += cross/libmspack
DEPENDS += cross/libiconv
# required when building with DSM 7.2 toolchain
DEPENDS += cross/libtirpc

HOMEPAGE = https://github.com/vmware/open-vm-tools
COMMENT  = open-vm-tools is a set of services and modules that enable several features in VMware products for better management of, and seamless user interactions with, guests.
LICENSE  = GPLv2/LGPLv2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-docs
CONFIGURE_ARGS += --disable-tests
CONFIGURE_ARGS += --without-pam
CONFIGURE_ARGS += --without-x

# Build requires glib-genmarshal (python3 script) in path
ENV += PATH=$(STAGING_INSTALL_PREFIX)/bin:$$PATH

# Dependency of lib/misc/codesetOld.c
ADDITIONAL_LDFLAGS = -liconv

include ../../mk/spksrc.cross-cc.mk
