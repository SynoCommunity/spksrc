PKG_NAME = strace
PKG_VERS = 6.9
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/strace/strace/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://strace.io/
COMMENT  = strace is a diagnostic, debugging and instructional userspace utility for Linux.
LICENSE  = GPLv2+

GNU_CONFIGURE = 1

# strace uses its own ARCH definition
# ARCH is `x86_64', `i386', `aarch64', `powerpc64le', etc.
include ../../mk/spksrc.archs.mk

STRACE_ARCH =
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
STRACE_ARCH = x86_64
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
STRACE_ARCH = i386
endif
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
STRACE_ARCH = arm
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
STRACE_ARCH = arm
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
STRACE_ARCH = aarch64
CONFIGURE_ARGS = --disable-mpers
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
STRACE_ARCH = powerpc
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
ADDITIONAL_CFLAGS = -DDISABLE_KERNEL_V4L2_HAVE_TIME32
endif
endif

ifeq ($(strip $(STRACE_ARCH)),)
# Unexpected CPU architecture.
$(error Arch $(ARCH) not expected)
endif

CONFIGURE_ARGS += ARCH=$(STRACE_ARCH)
COMPILE_MAKE_OPTIONS = ARCH=$(STRACE_ARCH)
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX) ARCH=$(STRACE_ARCH)

include ../../mk/spksrc.cross-cc.mk
