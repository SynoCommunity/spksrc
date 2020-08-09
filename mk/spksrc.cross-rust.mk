# Build rust programs
# 
# prerequisites:
# - module does not require kernel (REQ_KERNEL)
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

# configure is used to install rust targets
CONFIGURE_TARGET = install_rust_target

# skip compile_target if not used by module
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = nop
endif

RUST_TOOLCHAIN ?= stable

RUST_TARGET =
# map archs to rust targets
ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
RUST_TARGET=x86_64-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
RUST_TARGET=i686-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
# may be not supported for cargo
RUST_TARGET=armv5te-unknown-linux-gnueabi
endif
ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
RUST_TARGET=armv7-unknown-linux-gnueabihf
endif
ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
RUST_TARGET=aarch64-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
RUST_TARGET=powerpc-unknown-linux-gnu
endif
ifeq ($(RUST_TARGET),)
$(error Arch $(ARCH) not supported)
endif

# Use distrib folder as cargo download cache
CARGO_HOME_PATH=/spksrc/distrib/cargo
ENV += CARGO_HOME=$(CARGO_HOME_PATH)
ENV += PATH=:$(CARGO_HOME_PATH)/bin/:$(PATH)

ifeq (,$(shell $(ENV) which rustup))
install_rustup:
	@echo "  ==> install rustup" ; \
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
	        CARGO_HOME=$(CARGO_HOME_PATH) sh -s -- -y
else
install_rustup:
	@echo "  ==> rustup alredy installed" ;
endif

install_rust_toolchain: install_rustup
	@echo "  ==> install rust toolchain [$(RUST_TOOLCHAIN)]" ; \
	env $(ENV) rustup toolchain install $(RUST_TOOLCHAIN) ;

# Install rust target on demand:
install_rust_target: install_rust_toolchain
	@echo "  ==> install rust target [$(RUST_TARGET)]" ; \
	env $(ENV) rustup target install $(RUST_TARGET) ;

# Set default RUST_SRC_DIR
ifeq ($(strip $(RUST_SRC_DIR)),)
RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
endif

# Set linker environment variable
RUST_LINKER_ENV=CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_LINKER
CARGO_ENV=$(RUST_LINKER_ENV)=$(TC_PATH)$(TC_PREFIX)gcc

# Set the cargo parameters
CARCO_BUILD_ARGS += --target=$(RUST_TARGET)
CARCO_BUILD_ARGS += --path $(RUST_SRC_DIR)
CARCO_BUILD_ARGS += --root $(STAGING_INSTALL_PREFIX)


ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = rust_build_and_install_target
endif

# Default rust build and installation with cargo
rust_build_and_install_target:
	@echo "  ==> Cargo install rust package $(PKG_NAME)"
	$(ENV) $(CARGO_ENV) cargo install $(CARCO_BUILD_ARGS)


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
	rm -fr work work-*

all: install

include ../../mk/spksrc.generate-digests.mk

include ../../mk/spksrc.dependency-tree.mk

.PHONY: all-archs
all-archs: $(addprefix arch-,$(AVAILABLE_ARCHS))

arch-%:
	@$(MSG) Building package for arch $*
	-@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*)))

include ../../mk/spksrc.kernel-required.mk
