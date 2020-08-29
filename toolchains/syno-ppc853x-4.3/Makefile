TC_NAME = syno-$(TC_ARCH)

TC_ARCH = ppc853x
TC_VERS = 4.3
TC_FIRMWARE = 3.1-1594

TC_DIST = gcc343_glibc234_ppc853x-GPL
TC_EXT = tgz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%204.3%20Tool%20Chains/PowerPC%20853x%20Linux%202.6.32

TC_PREFIX = powerpc-linux-gnuspe
TC_TARGET = powerpc-unknown-linux

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/lib

include ../../mk/spksrc.tc.mk
