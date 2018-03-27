TC_NAME = syno-$(TC_ARCH)

TC_ARCH = northstarplus
TC_VERS = 1.1
TC_FIRMWARE = 1.1-6931

TC_DIST = gcc493_glibc220_hard-GPL
TC_EXT = tgz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/SRM%201.1%20Tool%20Chains/BROADCOM%20NORTHSTARPLUS%20Linux%203.6.5

TC_BASE_DIR = arm-unknown-linux-gnueabi
TC_PREFIX = arm-unknown-linux-gnueabi
TC_TARGET = arm-unknown-linux-gnueabi

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

