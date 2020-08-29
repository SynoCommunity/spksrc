TC_NAME = syno-$(TC_ARCH)

TC_ARCH = armadaxp
TC_VERS = 6.0.2
TC_FIRMWARE = 6.0.2-8451

TC_DIST = armadaxp-gcc493_glibc220_hard-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.0.2%20Tool%20Chains/Marvell%20Armada%20XP%20Linux%203.2.40

TC_PREFIX = arm-unknown-linux-gnueabi
TC_TARGET = arm-unknown-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mhard-float -mfpu=vfpv3-d16
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mhard-float -mfpu=vfpv3-d16
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mhard-float -mfpu=vfpv3-d16
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/lib -mhard-float -mfpu=vfpv3-d16

TC_SYSROOT = $(TC_PREFIX)/sysroot

include ../../mk/spksrc.tc.mk
