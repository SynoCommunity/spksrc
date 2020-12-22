TC_ARCH = armada375
TC_VERS = 5.1
TC_KERNEL = 3.2.40
TC_GCC = 4.6.4
TC_GLIBC = 2.15

TC_DIST = gcc464_glibc215_hard_armada375-GPL
TC_EXT = tgz
TC_DIST_SITE_PATH = Marvell%20Armada%20375%20Linux%203.2.40

TC_TARGET = arm-marvell-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/libc
TC_LIBRARY = $(TC_SYSROOT)/usr/lib
TC_EXTRA_CFLAGS = -mhard-float -mfpu=vfpv3

PRE_FIX_TARGET = syno_armada375_fix

include ../../mk/spksrc.tc.mk

.PHONY: syno_armada375_fix
syno_armada375_fix:
	@$(MSG) "Fixing libtool files for $(NAME)"
	@mv $(WORK_DIR)/armv7-marvell-linux-gnueabi-hard $(WORK_DIR)/$(TC_TARGET)
