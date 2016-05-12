PKG_NAME = libvpx
PKG_VERS = 1.5.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/webmproject/libvpx/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.webmproject.org/code/
COMMENT  =

CONFIGURE_ARGS = --disable-sse --disable-sse2 --disable-sse3 --disable-ssse3 --disable-sse4_1 --enable-shared
CONFIGURE_ARGS += --enable-vp8 --enable-vp9 --disable-examples --disable-docs --disable-unit_tests
CONFIGURE_ARGS += --enable-postproc --enable-vp9-postproc --enable-pic  --prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

ENV = LD= CPP= NM= CC= RANLIB= CXX= AR= STRIP= OBJDUM= CFLAGS="$(CFLAGS)" CPPFLAGS= LDFLAGS="$(LDFLAGS)" CXXFLAGS= READELF= AS= OBJDUMP= DESTDIR=$(INSTALL_DIR) CROSS=$(TC_PATH)$(TC_PREFIX)

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --target=armv5te-linux-gcc
endif

ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --target=armv7-linux-gcc
endif

ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
CONFIGURE_ARGS += --target=x86-linux-gcc
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
CONFIGURE_ARGS += --target=x86_64-linux-gcc
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
CONFIGURE_ARGS += --target=ppc32-linux-gcc --as=yasm
endif
