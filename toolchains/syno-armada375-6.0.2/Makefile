TC_NAME = syno-$(TC_ARCH)

TC_ARCH = armada375
TC_VERS = 6.0.2

TC_DIST = armada375-gcc493_glibc220_hard-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.0.2%20Tool%20Chains/Marvell%20Armada%20375%20Linux%203.2.40

TC_PREFIX = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_PREFIX)/sysroot
TC_CFLAGS = -mhard-float -mfpu=vfpv3

include ../../mk/spksrc.tc.mk
