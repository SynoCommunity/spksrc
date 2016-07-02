PKG_NAME = gitflow
PKG_EXT = sh
PKG_DIST_NAME = $(PKG_NAME)-installer.$(PKG_EXT)
PKG_DIST_SITE = https://raw.github.com/nvie/gitflow/develop/contrib
PKG_DIR =

DEPENDS = # cross/git

HOMEPAGE = https://github.com/nvie/gitflow
COMMENT  = A collection of Git extensions to provide high-level repository operations for Vincent Driessen's branching model (http://nvie.com/git-model)
LICENSE  = BSD

EXTRACT_TARGET = nop
CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myExtract:
	mkdir -p $(WORK_DIR)/
myConfigure:
	chmod +x $(DIST_FILE)
myInstall:
	$(RUN) INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX)/bin $(DIST_FILE) install
