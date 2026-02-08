PKG_NAME = google-authenticator-libpam
PKG_VERS = 1.09
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/google/google-authenticator-libpam/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/linux-pam

HOMEPAGE = https://github.com/google/google-authenticator-libpam
COMMENT = PAM module for two-factor authentication logging into servers via SSH, OpenVPN, etc.
LICENSE = Apache-2.0

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = google-authenticator-libpam_pre_configure

ADDITIONAL_CPPFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk

.PHONY: google-authenticator-libpam_pre_configure
google-authenticator-libpam_pre_configure:
	$(RUN) ./bootstrap.sh
