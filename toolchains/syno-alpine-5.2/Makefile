TC_NAME = syno-alpine

TC_ARCH = alpine alpine4k
TC_VERS = 5.2
TC_FIRMWARE = 5.1-5004

TC_DIST_NAME = alpine-gcc472_glibc215_alpine-GPL.txz

TC_EXT = txz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%205.2%20Tool%20Chains/Annapurna%20Alpine%20Linux%203.2.40

TC_BASE_DIR = arm-linux-gnueabihf
TC_PREFIX = arm-linux-gnueabihf
TC_TARGET = arm-linux-gnueabihf

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
