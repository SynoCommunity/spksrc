TC_NAME = syno-$(TC_ARCH)

TC_ARCH = ppc854x
TC_VERS = 4.0
TC_FIRMWARE = 3.1-1594

TC_DIST = gcc343_glibc234_ppc854x-GPL
TC_EXT = tgz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%204.0%20Tool%20Chains/PowerPC%20854x%20Linux%202.6.32

TC_PREFIX = powerpc-linux-gnuspe

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/lib

include ../../mk/spksrc.tc.mk
