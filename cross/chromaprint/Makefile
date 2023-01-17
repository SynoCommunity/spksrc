PKG_NAME = chromaprint
PKG_VERS = 1.4.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/acoustid/chromaprint/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

HOMEPAGE = http://acoustid.org/chromaprint
COMMENT  = Chromaprint is the core component of the AcoustID project. It's a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
LICENSE  = LGPL2.1+

ifneq ($(wildcard $(FFMPEG_DIR)),)
$(info Reuse ffmpeg package libraries)
CMAKE_FFMPEG_ROOT = "-DFFMPEG_ROOT=$(FFMPEG_DIR)"
CMAKE_RPATH = ${INSTALL_PREFIX}/lib:/var/packages/ffmpeg/target/lib
else
$(warning WARNING Build spk/ffmpeg first to depend on its libraries $(FFMPEG_DIR))
DEPENDS = cross/ffmpeg
CMAKE_FFMPEG_ROOT =
CMAKE_RPATH = ${INSTALL_PREFIX}/lib
endif

CONFIGURE_TARGET = chromaprint_custom_configure
COMPILE_TARGET = chromaprint_custom_compile
INSTALL_TARGET = chromaprint_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: chromaprint_custom_configure chromaprint_custom_compile chromaprint_custom_install

chromaprint_custom_configure:
	$(RUN) cmake $(CMAKE_FFMPEG_ROOT) \
		-DBUILD_TOOLS=ON \
		-DBUILD_SHARED_LIBS=OFF \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) \
		-DCMAKE_CROSSCOMPILING=TRUE \
		-DCMAKE_SYSTEM_NAME=Linux \
		-DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc \
		-DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++ \
		-DCMAKE_INSTALL_RPATH=$(CMAKE_RPATH) \
		-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY


chromaprint_custom_compile:
	$(RUN) $(MAKE) VERBOSE=1

chromaprint_custom_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
