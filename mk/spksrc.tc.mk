### Toolchain rules


# Configure the included makefiles
URLS                       = $(TC_DIST_SITE)/$(TC_DIST_NAME)
NAME                       = $(TC_NAME)
COOKIE_PREFIX              = 
ifneq ($(strip $(TC_DIST_FILE)),)
LOCAL_FILE                 = $(TC_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE              = $(TC_DIST_FILE)
else
LOCAL_FILE                 = $(TC_DIST_NAME)
endif
DISTRIB_DIR                = $(TOOLCHAIN_DIR)/$(TC_VERS)
DIST_FILE                  = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT                   = $(TC_EXT)

ifneq ($(strip $(or $(TC_NAME),$(TC_ARCH))),)
TC_ARCH_SUFFIX = -$(or $(lastword $(subst -, ,$(TC_NAME))),$(TC_ARCH))-$(TC_VERS)
else
TC_ARCH_SUFFIX :=
endif

#####

# Common directories
include ../../mk/spksrc.directories.mk

### Include common definitions
include ../../mk/spksrc.common.mk

### Include common rules
include ../../mk/spksrc.common-rules.mk

#####

TC = syno$(TC_ARCH_SUFFIX)
TC_WORK_DIR ?= $(abspath $(WORK_DIR)/../../../toolchain/$(TC)/work)

# Define $(RUN) for other targets (download, extract, patch, etc)
RUN = cd $(TC_WORK_DIR)/$(TC_TARGET) && env $(ENV)

#####

TOOLCHAIN_COOKIE = $(TC_WORK_DIR)/.$(COOKIE_PREFIX)toolchain_done

.PHONY: $(PRE_TOOLCHAIN_TARGET) $(TOOLCHAIN_TARGET) $(POST_TOOLCHAIN_TARGET)
ifeq ($(strip $(PRE_TOOLCHAIN_TARGET)),)
PRE_TOOLCHAIN_TARGET = pre_toolchain_target
else
$(PRE_TOOLCHAIN_TARGET): toolchain_msg
endif
ifeq ($(strip $(TOOLCHAIN_TARGET)),)
TOOLCHAIN_TARGET = toolchain_target
else
$(TOOLCHAIN_TARGET): $(PRE_TOOLCHAIN_TARGET)
endif
ifeq ($(strip $(POST_TOOLCHAIN_TARGET)),)
POST_TOOLCHAIN_TARGET = post_toolchain_target
else
$(POST_TOOLCHAIN_TARGET): $(TOOLCHAIN_TARGET)
endif

.PHONY: toolchain_msg
toolchain_msg:
	@$(MSG) "Preparing toolchain for $(or $(lastword $(subst -, ,$(TC_NAME))),$(TC_ARCH))-$(TC_VERS)"

#####

include ../../mk/spksrc.depend.mk

include ../../mk/spksrc.tc-vers.mk

include ../../mk/spksrc.tc-flags.mk

download:
include ../../mk/spksrc.download.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum
include ../../mk/spksrc.extract.mk

fix: extract
include ../../mk/spksrc.tc-fix.mk

patch: fix
include ../../mk/spksrc.patch.mk

rustc: patch
include ../../mk/spksrc.tc-rust.mk

#tcvars: rustc
include ../../mk/spksrc.tc-vars.mk

#####

.DEFAULT_GOAL := toolchain

pre_toolchain_target: toolchain_msg

# Define _all as a real target that does the work
.PHONY: _all
_all: rustc depend tcvars

# toolchain_target wraps _all with logging
.PHONY: toolchain_target
toolchain_target: $(PRE_TOOLCHAIN_TARGET)
	$(call LOG_WRAPPED,_all)

post_toolchain_target: $(TOOLCHAIN_TARGET)

#####

ifeq ($(wildcard $(TOOLCHAIN_COOKIE)),)
toolchain: $(TOOLCHAIN_COOKIE)

$(TOOLCHAIN_COOKIE): $(POST_TOOLCHAIN_TARGET)
	$(create_target_dir)
	@touch -f $@

else
toolchain: ;
endif

### For make digests
include ../../mk/spksrc.generate-digests.mk
