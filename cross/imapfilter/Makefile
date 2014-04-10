PKG_NAME = imapfilter
PKG_VERS = 2.5.6
PKG_EXT = zip
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lefcha/imapfilter/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/pcre cross/lua cross/openssl 

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

HOMEPAGE = https://github.com/lefcha/imapfilter/
COMMENT  = IMAPFilter is a mail filtering utility.
LICENSE  = MIT


include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	@$(RUN) $(MAKE) LIBDIRS=$(LDFLAGS) SHAREDIR=$(INSTALL_PREFIX)/share/

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install PREFIX=$(INSTALL_DIR)/$(INSTALL_PREFIX)/ SHAREDIR=$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/
