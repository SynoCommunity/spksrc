TC_NAME = syno-aarch64

TC_ARCH = cypress
TC_VERS = 1.3
TC_TYPE = SRM
# TODO: validate kernel version
TC_KERNEL = 4.4.60
TC_GLIBC = 2.32

TC_DIST = cypress-gcc1030_glibc232_srm-1.3
TC_EXT = tar.xz
TC_DIST_SITE_URL = https://github.com/SynoCommunity/spksrc/releases/download/
TC_DIST_SITE_PATH = toolchains%2Fsrm1.3

TC_TARGET = aarch64-unknown-linux-gnu
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -march=armv8-a -mcpu=cortex-a53+crypto

include ../../mk/spksrc.tc.mk
