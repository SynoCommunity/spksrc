TC_NAME = syno-$(TC_ARCH)

TC_ARCH = rtd1296
TC_VERS = 6.2.2
TC_OS_MIN_VER = 6.2.2-24922
TC_KERNEL = 4.4.59+

TC_DIST = rtd1296-gcc494_glibc220_armv8-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.2.2%20Tool%20Chains/Realtek%20RTD129x%20Linux%204.4.59

TC_PREFIX = aarch64-unknown-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/lib

TC_SYSROOT = $(TC_PREFIX)/sysroot

include ../../mk/spksrc.tc.mk
