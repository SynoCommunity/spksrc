# Build rust programs
# 
# prerequisites:
# - module does not require kernel (REQUIRE_KERNEL)
# 
# remarks:
# - most content is taken from spksrc.cc.mk and modified for rust
# - CONFIGURE_TARGET is not supported (used for rust target installation)
# - build and install is done in one step
# 

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

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
TC = syno$(ARCH_SUFFIX)
endif

##### rust specific configurations
include ../../mk/spksrc.cross-rust-env.mk

# configure is used to install rust targets
CONFIGURE_TARGET = nop

ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = nop
endif

ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = rust_install_target
endif

# Set default RUST_SRC_DIR
ifeq ($(strip $(RUST_SRC_DIR)),)
RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
endif

# Set the cargo install parameters
CARGO_INSTALL_ARGS += --path $(RUST_SRC_DIR)
CARGO_INSTALL_ARGS += --root $(STAGING_INSTALL_PREFIX)

# Default build with rust and installation with cargo
rust_install_target:
	@echo "  ==> Cargo install rust package $(PKG_NAME)"
	@$(RUN) cargo +$(RUST_TOOLCHAIN) install $(CARGO_INSTALL_ARGS)


#####

include ../../mk/spksrc.pre-check.mk

include ../../mk/spksrc.cross-env.mk

include ../../mk/spksrc.download.mk

include ../../mk/spksrc.depend.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum depend
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


### Clean rules
smart-clean:
	rm -rf $(WORK_DIR)/$(PKG_DIR)
	rm -f $(WORK_DIR)/.$(COOKIE_PREFIX)*

clean:
	rm -fr work work-* build-*.log

all: install plist

### For make kernel-required (used by spksrc.spk.mk)
include ../../mk/spksrc.kernel-required.mk

### For make digests
include ../../mk/spksrc.generate-digests.mk

### For make dependency-tree
include ../../mk/spksrc.dependency-tree.mk

.PHONY: all-archs
all-archs: $(addprefix arch-,$(AVAILABLE_TOOLCHAINS))

####

arch-%:
	@$(MSG) Building package for arch $*
	@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*))) 2>&1 | tee --append build-$*.log

####
