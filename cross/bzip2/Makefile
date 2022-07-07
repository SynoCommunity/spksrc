PKG_NAME = bzip2
PKG_VERS = 1.0.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).orig.$(PKG_EXT)
PKG_DIST_SITE = http://http.debian.net/debian/pool/main/b/bzip2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://bzip.org/
COMMENT  = High-quality data compressor.
LICENSE  = BSD License

CONFIGURE_TARGET = nop
COMPILE_TARGET = bzip2_compile
POST_INSTALL_TARGET = bzip2_post_install

ADDITIONAL_CFLAGS = -fpic -fPIC -O3 -D_FILE_OFFSET_BITS=64

INSTALL_MAKE_OPTIONS = install PREFIX=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

.PHONY: bzip2_compile
bzip2_compile:
	$(RUN) $(MAKE) bzip2 bzip2recover PREFIX=$(INSTALL_PREFIX)
	$(RUN) $(MAKE) -f Makefile-libbz2_so PREFIX=$(INSTALL_PREFIX)

.PHONY: bzip2_post_install
bzip2_post_install:
	ln -sf bzip2 $(STAGING_INSTALL_PREFIX)/bin/bunzip2
	ln -sf bzip2 $(STAGING_INSTALL_PREFIX)/bin/bzcat
	ln -sf bzdiff $(STAGING_INSTALL_PREFIX)/bin/bzcmp
	ln -sf bzgrep $(STAGING_INSTALL_PREFIX)/bin/bzegrep
	ln -sf bzgrep $(STAGING_INSTALL_PREFIX)/bin/bzfgrep
	ln -sf bzmore $(STAGING_INSTALL_PREFIX)/bin/bzless
	@$(RUN) cp libbz2.so.$(PKG_VERS) $(STAGING_INSTALL_PREFIX)/lib/
	ln -sf libbz2.so.$(PKG_VERS) $(STAGING_INSTALL_PREFIX)/lib/libbz2.so.1.0
