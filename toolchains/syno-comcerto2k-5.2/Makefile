TC_NAME = syno-$(TC_ARCH)

TC_ARCH = comcerto2k
TC_VERS = 5.2
TC_FIRMWARE = 5.0-4458

TC_DIST_NAME = comcerto2k-gcc464_glibc217_neon_comcerto-GPL.txz

TC_EXT = txz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%205.2%20Tool%20Chains/Mindspeed%20Comcerto%202000%20Linux%203.2.40

TC_BASE_DIR = arm-cortexa9-linux-gnueabi
TC_PREFIX = arm-cortexa9-linux-gnueabi
TC_TARGET = arm-cortexa9-linux-gnueabi

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
