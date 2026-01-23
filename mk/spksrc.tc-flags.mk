# we can't check whether gfortran exists, because toolchain is not yet extracted
ifeq ($(strip $(firstword $(subst ., ,$(TC_VERS)))),7)
TC_HAS_FORTRAN = 1
else ifeq ($(strip $(TC_VERS)),1.3)
TC_HAS_FORTRAN = 1
else ifeq ($(strip $(TC_VERS)),6.2.4)
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
TC_HAS_FORTRAN = 1
endif
endif

TOOLS = ld ldshared:"gcc -shared" cpp nm cc:gcc as ranlib cxx:g++ ar strip objdump objcopy readelf
ifneq ($(strip $(TC_HAS_FORTRAN)),)
TOOLS += fc:gfortran
endif

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

CFLAGS += -I$(abspath $(WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE)) $(TC_EXTRA_CFLAGS)
CFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)

CPPFLAGS += -I$(abspath $(WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE)) $(TC_EXTRA_CFLAGS)
CPPFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)

CXXFLAGS += -I$(abspath $(WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE)) $(TC_EXTRA_CFLAGS)
CXXFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)

ifneq ($(strip $(TC_HAS_FORTRAN)),)
FFLAGS += -I$(abspath $(WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE)) $(TC_EXTRA_FFLAGS)
FFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
endif

LDFLAGS += -L$(abspath $(WORK_DIR)/$(TC_TARGET)/$(TC_LIBRARY)) $(TC_EXTRA_CFLAGS)
LDFLAGS += -L$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
LDFLAGS += -Wl,--rpath-link,$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
LDFLAGS += -Wl,--rpath,$(abspath $(INSTALL_PREFIX)/lib)

RUSTFLAGS += -Clink-arg=-L$(abspath $(WORK_DIR)/$(TC_TARGET)/$(TC_LIBRARY))
RUSTFLAGS += -Clink-arg=-L$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
RUSTFLAGS += -Clink-arg=-Wl,--rpath-link,$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
RUSTFLAGS += -Clink-arg=-Wl,--rpath,$(abspath $(INSTALL_PREFIX)/lib)
