TC_NAME = syno-$(TC_ARCH)

TC_ARCH = powerpc
TC_VERS = 4.0
TC_FIRMWARE = 3.1-1594

TC_DIST = gcc334_glibc233_ppc-GPL
TC_EXT = tgz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%204.0%20Tool%20Chains/PowerPC%20824x%20Linux%202.4.22

TC_PREFIX = powerpc-linux
TC_TARGET = powerpc-unknown-linux

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/include
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/include
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/include
TC_LDFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/lib

include ../../mk/spksrc.tc.mk
