TC_NAME = syno-$(TC_ARCH)

TC_ARCH = rtd1296
TC_VERS = 6.1
TC_OS_MIN_VER = 6.1-15047

TC_DIST = rtd1296-gcc494_glibc220_armv8-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/DSM%206.1%20Tool%20Chains/Intel%20x86%20Linux%204.4.15%20%28Rtd1296%29

TC_BASE_DIR = aarch64-unknown-linux-gnueabi
TC_PREFIX = aarch64-unknown-linux-gnueabi
TC_TARGET = aarch64-unknown-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/lib

FIX_TARGET = myFix

include ../../mk/spksrc.tc.mk

.PHONY: myFix
myFix:
	chmod -R u+w $(WORK_DIR)
	@find $(WORK_DIR)/$(TC_BASE_DIR) -type f -name '*.la' -exec sed -i -e "s|^libdir=.*$$|libdir='$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/lib'|" {} \;
