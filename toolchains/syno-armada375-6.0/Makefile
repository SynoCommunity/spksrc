TC_NAME = syno-$(TC_ARCH)

TC_ARCH = armada375
TC_VERS = 6.0
TC_FIRMWARE = 5.1-5004

TC_DIST_NAME = armada375-gcc493_glibc220_hard-GPL.txz

TC_EXT = txz
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/DSM%206.0%20Tool%20Chains/Marvell%20Armada%20375%20Linux%203.2.40

TC_BASE_DIR = arm-marvell-linux-gnueabi
TC_PREFIX = arm-marvell-linux-gnueabi
TC_TARGET = arm-marvell-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/usr/include -mhard-float
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/usr/include -mhard-float -mfpu=vfpv3
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/usr/include -mhard-float -mfpu=vfpv3
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/usr/lib -mhard-float -mfpu=vfpv3

include ../../mk/spksrc.tc.mk
