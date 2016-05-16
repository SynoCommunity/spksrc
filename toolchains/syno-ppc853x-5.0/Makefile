TC_NAME = syno-$(TC_ARCH)

TC_ARCH = ppc853x
TC_VERS = 5.0
TC_FIRMWARE = 5.0-4458

TC_DIST_NAME = gcc4374_eglibc2874_qoriq-GPL.tgz

TC_EXT = tgz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%205.0%20Tool%20Chains/PowerPC%20853x%20Linux%202.6.32

TC_BASE_DIR = powerpc-none-linux-gnuspe
TC_PREFIX = powerpc-none-linux-gnuspe
TC_TARGET = powerpc-none-linux

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/lib

include ../../mk/spksrc.tc.mk
