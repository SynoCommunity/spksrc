TC_NAME = syno-$(TC_ARCH)

TC_ARCH = qoriq
TC_VERS = 6.0.2
TC_FIRMWARE = 6.0.2-8451

TC_DIST = qoriq-gcc493_glibc220_hard_qoriq-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.0.2%20Tool%20Chains/PowerPC%20QorIQ%20Linux%202.6.32

TC_PREFIX = powerpc-e500v2-linux-gnuspe

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/lib

TC_SYSROOT = $(TC_PREFIX)/sysroot

include ../../mk/spksrc.tc.mk
