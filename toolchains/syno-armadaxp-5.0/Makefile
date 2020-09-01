TC_NAME = syno-$(TC_ARCH)

TC_ARCH = armadaxp
TC_VERS = 5.0

TC_DIST = gcc464_glibc215_hard_armada-GPL
TC_EXT = tgz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%205.0%20Tool%20Chains/Marvell%20armada%20xp%20Linux%203.2.40
TC_DIST_FILE = $(TC_ARCH)-$(TC_DIST_NAME)

TC_PREFIX = arm-marvell-linux-gnueabi
TC_SYSROOT = $(TC_PREFIX)/libc
TC_LIBRARY = $(TC_SYSROOT)/usr/lib
TC_EXTRA_CFLAGS = -mhard-float -mfpu=vfpv3-d16

include ../../mk/spksrc.tc.mk
