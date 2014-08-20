PKG_NAME = perl
PKG_VERS = 5.20.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.cpan.org/src/5.0/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/openssl cross/readline native/$(PKG_NAME)

HOMEPAGE = http://www.perl.org/
COMMENT  = Perl Programming Language
LICENSE  =

PRE_CONFIGURE_TARGET = linkConfigure

# Configure
#GNU_CONFIGURE = 1
CONFIGURE_ARGS = -des

include ../../mk/spksrc.cross-cc.mk

.PHONY: linkConfigure
linkConfigure:
	ln -sf $(WORK_DIR)/$(PKG_DIR)/Configure $(WORK_DIR)/$(PKG_DIR)/configure

