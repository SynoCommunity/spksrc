TC_NAME = syno-$(TC_ARCH)

TC_ARCH = 88f6281
TC_VERS = 6.1
TC_KERNEL = 2.6.32.12+

TC_DIST = 6281-gcc464_glibc215_88f6281-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.1%20Tool%20Chains/Marvell%2088F628x%20Linux%202.6.32

TC_PREFIX = arm-marvell-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/libc/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/libc/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/libc/usr/include
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/libc/lib

TC_SYSROOT = $(TC_PREFIX)/libc

include ../../mk/spksrc.tc.mk
