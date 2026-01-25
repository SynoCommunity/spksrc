###############################################################################
# spksrc.cross-cc.mk
#
# Provides a two-stage cross compilation environment:
# 1) Stage1: ensures toolchain is built and $(WORK_DIR)/tc_vars* are generated
# 2) Stage2: sets up cross-env using $(WORK_DIR)/tc_vars*
###############################################################################

# Configure the included makefiles
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
ifneq ($(PKG_DIST_FILE),)
LOCAL_FILE    = $(PKG_DIST_FILE)
else
LOCAL_FILE    = $(PKG_DIST_NAME)
endif
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
ifneq ($(ARCH),noarch)
TC = syno$(ARCH_SUFFIX)
endif
endif

.DEFAULT_GOAL := all

# Common directories (must be set after ARCH_SUFFIX)
include ../../mk/spksrc.directories.mk

# Common makefiles
include ../../mk/spksrc.common.mk

#####

include ../../mk/spksrc.pre-check.mk

include ../../mk/spksrc.cross-env.mk

include ../../mk/spksrc.download.mk

include ../../mk/spksrc.depend.mk

include ../../mk/spksrc.status.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum depend status
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

configure: patch
include ../../mk/spksrc.configure.mk

compile: configure
include ../../mk/spksrc.compile.mk

install: compile
include ../../mk/spksrc.install.mk

plist: install
include ../../mk/spksrc.plist.mk

#####

TCVARS_DONE := $(WORK_DIR)/.tcvars_done

# -----------------------------------------------------------------------------
# Stage1: Toolchain bootstrap
# -----------------------------------------------------------------------------
.PHONY: cross-stage1
cross-stage1: $(TCVARS_DONE)

$(TCVARS_DONE):
	@$(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) toolchain
	@$(MAKE) WORK_DIR=$(WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) tcvars

# -----------------------------------------------------------------------------
# Stage2: Define cross-stage2 as a real target that does the work
# -----------------------------------------------------------------------------
.PHONY: cross-stage2
cross-stage2: install plist

# all wraps cross-stage2 with logging
.PHONY: all
all:
	@mkdir -p $(WORK_DIR)
	$(call LOG_WRAPPED,cross-stage1)
	$(call LOG_WRAPPED,cross-stage2)

####

### For arch-* and all-<supported|latest>
include ../../mk/spksrc.supported.mk

####
