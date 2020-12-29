TOOLKIT_ROOT=$(WORK_DIR)/../../../toolkit/syno-$(ARCH)-$(TCVERSION)/work

ifeq ($(strip $(TOOLKIT_NAME)),)
TOOLKIT_NAME = syno-$(TOOLKIT_ARCH)
endif

ifeq ($(strip $(TOOLKIT_DIST)),)
TOOLKIT_DIST = ds.$(TOOLKIT_ARCH)-$(TOOLKIT_VERS).dev
endif

ifeq ($(strip $(TOOLKIT_EXT)),)
TOOLKIT_EXT = txz
endif
 
ifeq ($(strip $(TOOLKIT_DIST_NAME)),)
TOOLKIT_DIST_NAME = $(TOOLKIT_DIST).$(TOOLKIT_EXT)
endif

ifeq ($(strip $(TOOLKIT_DIST_SITE)),)
TOOLKIT_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/toolkit/DSM$(TOOLKIT_VERS)
endif

ifeq ($(strip $(TOOLKIT_PREFIX)),)
TOOLKIT_PREFIX = local
endif

ifeq ($(strip $(TOOLKIT_STRIP)),)
TOOLKIT_STRIP = 6
endif

ifeq ($(strip $(TOOLKIT_BASE_DIR)),)
TOOLKIT_BASE_DIR = $(TOOLKIT_TARGET)
else ifeq ($(strip $(TOOLKIT_BASE_DIR)),nop)
TOOLKIT_BASE_DIR = 
endif

ifeq ($(strip $(TOOLKIT_SYSROOT)),)
TOOLKIT_SYSROOT ?= $(TOOLKIT_BASE_DIR)/sys-root/usr
else ifeq ($(strip $(TOOLKIT_SYSROOT)),nop)
TOOLKIT_SYSROOT = 
endif

TOOLKIT_CFLAGS = -I$(TOOLKIT_ROOT)/include

# Specic TOOLKIT to add to include search path
ifeq ($(findstring 'scsi',$(TOOLKIT)),'scsi')
TOOLKIT_CFLAGS += -I$(TOOLKIT_ROOT)/include/scsi
endif
ifeq ($(findstring 'mtd',$(TOOLKIT)),'mtd')
TOOLKIT_CFLAGS += -I$(TOOLKIT_ROOT)/include/mtd
endif
ifeq ($(findstring 'glib',$(TOOLKIT)),'glib')
TOOLKIT_CFLAGS += -I$(TOOLKIT_ROOT)/include/glib-2.0
endif
TOOLKIT_CPPFLAGS = -I$(TOOLKIT_ROOT)/include
TOOLKIT_CXXFLAGS = -I$(TOOLKIT_ROOT)/include
#
TOOLKIT_LDFLAGS = -L$(TOOLKIT_ROOT)/lib
TOOLKIT_LDFLAGS += -Wl,-rpath-link,$(TOOLKIT_ROOT)/lib
TOOLKIT_LDFLAGS += -Wl,-rpath,$(TOOLKIT_ROOT)/lib

include ../../mk/spksrc.common.mk

# Add lib64 for x86_64 archs
ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
TOOLKIT_LDFLAGS += -L$(TOOLKIT_ROOT)/lib64
TOOLKIT_LDFLAGS += -Wl,-rpath-link,$(TOOLKIT_ROOT)/lib64
TOOLKIT_LDFLAGS += -Wl,-rpath,$(TOOLKIT_ROOT)/lib64
TOOLKIT_PKG_CONFIG_PATH += $(TOOLKIT_ROOT)/lib/pkgconfig:$(TOOLKIT_ROOT)/lib64/pkgconfig
else
TOOLKIT_PKG_CONFIG_PATH = $(TOOLKIT_ROOT)/lib/pkgconfig
endif

# Add native hardware acceleration libraries and include files for evansport
ifeq ($(findstring $(ARCH),'evansport'),$(ARCH))
TOOLKIT_CFLAGS += -I$(TOOLKIT_ROOT)/include/intelce-utilities
TOOLKIT_CFLAGS += -I$(TOOLKIT_ROOT)/include/intelce-utilities/linux_user
TOOLKIT_LDFLAGS += -L$(TOOLKIT_ROOT)/lib/intelce-utilities
TOOLKIT_LDFLAGS += -Wl,-rpath-link,$(TOOLKIT_ROOT)/lib/intelce-utilities
TOOLKIT_LDFLAGS += -Wl,-rpath,$(TOOLKIT_ROOT)/lib/intelce-utilities
endif
