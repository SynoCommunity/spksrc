PKG_NAME = mkvtoolnix
PKG_VERS = 22.0.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mkvtoolnix.download/sources
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# compiler too old, gcc >= 4.9.x required.
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

BOOST_LIBRARIES = system filesystem regex date_time
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

NATIVE_RUBY_DIR = $(realpath $(WORK_DIR)/../../../native/ruby/work-native/install/usr/local/bin)
ENV += PATH=$(NATIVE_RUBY_DIR):$$PATH

include ../../mk/spksrc.common.mk
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
# fix compilation with newer compilers
ADDITIONAL_CXXFLAGS = -D_GLIBCXX_USE_C99_MATH=1
# disable warnings (by includes of boost header files)
ADDITIONAL_CXXFLAGS += -Wno-implicit-fallthrough
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: mkvtoolnix_compile
mkvtoolnix_compile:
	$(RUN) rake

.PHONY: mkvtoolnix_install
mkvtoolnix_install:
	$(RUN) rake install
