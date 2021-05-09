PKG_NAME = mkvtoolnix
PKG_VERS = 8.5.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mkvtoolnix.download/sources
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/python 
DEPENDS  = cross/libogg cross/libvorbis cross/zlib cross/curl cross/flac cross/boost cross/libmatroska

HOMEPAGE = https://mkvtoolnix.download/index.html
COMMENT  = MKVToolNix is a set of tools to create, alter and inspect Matroska files under Linux, other Unices and Windows.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

COMPILE_TARGET=myCompile
INSTALL_TARGET=myInstall

include ../../mk/spksrc.cross-cc.mk

CONFIGURE_ARGS = --with-boost-libdir=$(STAGING_INSTALL_PREFIX)/lib --prefix=$(STAGING_INSTALL_PREFIX)


.PHONY: myCompile
myCompile:
	$(RUN) ./drake

.PHONY: myInstall
myInstall:
	$(RUN) ./drake install
