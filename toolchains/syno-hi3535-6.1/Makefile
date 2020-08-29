TC_NAME = syno-$(TC_ARCH)

TC_ARCH = hi3535
TC_VERS = 6.1
TC_OS_MIN_VER = 6.1-15047
TC_KERNEL = 3.4.35+

TC_DIST = hi3535-gcc483_glibc219_hi3535-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.1%20Tool%20Chains/HiSilicon%20Hi3535%20Linux%203.4.35

TC_PREFIX = arm-cortexa9-linux-gnueabi
TC_TARGET = arm-cortexa9-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/lib

TC_SYSROOT = $(TC_PREFIX)/sysroot

include ../../mk/spksrc.tc.mk
