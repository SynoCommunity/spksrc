PKG_NAME = xvidcore
PKG_VERS = 1.3.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.xvid.org/downloads/
PKG_DIR = $(PKG_NAME)

DEPENDS = 

HOMEPAGE = http://www.xvid.com
COMMENT  = Xvid library
LICENSE  =
CONFIGURE_TARGET = MyConfigure

COMPILE_TARGET = MyCompile
INSTALL_TARGET = MyInstall

REQUIRED_DSM = 5.1

CONFIGURE_ARGS = --prefix=$(INSTALL_PREFIX) 

include ../../mk/spksrc.cross-cc.mk

.PHONY: Myconfigure
MyConfigure:
	$(RUN) $(WORK_DIR)/$(PKG_DIR)/build/generic/configure --prefix=$(INSTALL_PREFIX)

.PHONY: MyCompile
MyCompile:
	$(RUN) $(MAKE) -C $(WORK_DIR)/$(PKG_DIR)/build/generic/

.PHONY: MyInstall
MyInstall:
	$(RUN) $(MAKE) -C $(WORK_DIR)/$(PKG_DIR)/build/generic/ install prefix=$(STAGING_INSTALL_PREFIX)

