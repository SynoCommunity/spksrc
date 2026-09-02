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

# The host toolchain by absolute path ($(call native,...), macros.mk). Naming these also
# shadows the cross toolchain's own CC/CXX when a native package is built as a dependency.
NATIVE_CC  := $(or $(NATIVE_CC),$(call native,gcc))
NATIVE_CXX := $(or $(NATIVE_CXX),$(call native,g++))
ENV := $(ENV) CC=$(NATIVE_CC) CXX=$(NATIVE_CXX) CPP="$(NATIVE_CC) -E"
ENV := $(ENV) CC_FOR_BUILD=$(NATIVE_CC) CXX_FOR_BUILD=$(NATIVE_CXX)
ENV := $(ENV) AR=$(call native,ar) AS=$(call native,as) LD=$(call native,ld) \
              NM=$(call native,nm) OBJDUMP=$(call native,objdump) \
              OBJCOPY=$(call native,objcopy) RANLIB=$(call native,ranlib) \
              READELF=$(call native,readelf) STRIP=$(call native,strip)
ENV += CFLAGS="$(NATIVE_CFLAGS)" CPPFLAGS="$(NATIVE_CPPFLAGS)" LDFLAGS="$(NATIVE_LDFLAGS)" CXXFLAGS="$(NATIVE_CXXFLAGS)"
ENV += INSTALL_PREFIX=$(INSTALL_PREFIX)
