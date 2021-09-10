PKG_NAME = google-authenticator-libpam
PKG_VERS = 1.09
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/google/google-authenticator-libpam/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/libpam

HOMEPAGE = https://github.com/google/google-authenticator-libpam
COMMENT = PAM module for two-factor authentication logging into servers via SSH, OpenVPN, etc.
LICENSE = Apache-2.0

# need to include headers and library of libpam dependency
ADDITIONAL_CFLAGS = -I$(INSTALL_DIR)/usr/include
ADDITIONAL_CXXFLAGS = -I$(INSTALL_DIR)/usr/include
ADDITIONAL_LDFLAGS = -L$(INSTALL_DIR)/lib64

include ../../mk/spksrc.cross-cc.mk

.PHONY: glib_pre_configure
configure_target:
	$(RUN) ./bootstrap.sh
	$(RUN) ./configure $(REAL_CONFIGURE_ARGS)

