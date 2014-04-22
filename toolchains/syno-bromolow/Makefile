TC_NAME = syno-bromolow

TC_DIST_NAME = gcc420_glibc236_x64_bromolow-GPL.tgz

TC_EXT = tgz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%204.3%20Tool%20Chains/Intel%20x86%20Linux%203.2.40%20%28Bromolow%29

TC_BASE_DIR = x86_64-linux-gnu
TC_PREFIX = x86_64-linux-gnu
TC_TARGET = x86_64-linux-gnu

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
