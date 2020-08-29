TC_NAME = syno-$(TC_ARCH)

TC_ARCH = armada375
TC_VERS = 5.1

TC_DIST = gcc464_glibc215_hard_armada375-GPL
TC_EXT = tgz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%205.1%20Tool%20Chains/Marvell%20Armada%20375%20Linux%203.2.40

TC_PREFIX = arm-marvell-linux-gnueabi
TC_SYSROOT = $(TC_PREFIX)/libc
TC_LIBRARY = $(TC_SYSROOT)/usr/lib
TC_FLAGS = -mhard-float -mfpu=vfpv3

PRE_FIX_TARGET = myFix

include ../../mk/spksrc.tc.mk

.PHONY: myFix
myFix:
	@$(MSG) "Fixing libtool files for $(NAME)"
	@mv $(WORK_DIR)/armv7-marvell-linux-gnueabi-hard $(WORK_DIR)/$(TC_PREFIX)
