TC_NAME = syno-$(TC_ARCH)

TC_ARCH = braswell
TC_VERS = 5.2
TC_FIRMWARE = 5.2-5644
TC_KERNEL = 3.10.35+

TC_DIST = braswell-gcc473_glibc217_x86_64-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%205.2%20Tool%20Chains/Intel%20x86%20Linux%203.10.35%20%28Braswell%29

TC_BASE_DIR = x86_64-pc-linux-gnu
TC_PREFIX = x86_64-pc-linux-gnu
TC_TARGET = x86_64-pc-linux-gnu

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/lib

TC_SYSROOT = $(TC_BASE_DIR)

include ../../mk/spksrc.tc.mk
