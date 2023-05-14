PKG_NAME = openssl3
PKG_VERS = 3.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = openssl-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.openssl.org/source
PKG_DIR = openssl-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = https://www.openssl.org
COMMENT  = TLS/SSL and crypto library.
LICENSE  = Apache-2.0

CONFIGURE_TARGET = openssl3_configure
INSTALL_MAKE_OPTIONS = install_sw DESTDIR=$(INSTALL_DIR)

CONFIGURE_ARGS  = --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --openssldir=$(OPENSSL_DATA_DIR)
CONFIGURE_ARGS += zlib-dynamic
CONFIGURE_ARGS += shared
CONFIGURE_ARGS += no-tests
# avoid multilib postfix (like lib64 for 64-bit archs):
CONFIGURE_ARGS += --libdir=lib

include ../../mk/spksrc.cross-cc.mk

# Use CA certificates provided by DSM
# OpenSSL data area, such as openssl.cnf, certificates and keys.
OPENSSL_DATA_DIR=/etc/ssl

# Map ARCH to platform expected by openssl Configure
OPENSSL_PLATFORM =

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
OPENSSL_PLATFORM = linux-x86_64
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
OPENSSL_PLATFORM = linux-x86
endif
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
OPENSSL_PLATFORM = linux-armv4
CONFIGURE_ARGS += -march=armv5
# threads need libatomic that is missing in ARMv5 toolchain
CONFIGURE_ARGS += no-threads
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
OPENSSL_PLATFORM = linux-armv4
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
OPENSSL_PLATFORM = linux-aarch64
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# asm of gcc for DSM<7 does not support ".arch	armv8.2-a+crypto"
CONFIGURE_ARGS += no-asm
endif
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
OPENSSL_PLATFORM = linux-ppc
CONFIGURE_ARGS += no-asm
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# threads need libatomic that is missing in OLD_PPC_ARCHS toolchains
CONFIGURE_ARGS += no-threads
endif
endif

ifeq ($(strip $(OPENSSL_PLATFORM)),)
# Unexpected CPU architecture. Please add arch to mk/spksrc.archs.mk
$(error Arch $(ARCH) not expected yet)
endif

.PHONY: openssl3_configure
openssl3_configure:
	$(RUN) ./Configure $(OPENSSL_PLATFORM) $(CONFIGURE_ARGS)
