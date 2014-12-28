TC_NAME = syno-$(TC_ARCH)

TC_ARCH = armadaxp
TC_VERS = 4.3
TC_FIRMWARE = 3.1-1594

TC_DIST_NAME = gcc464_glibc215_hard_armada-GPL.tgz

TC_EXT = tgz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%204.3%20Tool%20Chains/Marvell%20armada%20370%20Linux%203.2.40

TC_BASE_DIR = arm-marvell-linux-gnueabi
TC_PREFIX = arm-marvell-linux-gnueabi
TC_TARGET = arm-marvell-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/include -mcpu=marvell-pj4 -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard -DSYNO_MARVELL_ARMADA370 -DSYNO_PLATFORM=MARVELL_ARMADA370
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/include -mcpu=marvell-pj4 -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard -DSYNO_MARVELL_ARMADA370 -DSYNO_PLATFORM=MARVELL_ARMADA370
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/include -mcpu=marvell-pj4 -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard -DSYNO_MARVELL_ARMADA370 -DSYNO_PLATFORM=MARVELL_ARMADA370
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/libc/lib -mcpu=marvell-pj4 -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard

include ../../mk/spksrc.tc.mk
