PKG_NAME = pear
PKG_EXT = phar
PKG_DIST_NAME = go-$(PKG_NAME).$(PKG_EXT)
PKG_DIST_SITE = https://pear.php.net

DEPENDS =

HOMEPAGE = https://pear.php.net
COMMENT  = PEAR is a framework and distribution system for reusable PHP components.
LICENSE  =

EXTRACT_TARGET = pear_extract
CONFIGURE_TARGET = nop
COMPILE_TARGET = pear_compile
INSTALL_TARGET = nop

# Pure PHP
ARCH =

include ../../mk/spksrc.cross-cc.mk

.PHONY: pear_extract
pear_extract:
	@cp $(DIST_FILE) $(WORK_DIR)

.PHONY: pear_compile
pear_compile:
	WORK_DIR=$(WORK_DIR) PEAR_INSTALL_DIR=$(STAGING_INSTALL_PREFIX) src/install.exp
