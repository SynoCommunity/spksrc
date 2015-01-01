TC_NAME = syno-$(TC_ARCH)

TC_ARCH = alpine
TC_VERS = 5.1
TC_FIRMWARE = 5.1-5004

TC_DIST_NAME = gcc464_glibc217_alpine-GPL.tgz

TC_EXT = tgz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%205.1%20Tool%20Chains/Annapurna%20Alpine%20Linux%203.2.40

TC_BASE_DIR = arm-cortex_a15-linux-gnueabi
TC_PREFIX = arm-cortex_a15-linux-gnueabi
TC_TARGET = arm-cortex_a15-linux-gnueabi

TC_CFLAGS =
TC_CPPFLAGS =
TC_CXXFLAGS =
TC_LDFLAGS =

FIX_TARGET = myFix

include ../../mk/spksrc.tc.mk

.PHONY: myFix
myFix:
	chmod -R u+w $(WORK_DIR)
	@find $(WORK_DIR)/$(TC_BASE_DIR) -type f -name '*.la' -exec sed -i -e "s|^libdir=.*$$|libdir='$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/lib'|" {} \;
