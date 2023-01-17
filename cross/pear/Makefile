PKG_NAME = pear
PKG_EXT = phar
PKG_DIST_NAME = go-$(PKG_NAME).$(PKG_EXT)
PKG_DIST_SITE = http://pear.php.net

DEPENDS =

HOMEPAGE = http://pear.php.net
COMMENT  = PEAR is a framework and distribution system for reusable PHP components.
LICENSE  =

EXTRACT_TARGET = myExtract
CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = nop

# Pure PHP
ARCH =

include ../../mk/spksrc.cross-cc.mk

.PHONY: myExtract
myExtract:
	@cp $(DIST_FILE) $(WORK_DIR)

.PHONY: myCompile
myCompile:
	WORK_DIR=$(WORK_DIR) PEAR_INSTALL_DIR=$(STAGING_INSTALL_PREFIX) src/install.exp
