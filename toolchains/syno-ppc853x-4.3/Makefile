TC_NAME = syno-$(TC_ARCH)

TC_ARCH = ppc853x
TC_VERS = 4.3
TC_FIRMWARE = 3.1-1594

TC_DIST_NAME = gcc343_glibc234_ppc853x-GPL.tgz

TC_EXT = tgz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%204.3%20Tool%20Chains/PowerPC%20853x%20Linux%202.6.32

TC_BASE_DIR = powerpc-linux-gnuspe
TC_PREFIX = powerpc-linux-gnuspe
TC_TARGET = powerpc-unknown-linux

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/lib

include ../../mk/spksrc.tc.mk
