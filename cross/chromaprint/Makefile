PKG_NAME = chromaprint
PKG_VERS = 1.3.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://bitbucket.org/acoustid/chromaprint/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/ffmpeg-2.2.1

HOMEPAGE = http://acoustid.org/chromaprint
COMMENT  = Chromaprint is the core component of the AcoustID project. It's a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
LICENSE  = LGPL2.1+

CONFIGURE_TARGET = chromaprint_custom_configure
COMPILE_TARGET = chromaprint_custom_compile
INSTALL_TARGET = chromaprint_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: chromaprint_custom_configure chromaprint_custom_compile chromaprint_custom_install

chromaprint_custom_configure:
	$(RUN) cmake \
		-DBUILD_EXAMPLES=ON \
		-DBUILD_SHARED_LIBS=OFF \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) \
		-DCMAKE_CROSSCOMPILING=TRUE \
		-DCMAKE_SYSTEM_NAME=Linux \
		-DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc \
		-DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++ \
		-DCMAKE_EXE_LINKER_FLAGS="-L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -Wl,--rpath-link,$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -Wl,--rpath,/usr/local/chromaprint/lib" \
		-DCMAKE_FIND_ROOT_PATH=$(INSTALL_DIR)$(INSTALL_PREFIX) \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY

chromaprint_custom_compile:
	$(RUN) $(MAKE) VERBOSE=1

chromaprint_custom_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
