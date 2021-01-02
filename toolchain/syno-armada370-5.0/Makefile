TC_ARCH = armada370
TC_VERS = 5.0
TC_KERNEL = 3.2.40
TC_GCC = 4.6.4
TC_GLIBC = 2.15

TC_DIST = gcc464_glibc215_hard_armada-GPL
TC_EXT = tgz
TC_DIST_SITE_PATH = Marvell%20armada%20370%20Linux%203.2.40

TC_TARGET = arm-marvell-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/libc
TC_LIBRARY = $(TC_SYSROOT)/usr/lib
TC_EXTRA_CFLAGS = -mhard-float -mfpu=vfpv3-d16

include ../../mk/spksrc.tc.mk
