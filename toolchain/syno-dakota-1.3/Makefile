TC_ARCH = dakota
TC_VERS = 1.3
TC_TYPE = SRM
TC_KERNEL = 4.4.60
TC_GLIBC = 2.32

TC_DIST = dakota-gcc1030_glibc232_srm-1.3
TC_EXT = tar.xz
TC_DIST_SITE_URL = https://github.com/SynoCommunity/spksrc/releases/download/
TC_DIST_SITE_PATH = toolchains%2Fsrm1.3

TC_TARGET = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -mhard-float -mfpu=vfpv3-d16 -march=armv7-a

include ../../mk/spksrc.tc.mk
