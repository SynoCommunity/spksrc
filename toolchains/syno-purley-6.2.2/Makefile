TC_NAME = syno-$(TC_ARCH)

TC_ARCH = purley
TC_VERS = 6.2.2
TC_OS_MIN_VER = 6.2-25023

TC_DIST = purley-gcc493_glibc220_linaro_x86_64-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/DSM%206.2.2%20Tool%20Chains/Intel%20x86%20Linux%204.4.59%20%28Purley%29

TC_BASE_DIR = x86_64-pc-linux-gnu
TC_PREFIX = x86_64-pc-linux-gnu
TC_TARGET = x86_64-pc-linux-gnu

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_LIBDIR = $(TC_BASE_DIR)/sys-root/lib
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_LIBDIR)

include ../../mk/spksrc.tc.mk
