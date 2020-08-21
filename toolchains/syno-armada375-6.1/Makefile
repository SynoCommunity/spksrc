TC_NAME = syno-$(TC_ARCH)

TC_ARCH = armada375
TC_VERS = 6.1
TC_OS_MIN_VER = 6.1-15047
TC_KERNEL = 3.2.40+

TC_DIST = armada375-gcc493_glibc220_hard-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.1%20Tool%20Chains/Marvell%20Armada%20375%20Linux%203.2.40

TC_BASE_DIR = arm-unknown-linux-gnueabi
TC_PREFIX = arm-unknown-linux-gnueabi
TC_TARGET = arm-unknown-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/usr/include -mhard-float
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/usr/include -mhard-float -mfpu=vfpv3
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/usr/include -mhard-float -mfpu=vfpv3
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/lib -mhard-float -mfpu=vfpv3

TC_SYSROOT = $(TC_BASE_DIR)/sysroot

include ../../mk/spksrc.tc.mk
