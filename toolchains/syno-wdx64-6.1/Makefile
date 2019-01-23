TC_NAME = syno-$(TC_ARCH)

TC_ARCH = wdx64
TC_VERS = 6.1
TC_FIRMWARE = 6.1-15047

TC_DIST = x86_64-intel-linux-gnu-WD-00.02B-04272014.1721
TC_EXT = tar.gz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://dl.bintray.com/tfl/wdpksrc

TC_BASE_DIR = x86_64-intel-linux-gnu
TC_PREFIX = x86_64-intel-linux-gnu
TC_TARGET = x86_64-pc-linux-gnu

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
