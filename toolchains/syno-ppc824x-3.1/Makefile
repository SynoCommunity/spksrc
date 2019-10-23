TC_NAME = syno-$(TC_ARCH)

TC_ARCH = ppc824x
TC_VERS = 3.1
TC_FIRMWARE = 3.1-1594

# Kernel 2.6.24
#TC_DIST_NAME = gcc334_glibc233_ppc824x.tgz
# Kernel 2.4.22
TC_DIST_NAME = gcc334_glibc233_ppc.tgz

TC_EXT = tgz
#TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/DSM%203.1%20Tool%20Chains/PowerPC%20824x%20Linux%202.6.24
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/DSM%203.1%20Tool%20Chains/PowerPC%20824x%20Linux%202.4.22

TC_BASE_DIR = powerpc-linux
TC_PREFIX = powerpc-linux
TC_TARGET = powerpc-unknown-linux

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/include
TC_LDFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/lib

include ../../mk/spksrc.tc.mk
