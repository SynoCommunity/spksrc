TC_NAME = syno-armada370

TC_DIST_NAME = gcc462_glibc213_armadaxp.tgz

TC_EXT = tgz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%204.2%20Tool%20Chains/Marvell%20armada%20370%20Linux%203.2.40

TC_BASE_DIR = arm-marvell-linux-gnueabi
TC_PREFIX = arm-marvell-linux-gnueabi
TC_TARGET = arm-marvell-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/include -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/thumb2/usr/include -mcpu=marvell-pj4 -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/include -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/thumb2/usr/include -mcpu=marvell-pj4 -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/include -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/thumb2/usr/include -mcpu=marvell-pj4 -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/lib -mcpu=marvell-pj4 -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard

include ../../mk/spksrc.tc.mk
