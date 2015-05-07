PKG_NAME = openssl
PKG_VERS = 1.0.2a
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.openssl.org/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.openssl.org/
COMMENT  = Compression Library
LICENSE  = zlib-license

CONFIGURE_TARGET = myConfigure

INSTALL_TARGET = myInstall

STAGING_INSTALL_PREFIX := $(INSTALL_DIR)

include ../../mk/spksrc.cross-cc.mk

OPENSSL_ARCH = linux-generic32
ifneq ($(findstring $(ARCH), bromolow cedarview x86 avoton x64),)
OPENSSL_ARCH = linux-x86_64
endif
ifneq ($(findstring $(ARCH), 88f6281),)
OPENSSL_ARCH = synology-armle
endif
ifneq ($(findstring $(ARCH), powerpc),)
OPENSSL_ARCH = synology-ppc
endif
ifneq ($(findstring $(ARCH), x64),)
EC_NIST=enable-ec_nistp_64_gcc_128
endif
ifneq (5.0,$(firstword $(sort $(TCVERSION) 5.0)))
PATCHES = $(sort $(wildcard patches/00*.patch))
endif

.PHONY: myConfigure
myConfigure:
	$(RUN) ./Configure --openssldir=$(INSTALL_PREFIX) $(OPENSSL_ARCH) shared threads no-ssl2 $(EC_NIST)

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install_sw INSTALL_PREFIX=$(INSTALL_DIR)
