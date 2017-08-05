PKG_NAME = openssl
PKG_VERS = 1.1.0f
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.openssl.org/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://www.openssl.org
COMMENT  = Compression Library
LICENSE  = http://www.openssl.org/source/license.html

CONFIGURE_TARGET = myConfigure

INSTALL_TARGET = myInstall

STAGING_INSTALL_PREFIX := $(INSTALL_DIR)

include ../../mk/spksrc.cross-cc.mk

OPENSSL_ARCH = linux-generic32
ifneq ($(findstring $(ARCH), braswell bromolow cedarview x86 avoton x64),)
OPENSSL_ARCH = linux-x86_64
endif
ifneq ($(findstring $(ARCH), 88f6281),)
OPENSSL_ARCH = linux-armv4
endif
ifneq ($(findstring $(ARCH), powerpc),)
OPENSSL_ARCH = linux-ppc32
endif

.PHONY: myConfigure
myConfigure:
	$(RUN) ./Configure --prefix=$(INSTALL_PREFIX) --openssldir=$(INSTALL_PREFIX)/ssl $(OPENSSL_ARCH) zlib-dynamic shared threads --with-zlib-include=$(INSTALL_DIR)$(INSTALL_PREFIX)/include -Wl,-rpath=$(INSTALL_PREFIX)/lib

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install_sw DESTDIR=$(INSTALL_DIR)
