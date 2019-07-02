TC_NAME = syno-$(TC_ARCH)

TC_ARCH = evansport
TC_VERS = 6.1
TC_OS_MIN_VER = 6.1-15047

TC_DIST = evansport-gcc493_glibc220_linaro_i686-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/DSM%206.1%20Tool%20Chains/Intel%20x86%20Linux%203.2.40%20%28Evansport%29

TC_BASE_DIR = i686-pc-linux-gnu
TC_PREFIX = i686-pc-linux-gnu
TC_TARGET = i686-pc-linux-gnu

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
