TC_ARCH = armadaxp
TC_VERS = 4.3
TC_FIRMWARE = 3.1-1594

TC_DIST = gcc464_glibc215_hard_armada-GPL
TC_EXT = tgz
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%204.3%20Tool%20Chains/Marvell%20armada%20370%20Linux%203.2.40

TC_TARGET = arm-marvell-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/libc
TC_LIBRARY = $(TC_SYSROOT)/usr/lib
TC_EXTRA_CFLAGS = -mhard-float -mfpu=vfpv3-d16

include ../../mk/spksrc.tc.mk
