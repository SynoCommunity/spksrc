PKG_NAME = node
PKG_VERS = 16.17.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://nodejs.org/dist/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

# C++ compiler (CXX=/spksrc/toolchain/syno-x64-7.0/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-g++, 7.3.0) too old, need g++ 8.3.0 or clang++ 8.0.0
# DSM 7 toolchains have g++ 7.3.0 only, but succeed to compile nodejs v16.
# newest DSM 6 toolchains have g++ <= 4.9.3.
REQUIRED_MIN_DSM = 7.0
# comcerto2k is supported by DSM 7, but toolchain has g++ 4.9.3 that is too old.
UNSUPPORTED_ARCHS = comcerto2k

HOMEPAGE = https://www.nodejs.org
COMMENT  = A JavaScript runtime built on Chrome\'s V8 JavaScript engine.
LICENSE  = https://github.com/nodejs/node/raw/master/LICENSE

CONFIGURE_ARGS = --cross-compiling --dest-os=linux --prefix=$(INSTALL_PREFIX)

# fix compilation with newer compilers
ADDITIONAL_CPPFLAGS = -D_GLIBCXX_USE_C99_MATH -D_GLIBCXX_HAVE_OBSOLETE_ISNAN -D_GLIBCXX_HAVE_OBSOLETE_ISINF

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
ENV += CC_host="gcc -m64"
ENV += CXX_host="g++ -m64"
else
ENV += CC_host="gcc -m32"
ENV += CXX_host="g++ -m32"
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --dest-cpu=arm
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --dest-cpu=arm64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --dest-cpu=x86
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --dest-cpu=x86_64
endif
