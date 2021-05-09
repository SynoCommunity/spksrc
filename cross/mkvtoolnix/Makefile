PKG_NAME = mkvtoolnix
PKG_VERS = 9.7.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mkvtoolnix.download/sources
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# compiler too old (C++14 required, gnu c++ >= v4.9.x.)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

BUILD_DEPENDS = native/ruby
DEPENDS = cross/boost cross/libogg cross/libvorbis cross/zlib 
DEPENDS += cross/flac cross/file
DEPENDS += cross/libebml cross/libmatroska

HOMEPAGE = https://mkvtoolnix.download/index.html
COMMENT  = MKVToolNix is a set of tools to create, alter and inspect Matroska files.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
COMPILE_TARGET = mkvtoolnix_compile
INSTALL_TARGET = mkvtoolnix_install

CONFIGURE_ARGS = --prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-boost-libdir=$(STAGING_INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --without-curl

BOOST_LIBRARIES = system filesystem regex date_time
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

NATIVE_RUBY_DIR = $(realpath $(WORK_DIR)/../../../native/ruby/work-native/install/usr/local/bin)
ENV += PATH=$(NATIVE_RUBY_DIR):$$PATH

include ../../mk/spksrc.common.mk
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
# fix compilation with newer compilers
ADDITIONAL_CPPFLAGS = -D_GLIBCXX_USE_C99_MATH=1
ADDITIONAL_CXXFLAGS = -D_GLIBCXX_USE_C99_MATH=1
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: mkvtoolnix_compile
mkvtoolnix_compile:
	$(RUN) ./drake

.PHONY: mkvtoolnix_install
mkvtoolnix_install:
	$(RUN) ./drake install
