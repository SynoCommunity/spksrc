PKG_NAME = libcap
PKG_VERS = 2.22
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.sunet.se/pub/Linux/kernel.org/linux/libs/security/linux-privs/libcap2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/attr

HOMEPAGE = http://kernel.org/
COMMENT  = 
LICENSE  = 

CONFIGURE_TARGET = nope
INSTALL_TARGET = myInstall
ADDITIONAL_CFLAGS = "-I$(WORK_DIR)/$(PKG_DIR)/libcap/include"
ADDITIONAL_LDFLAGS = "-L$(WORK_DIR)/$(PKG_DIR)/libcap"
ENV += BUILD_CFLAGS="\$$(CFLAGS)" BUILD_CC="cc"


include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)
