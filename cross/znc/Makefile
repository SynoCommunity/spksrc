PKG_NAME = znc
PKG_VERS = 1.0-rc1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://znc.in/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/c-ares

HOMEPAGE = http://wiki.znc.in/
COMMENT  = Advanced IRC bouncer
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-extra
ifneq ($(findstring $(ARCH), powerpc ppc824x ppc853x ppc854x),)
CONFIGURE_ARGS += gl_cv_cc_visibility=no
endif
ifneq ($(wildcard modules/*),)
POST_INSTALL_TARGET = myPostInstall
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostInstall
myPostInstall:
	@$(MSG) "Building extra modules"
	@chmod +x $(WORK_DIR)/$(PKG_DIR)/znc-buildmod $(WORK_DIR)/$(PKG_DIR)/znc-config
	@rm -fr $(WORK_DIR)/modules
	@cp -R modules $(WORK_DIR)/
	@PATH=$(WORK_DIR)/$(PKG_DIR) INCLUDES=-I$(STAGING_INSTALL_PREFIX)/include/znc prefix=$(STAGING_INSTALL_PREFIX) znc-buildmod $(WORK_DIR)/modules/*.cpp
	@install -m 644 $(WORK_DIR)/modules/*.so $(STAGING_INSTALL_PREFIX)/lib/znc/
