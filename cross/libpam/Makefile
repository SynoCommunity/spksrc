PKG_NAME = Linux-PAM
PKG_VERS = 1.5.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/linux-pam/linux-pam/releases/download/v1.5.2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/linux-pam/linux-pam
COMMENT = Linux PAM (Pluggable Authentication Modules for Linux) project
LICENSE = Custom

GNU_CONFIGURE=1
POST_INSTALL_TARGET=google_auth_post_install_target

include ../../mk/spksrc.cross-cc.mk

.PHONY: google_auth_post_install_target
google_auth_post_install_target:
	mkdir -p $(INSTALL_DIR)$(INSTALL_PREFIX)/include/security
	mv $(wildcard $(INSTALL_DIR)$(INSTALL_PREFIX)/include/*pam*.h) $(INSTALL_DIR)$(INSTALL_PREFIX)/include/security

