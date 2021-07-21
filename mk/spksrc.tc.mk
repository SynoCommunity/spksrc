
# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(shell pwd)/work
include ../../mk/spksrc.directories.mk

include ../../mk/spksrc.common.mk


# Configure the included makefiles
URLS             = $(TC_DIST_SITE)/$(TC_DIST_NAME)
NAME             = $(TC_NAME)
COOKIE_PREFIX    = 
ifneq ($(TC_DIST_FILE),)
LOCAL_FILE       = $(TC_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE    = $(TC_DIST_FILE)
else
LOCAL_FILE       = $(TC_DIST_NAME)
endif
DISTRIB_DIR      = $(TOOLCHAIN_DIR)/$(TC_VERS)
DIST_FILE        = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT         = $(TC_EXT)
TC_LOCAL_VARS_MK = $(WORK_DIR)/tc_vars.mk

#####

RUN = cd $(WORK_DIR)/$(TC_TARGET) && env $(ENV)
MSG = echo "===>   "

include ../../mk/spksrc.download.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

vers: patch
include ../../mk/spksrc.tc-vers.mk

flag: vers
include ../../mk/spksrc.tc-flags.mk

fix: flag
include ../../mk/spksrc.tc-fix.mk

all: $(TC_LOCAL_VARS_MK)

.PHONY: $(TC_LOCAL_VARS_MK)
$(TC_LOCAL_VARS_MK): fix
	env $(MAKE) --no-print-directory tc_vars > $@ 2>/dev/null;

.PHONY: tc_vars
tc_vars: fix
	@echo TC_ENV :=
	@for tool in $(TOOLS) ; \
	do \
	  target=`echo $${tool} | sed 's/\(.*\):\(.*\)/\1/'` ; \
	  source=`echo $${tool} | sed 's/\(.*\):\(.*\)/\2/'` ; \
	  echo TC_ENV += `echo $${target} | tr [:lower:] [:upper:] `=\"$(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)$${source}\" ; \
	done
	@echo TC_ENV += CFLAGS=\"$(CFLAGS) $$\(ADDITIONAL_CFLAGS\)\"
	@echo TC_ENV += CPPFLAGS=\"$(CPPFLAGS) $$\(ADDITIONAL_CPPFLAGS\)\"
	@echo TC_ENV += CXXFLAGS=\"$(CXXFLAGS) $$\(ADDITIONAL_CXXFLAGS\)\"
	@echo TC_ENV += LDFLAGS=\"$(LDFLAGS) $$\(ADDITIONAL_LDFLAGS\)\"
	@echo TC_CONFIGURE_ARGS := --host=$(TC_TARGET) --build=i686-pc-linux
	@echo TC_TYPE := $(TC_TYPE)
	@echo TC_TARGET := $(TC_TARGET)
	@echo TC_PREFIX := $(TC_PREFIX)
	@echo TC_PATH := $(WORK_DIR)/$(TC_TARGET)/bin/
	@echo CFLAGS := $(CFLAGS) $$\(ADDITIONAL_CFLAGS\)
	@echo CPPFLAGS := $(CPPFLAGS) $$\(ADDITIONAL_CPPFLAGS\)
	@echo CXXFLAGS := $(CXXFLAGS) $$\(ADDITIONAL_CXXFLAGS\)
	@echo LDFLAGS := $(LDFLAGS) $$\(ADDITIONAL_LDFLAGS\)
	@echo TC_LIBRARY := $(TC_LIBRARY)
	@echo TC_INCLUDE := $(TC_INCLUDE)
	@echo TC_EXTRA_CFLAGS := $(TC_EXTRA_CFLAGS)
	@echo TC_VERS := $(TC_VERS)
	@echo TC_BUILD := $(TC_BUILD)
	@echo TC_OS_MIN_VER := $(TC_OS_MIN_VER)
	@echo TC_ARCH := $(TC_ARCH)
# Add "+" to EXTRAVERSION for kernels version >= 4.4
ifeq ($(call version_ge, ${TC_KERNEL}, 4.4),1)
	@echo TC_KERNEL := $(TC_KERNEL)+
else
	@echo TC_KERNEL := $(TC_KERNEL)
endif
	@echo TC_GCC := $(TC_GCC)
	@echo TC_GLIBC := $(TC_GLIBC)


### Clean rules
clean:
	rm -fr $(WORK_DIR)

### For make digests
include ../../mk/spksrc.generate-digests.mk
