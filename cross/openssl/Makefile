PKG_NAME = openssl
VERSION = 1.1.1
PATCH_VERS = h
PKG_VERS = $(VERSION)$(PATCH_VERS)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.openssl.org/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://www.openssl.org
COMMENT  = TLS/SSL and crypto library.
LICENSE  = Apache-2.0

CONFIGURE_TARGET = openssl_configure
INSTALL_TARGET = openssl_install

include ../../mk/spksrc.cross-cc.mk

# Use CA certificates provided by DSM
# OpenSSL data area, such as openssl.cnf, certificates and keys.
OPENSSL_DATA_DIR=/etc/ssl

# Map ARCH to arch expected by openssl Configure
OPENSSL_ARCH =

ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
OPENSSL_ARCH = linux-x86_64
endif
ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
OPENSSL_ARCH = linux-x86
endif
ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
OPENSSL_ARCH = linux-armv4 -march=armv5
endif
ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
OPENSSL_ARCH = linux-armv4
endif
ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
OPENSSL_ARCH = linux-aarch64
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
OPENSSL_ARCH = linux-ppc
endif

ifeq ($(strip $(OPENSSL_ARCH)),)
# Unexpected CPU architecture. Please add arch to mk/spksrc.common.mk
$(error Arch $(ARCH) not expected yet)
endif

.PHONY: openssl_configure
openssl_configure:
	$(RUN) ./Configure --openssldir=$(OPENSSL_DATA_DIR) --prefix=$(INSTALL_PREFIX) $(OPENSSL_ARCH) zlib-dynamic shared threads

.PHONY: openssl_install
openssl_install:
	$(RUN) $(MAKE) install_sw DESTDIR=$(INSTALL_DIR)
