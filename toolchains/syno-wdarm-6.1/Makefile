TC_NAME = syno-$(TC_ARCH)

TC_ARCH = wdarm
TC_VERS = 6.1
TC_FIRMWARE = 6.1-15047

TC_DIST = armv7-marvell-linux-gnueabi-softfp_i686_64K_Dev_20131002
TC_EXT = tar.gz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://dl.bintray.com/tfl/wdpksrc

TC_BASE_DIR = armv7-marvell-linux-gnueabi-softfp_i686_64K_Dev_20131002
TC_PREFIX = arm-marvell-linux-gnueabi
TC_TARGET = arm-marvell-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/usr/include
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/lib

FIX_TARGET = myFix

include ../../mk/spksrc.tc.mk

.PHONY: myFix
myFix:
	chmod -R u+w $(WORK_DIR)
	@find $(WORK_DIR)/$(TC_BASE_DIR) -type f -name '*.la' -exec sed -i -e "s|^libdir=.*$$|libdir='$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/lib'|" {} \;
