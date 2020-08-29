TC_NAME = syno-$(TC_ARCH)

TC_ARCH = ipq806x
TC_VERS = 1.2
TC_OS_MIN_VER = 1.2-7742
TC_KERNEL = 4.4.60+

TC_DIST = gcc493_glibc220_hard-GPL
TC_EXT = tgz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/SRM%201.2%20Tool%20Chains/QUALCOMM%20IPQ806X%20Linux%204.4.60
TC_DIST_FILE = $(TC_ARCH)-$(TC_DIST_NAME)

TC_PREFIX = arm-unknown-linux-gnueabi
TC_TARGET = arm-unknown-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/lib

TC_SYSROOT = $(TC_PREFIX)/sysroot

include ../../mk/spksrc.tc.mk
