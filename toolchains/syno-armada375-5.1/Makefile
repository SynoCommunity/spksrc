TC_NAME = syno-$(TC_ARCH)

TC_ARCH = armada375
TC_VERS = 5.1
TC_FIRMWARE = 5.1-5004

TC_DIST_NAME = gcc464_glibc215_hard_armada375-GPL.tgz

TC_EXT = tgz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%205.1%20Tool%20Chains/Marvell%20Armada%20375%20Linux%203.2.40

TC_BASE_DIR = armv7-marvell-linux-gnueabi-hard
TC_PREFIX = arm-marvell-linux-gnueabi
TC_TARGET = arm-marvell-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_PREFIX)/libc/usr/include -mhard-float
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_PREFIX)/libc/usr/include -mhard-float -mfpu=vfpv3
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_PREFIX)/libc/usr/include -mhard-float -mfpu=vfpv3
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_PREFIX)/libc/usr/lib -mhard-float -mfpu=vfpv3

include ../../mk/spksrc.tc.mk
