PKG_NAME = i2pd
PKG_VERS = 2.18.0
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/PurpleI2P/i2pd/archive
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/boost cross/zlib

HOMEPAGE = https://geti2p.net/en/
COMMENT  = The I2P network provides strong privacy protections for communication over the Internet. Many activities that would risk your privacy on the public Internet can be conducted anonymously inside I2P.
LICENSE  = BSD 3 Clause

CONFIGURE_TARGET = i2pd-Configure

include ../../mk/spksrc.cross-cc.mk

BOOST_CMD=echo $(WORK_DIR)/boost_*
BOOST_DIR=$(shell $(BOOST_CMD))

.PHONY: i2pd-Configure
i2pd-Configure:
	$(RUN) CXXFLAGS=-O2 cmake -DZLIB_LIBRARY=$(WORK_DIR)/install/usr/local/i2pd/lib/libz.a \
		-DCMAKE_PREFIX_PATH=$(WORK_DIR)/install/usr/local/i2pd/lib/pkgconfig \
		-DBOOST_ROOT=$(BOOST_DIR) \
		-DWITH_HARDENING=ON \
		-DWITH_STATIC=ON \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX) \
		build
