TC_NAME = syno-$(TC_ARCH)

TC_ARCH = avoton
TC_VERS = 5.1
TC_FIRMWARE = 5.0-4458

TC_DIST = gcc473_glibc217_x86_64_avoton-GPL
TC_EXT = tgz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%205.1%20Tool%20Chains/Intel%20x86%20Linux%203.2.40%20%28Avoton%29

TC_PREFIX = x86_64-pc-linux-gnu

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/lib

TC_SYSROOT = $(TC_PREFIX)

include ../../mk/spksrc.tc.mk
