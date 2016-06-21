PKG_NAME = imapfilter
PKG_VERS = 2.6.7
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lefcha/$(PKG_NAME)/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/pcre cross/lua

HOMEPAGE = http://github.com/lefcha/imapfilter
COMMENT  = IMAPFilter is a mail filtering utility. It connects to remote mail servers using the Internet Message Access Protocol (IMAP), sends searching queries to the server and processes mailboxes based on the results
LICENSE  = MIT/X11

ADDITIONAL_LDFLAGS = -L$(STAGING_INSTALL_PREFIX)/lib64 -Wl,--rpath-link,$(STAGING_INSTALL_PREFIX)/lib64 -Wl,--rpath,$(INSTALL_PREFIX)/lib64
CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myConfigure:
myCompile:
	$(RUN) $(MAKE) MYCFLAGS="$(CFLAGS)" MYLDFLAGS="$(LDFLAGS)"
myInstall:
	$(RUN) $(MAKE) install PREFIX=$(STAGING_INSTALL_PREFIX)
