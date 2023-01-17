TC_NAME = syno-$(TC_ARCH)

TC_ARCH = ppc854x
TC_VERS = 4.0
TC_FIRMWARE = 3.1-1594

TC_DIST_NAME = gcc343_glibc234_ppc854x-GPL.tgz

TC_EXT = tgz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%204.0%20Tool%20Chains/PowerPC%20854x%20Linux%202.6.32

TC_BASE_DIR = powerpc-linux-gnuspe
TC_PREFIX = powerpc-linux-gnuspe
TC_TARGET = powerpc-unknown-linux

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/lib

include ../../mk/spksrc.tc.mk
