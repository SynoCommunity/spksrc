TC_NAME = syno-$(TC_ARCH)

TC_ARCH = evansport
TC_VERS = 5.2
TC_KERNEL = 3.2.40+

TC_DIST = evansport-gcc463_glibc213_i686_patched-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%205.2%20Tool%20Chains/Intel%20x86%20Linux%203.2.40%20%28Evansport%29

TC_PREFIX = i686-pc-linux-gnu

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/usr/include
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sys-root/lib

TC_SYSROOT = $(TC_PREFIX)

include ../../mk/spksrc.tc.mk
