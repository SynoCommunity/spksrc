TC_NAME = syno-evansport

TC_DIST_NAME = gcc463_glibc213_i686-GPL.tgz

TC_EXT = tgz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%204.3%20Tool%20Chains/Intel%20x86%20Linux%203.2.40%20%28Evansport%29

TC_BASE_DIR = i686-pc-linux-gnu
TC_PREFIX = i686-pc-linux-gnu
TC_TARGET = i686-pc-linux-gnu

TC_ARCH = evansport
TC_FIRMWARE = 3.1-1594

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
