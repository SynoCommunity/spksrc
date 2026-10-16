PKG_NAME = libusb
PKG_VERS = 1.0.30
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libusb/libusb/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Needs gcc >= 4.9: libusb requires C11 from 1.0.24 on, and configure says so itself
# ("compiler with C11 support is required to build libusb"). Measured on the extracted
# toolchains, the boundary is exactly there -- 4.9.3 passes, hi3535 4.8.3, x86/x64-5.2
# 4.7.3, 88f6281 4.6.4 and ppc853x 4.3.7 are refused. The framework passes no -std, so
# what answers is gcc's own default dialect, gnu11 from 4.9 on.
MIN_GCC_VERSION = 4.9

# Needs kernel headers >= 3.2: with --disable-udev below, hotplug goes through netlink and
# configure requires <linux/netlink.h> to compile on its own. In the 2.6.32 sysroots it
# does not -- it names sa_family_t without pulling the header that defines it, so the test
# reports the header missing ("Linux netlink header not found"). Measured by compiling it
# standalone with each toolchain: 2.6.32 fails, 3.2.40 and every later one passes.
#
# This is why the floor is stated on the kernel and not on the arch. qoriq carries the
# same gcc 4.9.3 that x64-6.2.4 builds this with, so no compiler floor can express it, and
# a PPC arch list would stop discriminating the moment an overlay lifts the compiler.
MIN_KERNEL_VERSION = 3.2

HOMEPAGE = https://libusb.info/
COMMENT  = C library that provides generic access to USB devices. It is intended to be used by developers to facilitate the production of applications that communicate with USB hardware.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1

# --disable-udev leaves hotplug to netlink, which is what every consumer has always
# built. The two LIBUSB_* switches that used to wrap these had no setter anywhere in the
# tree, so they only offered a way to get it wrong.
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-udev

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
