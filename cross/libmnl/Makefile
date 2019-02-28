PKG_NAME = libmnl
PKG_VERS = 1.0.4
PKG_EXT = tar.bz2
PKG_DIST_SITE = https://netfilter.org/projects/$(PKG_NAME)/files
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://netfilter.org/projects/libmnl/
COMMENT  = libmnl is a minimalistic user-space library oriented to Netlink developers. There are a lot of common tasks in parsing, validating, constructing of both the Netlink header and TLVs that are repetitive and easy to get wrong. This library aims to provide simple helpers that allows you to re-use code and to avoid re-inventing the wheel.
LICENSE  = LGPLv2.1+

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-shared --prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(ARM5_ARCHES) $(ARM7_ARCHES)),$(ARCH))
ENV += x264_ARCH=ARM
endif

ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
ENV += x264_ARCH=aarch64
CONFIGURE_ARGS += --host=arm-linux
endif

ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
ENV += x264_ARCH=PPC
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
ENV += x264_ARCH=X86_64
endif

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
ENV += x264_ARCH=X86
endif
