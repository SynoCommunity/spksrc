TC_NAME = syno-$(TC_ARCH)

TC_ARCH = cedarview
TC_VERS = 6.0
TC_FIRMWARE = 6.0-beta

TC_DIST_NAME = cedarview-gcc493_glibc220_linaro_x86_64-GPL.txz

TC_EXT = txz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%206.0%20Beta2%20Tool%20Chains/Intel%20x86%20Linux%203.10.77%20%28Cedarview%29/

TC_BASE_DIR = x86_64-pc-linux-gnu
TC_PREFIX = x86_64-pc-linux-gnu
TC_TARGET ?= x86_64-pc-linux-gnu

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/usr/include
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sys-root/lib

FIX_TARGET = myFix

include ../../mk/spksrc.tc.mk

.PHONY: myFix
myFix:
	rm -rf $(WORK_DIR)/$(TC_BASE_DIR)/test-suite $(WORK_DIR)/$(TC_BASE_DIR)/build.log.bz2
	chmod -R u+w $(WORK_DIR)
	@find $(WORK_DIR)/$(TC_BASE_DIR) -type f -name '*.la' -exec sed -i -e "s|^libdir=.*$$|libdir='$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/lib'|" {} \;
	for file in g++ gcc ldd size strings; do \
		ln -s ../../bin/$(TC_PREFIX)-$$file $(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/bin/$$file; \
	done
