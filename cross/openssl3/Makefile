PKG_NAME = openssl3
PKG_VERS = 3.0.7
PKG_EXT = tar.gz
PKG_DIST_NAME = openssl-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.openssl.org/source
PKG_DIR = openssl-$(PKG_VERS)

DEPENDS = cross/zlib

# atomic operations are not supported on ARMv5 and PPC archs except qoriq.
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://www.openssl.org
COMMENT  = TLS/SSL and crypto library.
LICENSE  = Apache-2.0

CONFIGURE_TARGET = openssl3_configure
INSTALL_TARGET = openssl3_install

include ../../mk/spksrc.cross-cc.mk

# Use CA certificates provided by DSM
# OpenSSL data area, such as openssl.cnf, certificates and keys.
OPENSSL_DATA_DIR=/etc/ssl

# Map ARCH to arch expected by openssl Configure
OPENSSL_ARCH =

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
OPENSSL_ARCH = linux-x86_64
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
OPENSSL_ARCH = linux-x86
endif
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
OPENSSL_ARCH = linux-armv4 -march=armv5
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
OPENSSL_ARCH = linux-armv4
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
OPENSSL_ARCH = linux-aarch64
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
OPENSSL_ARCH = linux-ppc
endif

ifeq ($(strip $(OPENSSL_ARCH)),)
# Unexpected CPU architecture. Please add arch to mk/spksrc.archs.mk
$(error Arch $(ARCH) not expected yet)
endif

.PHONY: openssl3_configure
openssl3_configure:
	$(RUN) ./Configure --openssldir=$(OPENSSL_DATA_DIR) --prefix=$(INSTALL_PREFIX) --libdir=lib $(OPENSSL_ARCH) zlib-dynamic shared threads

.PHONY: openssl3_install
openssl3_install:
	$(RUN) $(MAKE) install_sw DESTDIR=$(INSTALL_DIR)
