PKG_NAME = nettle
PKG_VERS = 3.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gmp

HOMEPAGE = http://www.lysator.liu.se/~nisse/nettle/
COMMENT  = Nettle is a cryptographic library that is designed to fit easily in more or less any context
LICENSE  = GPLv2

include ../../mk/spksrc.cross-cc.mk

GNU_CONFIGURE = 1
ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=arm-unknown-linux-gnueabi --host=arm-unknown-linux-gnueabi --disable-assembler
endif
ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=arm-unknown-linux-gnueabi --host=arm-unknown-linux-gnueabi
endif
ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=aarch64-unknown-linux-gnu --host=aarch64-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=powerpc-unknown-linux-gnu --host=powerpc-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=i686-pc-linux-gnu --host=i686-pc-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=x86_64-pc-linux-gnu --host=x86_64-pc-linux-gnu
endif
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX) --enable-shared

# Fix for evansport builds to find gmp libraries
CONFIGURE_ARGS += --with-include-path=$(STAGING_INSTALL_PREFIX)/include --with-lib-path=$(STAGING_INSTALL_PREFIX)/lib
