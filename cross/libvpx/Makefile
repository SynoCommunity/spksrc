PKG_NAME = libvpx
PKG_VERS = 1.14.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/webmproject/libvpx/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.webmproject.org/code/
COMMENT  = WebM VP8/VP9 Codec.
LICENSE = 3-Clause BSD

# configure does not work with GNU_CONFIGURE = 1 (Unknown option "--host=x86_64-pc-linux-gnu")
# we have to configure with targets known by this library
CONFIGURE_ARGS = --prefix=$(INSTALL_PREFIX)

CONFIGURE_ARGS += --disable-static --enable-shared
CONFIGURE_ARGS += --enable-pic
CONFIGURE_ARGS += --enable-vp8 --enable-vp9
CONFIGURE_ARGS += --enable-postproc --enable-vp9-postproc
CONFIGURE_ARGS += --enable-vp9-highbitdepth --enable-better-hw-compatibility
CONFIGURE_ARGS += --enable-webm-io
CONFIGURE_ARGS += --disable-multithread
CONFIGURE_ARGS += --disable-examples --disable-docs --disable-unit_tests

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=generic-gnu
ADDITIONAL_CXXFLAGS = -std=c++0x
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=armv7-linux-gcc
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=generic-gnu
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=armv8-linux-gcc
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=x86-linux-gcc
# --as=auto: prefers yasm over nasm
CONFIGURE_ARGS += --as=auto
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --target=x86_64-linux-gcc
# --as=auto: prefers yasm over nasm
CONFIGURE_ARGS += --as=auto
endif

include ../../mk/spksrc.cross-cc.mk

# Disable NEON on armv7/armv7l/armv8 when using gcc-4.9 or lower
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(ARMv8_ARCHS)),$(ARCH))
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
CONFIGURE_ARGS += --disable-neon
endif
endif
