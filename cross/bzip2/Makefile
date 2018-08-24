PKG_NAME = bzip2
PKG_VERS = 1.0.6
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).orig.$(PKG_EXT)
PKG_DIST_SITE = http://http.debian.net/debian/pool/main/b/bzip2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://bzip.org/
COMMENT  = High-quality data compressor
LICENSE  = BSD License

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

ADDITIONAL_CFLAGS = -fpic -fPIC -O3 -D_FILE_OFFSET_BITS=64

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) bzip2 bzip2recover PREFIX=$(STAGING_INSTALL_PREFIX)
	$(RUN) $(MAKE) -f Makefile-libbz2_so PREFIX=$(STAGING_INSTALL_PREFIX)

.PHONY: myInstall
myInstall:
	@$(RUN) $(MAKE) PREFIX=$(STAGING_INSTALL_PREFIX) install
	ln -sf bzip2 $(STAGING_INSTALL_PREFIX)/bin/bunzip2
	ln -sf bzip2 $(STAGING_INSTALL_PREFIX)/bin/bzcat
	ln -sf bzdiff $(STAGING_INSTALL_PREFIX)/bin/bzcmp
	ln -sf bzgrep $(STAGING_INSTALL_PREFIX)/bin/bzegrep
	ln -sf bzgrep $(STAGING_INSTALL_PREFIX)/bin/bzfgrep
	ln -sf bzmore $(STAGING_INSTALL_PREFIX)/bin/bzless
	@$(RUN) cp libbz2.so.1.0.6 $(STAGING_INSTALL_PREFIX)/lib/
	ln -sf libbz2.so.1.0.6 $(STAGING_INSTALL_PREFIX)/lib/libbz2.so.1.0
