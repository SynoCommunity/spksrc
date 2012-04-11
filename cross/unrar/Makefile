PKG_NAME = unrar
PKG_VERS = 4.1.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://rarlab.com/rar
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
DEPENDS =

HOMEPAGE = http://rarlab.com/
COMMENT  = Unarchiver for .rar files (non-free version)

POST_EXTRACT_TARGET = myPostExtract
CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

CXXFLAGS = -O3

.PHONY: myPostExtract
myPostExtract:
	mv $(WORK_DIR)/unrar $(WORK_DIR)/$(PKG_DIR)

.PHONY: myConfigure
myConfigure:
	ln -s $(WORK_DIR)/$(PKG_DIR)/makefile.unix $(WORK_DIR)/$(PKG_DIR)/Makefile

.PHONY: myCompile
myCompile:
	$(RUN) CXXFLAGS="$(CFLAGS) $(CXXFLAGS)" $(MAKE) DESTDIR=$(STAGING_INSTALL_PREFIX)

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) DESTDIR=$(STAGING_INSTALL_PREFIX) install

