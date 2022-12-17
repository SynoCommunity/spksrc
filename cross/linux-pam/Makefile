PKG_NAME = Linux-PAM
PKG_VERS = 1.5.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/linux-pam/linux-pam/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/linux-pam/linux-pam
COMMENT = Linux PAM (Pluggable Authentication Modules for Linux) project.
LICENSE = 3-Clause BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-regenerate-docu
CONFIGURE_ARGS += --disable-db
CONFIGURE_ARGS += --disable-nls

POST_INSTALL_TARGET = linux-pam_post_install_target

ADDITIONAL_CPPFLAGS = -O2
# some toolchains are missing the following definitions in
# {sysroot}/usr/include/linux/prctl.h
ADDITIONAL_CPPFLAGS += -DPR_SET_NO_NEW_PRIVS=36 -DPR_GET_NO_NEW_PRIVS=37

include ../../mk/spksrc.cross-cc.mk

.PHONY: linux-pam_post_install_target
# fix installation include folder
linux-pam_post_install_target:
	install -m 755 -d $(INSTALL_DIR)$(INSTALL_PREFIX)/include/security
	mv $(wildcard $(INSTALL_DIR)$(INSTALL_PREFIX)/include/*pam*.h) $(INSTALL_DIR)$(INSTALL_PREFIX)/include/security
