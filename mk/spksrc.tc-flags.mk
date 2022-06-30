TOOLS = ld ldshared:"gcc -shared" cpp nm cc:gcc as ranlib cxx:g++ ar strip objdump readelf

ifeq ($(strip $(TC_NAME)),)
TC_NAME = syno-$(TC_ARCH)
endif

ifeq ($(strip $(TC_EXT)),)
TC_EXT = txz
endif

ifeq ($(strip $(TC_DIST_NAME)),)
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
endif

ifeq ($(strip $(TC_TYPE)),)
TC_TYPE = DSM
endif

ifeq ($(strip $(TC_OS_MIN_VER)),)
TC_OS_MIN_VER = $(word 1,$(subst ., ,$(TC_VERS))).$(word 2,$(subst ., ,$(TC_VERS)))-$(TC_BUILD)
endif

ifeq ($(strip $(TC_DIST_SITE_URL)),)
ifeq ($(strip $(firstword $(subst ., ,$(TC_VERS)))),7)
TC_DIST_SITE_URL = https://global.download.synology.com/download/ToolChain/toolchain/$(TC_VERS)-$(TC_BUILD)/
else
TC_DIST_SITE_URL = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/$(TC_TYPE)%20$(TC_VERS)%20Tool%20Chains/
endif
endif

ifeq ($(strip $(TC_DIST_SITE)),)
TC_DIST_SITE = $(TC_DIST_SITE_URL)$(TC_DIST_SITE_PATH)
endif

ifeq ($(strip $(TC_PREFIX)),)
TC_PREFIX = $(TC_TARGET)-
endif

ifeq ($(strip $(TC_INCLUDE)),)
TC_INCLUDE = $(TC_SYSROOT)/usr/include
endif

ifeq ($(strip $(TC_LIBRARY)),)
TC_LIBRARY = $(TC_SYSROOT)/lib
endif

CFLAGS += -I$(WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE) $(TC_EXTRA_CFLAGS)
CFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include

CPPFLAGS += -I$(WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE) $(TC_EXTRA_CFLAGS)
CPPFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include

CXXFLAGS += -I$(WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE) $(TC_EXTRA_CFLAGS)
CXXFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include

LDFLAGS += -L$(WORK_DIR)/$(TC_TARGET)/$(TC_LIBRARY) $(TC_EXTRA_CFLAGS)
LDFLAGS += -L$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib
LDFLAGS += -Wl,--rpath-link,$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib
LDFLAGS += -Wl,--rpath,$(INSTALL_PREFIX)/lib
