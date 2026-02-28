
# Configure the included makefiles
NAME          = $(KERNEL_NAME)
URLS          = $(KERNEL_DIST_SITE)/$(KERNEL_DIST_NAME)
COOKIE_PREFIX = $(PKG_NAME)-

ifneq ($(strip $(REQUIRE_KERNEL_MODULE)),)
PKG_NAME      = linux-$(subst syno-,,$(NAME))
PKG_DIR       = $(PKG_NAME)
else
PKG_NAME      = linux
PKG_DIR       = $(PKG_NAME)
endif

# kernel download variables
include ../../mk/spksrc.kernel/url.mk
include ../../mk/spksrc.kernel/versions.mk

ifneq ($(KERNEL_DIST_FILE),)
LOCAL_FILE    = $(KERNEL_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE = $(KERNEL_DIST_FILE)
else
LOCAL_FILE    = $(KERNEL_DIST_NAME)
endif
DISTRIB_DIR   = $(KERNEL_DIR)/$(KERNEL_VERS)
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(KERNEL_EXT)
EXTRACT_CMD   = $(EXTRACT_CMD.$(KERNEL_EXT)) --skip-old-files --strip-components=$(KERNEL_STRIP) $(KERNEL_PREFIX)

#####

ifneq ($(KERNEL_ARCH),)
KERNEL_ARCH_SUFFIX := -$(KERNEL_ARCH)-$(KERNEL_VERS)
else
KERNEL_ARCH_SUFFIX := -$(ARCH)-$(TCVERSION)
endif

#####

# Common directories
include ../../mk/spksrc.directories.mk

### Include common definitions
include ../../mk/spksrc.common.mk

### Include common rules
include ../../mk/spksrc.common-rules.mk

# Common kernel variables
include ../../mk/spksrc.kernel/flags.mk

# Constants
default: all

#####

# Mark toolchain installation as completed using status cookie
KERNEL_COOKIE = $(KERNEL_WORK_DIR)/.$(COOKIE_PREFIX)kernel_done

KERNEL = syno$(KERNEL_ARCH_SUFFIX)
KERNEL_WORK_DIR ?= $(abspath $(WORK_DIR)/../../../kernel/$(KERNEL)/work)

# Define $(RUN) for other targets (download, extract, patch, etc)
RUN = cd $(KERNEL_WORK_DIR)/linux && env $(ENV)

#####

# Prior to interacting with the kernel files
# move the kernel source tree to its final destination
POST_EXTRACT_TARGET      = kernel_post_extract_target

# By default do not install kernel headers
INSTALL_TARGET           = nop

#####

TC ?= syno$(KERNEL_ARCH_SUFFIX)

#####

include ../../mk/spksrc.cross-env.mk

include ../../mk/spksrc.status.mk

include ../../mk/spksrc.download.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum status
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

kernel_configure: patch
include ../../mk/spksrc.kernel/configure.mk

kernel_module: kernel_configure
include ../../mk/spksrc.kernel/module.mk

install: kernel_module
include ../../mk/spksrc.kernel/headers.mk

install: kernel_headers
include ../../mk/spksrc.install.mk

plist: install
include ../../mk/spksrc.plist.mk

# -----------------------------------------------------------------------------
# Stage1: Toolchain (MANDATORY)
#  - First call builds the toolchain (download / extract / patch / build)
#  - Second call generates tc_vars* files in the kernel WORK_DIR
# -----------------------------------------------------------------------------
TCVARS_DONE := $(WORK_DIR)/.tcvars_done

.PHONY: kernel-stage1
kernel-stage1: $(TCVARS_DONE)

ifneq ($(strip $(TC)),)
$(TCVARS_DONE):
	@$(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) toolchain
	@$(MAKE) WORK_DIR=$(KERNEL_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) tcvars
else
$(TCVARS_DONE): ;
endif


# -----------------------------------------------------------------------------
# Stage2: kernel cross build
#  - Executes full build pipeline up to plist generation
# -----------------------------------------------------------------------------
.PHONY: kernel-stage2
kernel-stage2: install plist

# all wraps both stages with logging to ensure:
#  - consistent output formatting
#  - proper error propagation
.PHONY: all
all:
	@mkdir -p $(WORK_DIR)
	$(call LOG_WRAPPED,kernel-stage1)
	$(call LOG_WRAPPED,kernel-stage2)

####

.PHONY: kernel_post_extract_target
kernel_post_extract_target:
	mv $(WORK_DIR)/$(KERNEL_DIST) $(WORK_DIR)/$(PKG_DIR)

####

### For make digests
include ../../mk/spksrc.generate-digests.mk
