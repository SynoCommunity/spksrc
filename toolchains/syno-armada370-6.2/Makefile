TC_ARCH = armada370
TC_VERS = 6.2
TC_KERNEL = 3.2.40+

TC_DIST = armada370-gcc493_glibc220_hard-GPL
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.2%20Tool%20Chains/Marvell%20Armada%20370%20Linux%203.2.40

TC_PREFIX = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_PREFIX)/sysroot
TC_EXTRA_CFLAGS = -mhard-float -mfpu=vfpv3-d16

include ../../mk/spksrc.tc.mk
