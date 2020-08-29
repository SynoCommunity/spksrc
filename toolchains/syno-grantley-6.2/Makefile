TC_NAME = syno-$(TC_ARCH)

TC_ARCH = grantley
TC_VERS = 6.2
TC_KERNEL = 3.10.105+

TC_DIST = grantley-gcc493_glibc220_linaro_x86_64-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.2%20Tool%20Chains/Intel%20x86%20Linux%203.10.102%20%28Grantley%29

TC_PREFIX = x86_64-pc-linux-gnu

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/lib

TC_SYSROOT = $(TC_PREFIX)/sys-root

include ../../mk/spksrc.tc.mk
