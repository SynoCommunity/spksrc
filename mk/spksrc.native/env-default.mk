###############################################################################
# spksrc.native/env-default.mk
#
# Base environment for host-native builds (compiler, flags and install paths
# for tools built to run on the build host, not cross-compiled).
###############################################################################

PKG_CONFIG_LIBDIR = $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig

INSTALL_DIR = $(WORK_DIR)/install
ifeq ($(lastword $(subst -, ,$(WORK_DIR))),native)
INSTALL_PREFIX = /usr/local
endif

# Unsetting variables MUST always be first
# as otherwise it fails silently
ENV := -u LDSHARED -u MAKEFLAGS -u PKG_CONFIG -u PKG_CONFIG_LIBDIR -u PKG_CONFIG_PATH $(ENV)

# Positively select the HOST toolchain. This both neutralises any cross toolchain
# CC/CXX/... that leaked in when a native package is built as a cross dependency
# (the previous behaviour, which emptied these) AND gives builds that genuinely
# need a working host compiler one by default -- e.g. a native-toolchain package
# rebuilding gcc, whose genparams helper cannot run with CC="". Override per
# package if a different host compiler is wanted.
NATIVE_CC  ?= gcc
NATIVE_CXX ?= g++
ENV += CC=$(NATIVE_CC) CXX=$(NATIVE_CXX) CPP="$(NATIVE_CC) -E"
ENV += CC_FOR_BUILD=$(NATIVE_CC) CXX_FOR_BUILD=$(NATIVE_CXX)
ENV += AR=ar AS=as LD=ld NM=nm OBJDUMP=objdump OBJCOPY=objcopy RANLIB=ranlib READELF=readelf STRIP=strip
ENV += CFLAGS="$(NATIVE_CFLAGS)" CPPFLAGS="$(NATIVE_CPPFLAGS)" LDFLAGS="$(NATIVE_LDFLAGS)" CXXFLAGS="$(NATIVE_CXXFLAGS)"
ENV += INSTALL_PREFIX=$(INSTALL_PREFIX)
