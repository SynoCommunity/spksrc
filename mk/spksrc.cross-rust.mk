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

# install rust target on demand:
INSTALLED_RUST_TARGETS := $(shell rustup target list --installed)
ifneq ($(findstring $(RUST_TARGET),${INSTALLED_RUST_TARGETS}),$(RUST_TARGET))
install_rust_target:
	@echo "  ==> install rust target [$(RUST_TARGET)]" ; \
	rustup target install $(RUST_TARGET) ;

else
install_rust_target:
	@echo "  ==> rust target [$(RUST_TARGET)] is already installed" ;

endif


# set default RUST_SRC_DIR
ifeq ($(strip $(RUST_SRC_DIR)),)
RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
endif

# Set linker environment variable
RUST_LINKER_ENV=CARGO_TARGET_$(shell echo $(RUST_TARGET) | tr - _ | tr a-z A-Z)_LINKER
CARGO_ENV=$(RUST_LINKER_ENV)=$(TC_PATH)$(TC_PREFIX)gcc

# Use distrib folder as cargo download cache
ENV += CARGO_HOME=/spksrc/distrib/cargo

# Set the cargo parameters
CARGO_TARGET = --target=$(RUST_TARGET)
CARGO_PATH = --path $(RUST_SRC_DIR)
CARGO_ROOT = --root $(STAGING_INSTALL_PREFIX)


ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = rust_build_and_install_target
endif

# Default rust build and installation with cargo
rust_build_and_install_target:
	@echo "  ==> Cargo install rust package $(PKG_NAME)"
	$(CARGO_ENV) cargo install $(CARGO_TARGET) $(CARGO_PATH) $(CARGO_ROOT)


#####

ifneq ($(REQ_KERNEL),)
  @$(error rust modules cannot build when REQ_KERNEL is set)
endif

# Check if package supports ARCH
ifneq ($(UNSUPPORTED_ARCHS),)
  ifneq (,$(findstring $(ARCH),$(UNSUPPORTED_ARCHS)))
    @$(error Arch '$(ARCH)' is not a supported architecture )
  endif
endif

# Check minimum DSM requirements of package
ifneq ($(REQUIRED_DSM),)
  ifeq (,$(findstring $(ARCH),$(SRM_ARCHS)))
    ifneq ($(REQUIRED_DSM),$(firstword $(sort $(TCVERSION) $(REQUIRED_DSM))))
      @$(error DSM Toolchain $(TCVERSION) is lower than required version in Makefile $(REQUIRED_DSM))
    endif
  endif
endif
# Check minimum SRM requirements of package
ifneq ($(REQUIRED_SRM),)
  ifeq ($(ARCH),$(findstring $(ARCH),$(SRM_ARCHS)))
    ifneq ($(REQUIRED_SRM),$(firstword $(sort $(TCVERSION) $(REQUIRED_SRM))))
      @$(error SRM Toolchain $(TCVERSION) is lower than required version in Makefile $(REQUIRED_SRM))
    endif
  endif
endif

#####

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

ifeq ($(strip $(PLIST_TRANSFORM)),)
PLIST_TRANSFORM= cat
endif

.PHONY: cat_PLIST
cat_PLIST:
	@for depend in $(DEPENDS) ; \
	do                          \
	  $(MAKE) WORK_DIR=$(WORK_DIR) --no-print-directory -C ../../$$depend cat_PLIST ; \
	done
	@if [ -f PLIST ] ; \
	then \
	  $(PLIST_TRANSFORM) PLIST ; \
	else \
	  $(MSG) "No PLIST for $(NAME)" >&2; \
	fi

### Clean rules
smart-clean:
	rm -rf $(WORK_DIR)/$(PKG_DIR)
	rm -f $(WORK_DIR)/.$(COOKIE_PREFIX)*

clean:
	rm -fr work work-*


all: install

sha1sum := $(shell which sha1sum 2>/dev/null || which gsha1sum 2>/dev/null)
sha256sum := $(shell which sha256sum 2>/dev/null || which gsha256sum 2>/dev/null)
md5sum := $(shell which md5sum 2>/dev/null || which gmd5sum 2>/dev/null || which md5 2>/dev/null)

.PHONY: $(DIGESTS_FILE)
$(DIGESTS_FILE): download
	@$(MSG) "Generating digests for $(PKG_NAME)"
	@rm -f $@ && touch -f $@
	@for type in SHA1 SHA256 MD5; do \
	  case $$type in \
	    SHA1)     tool=${sha1sum} ;; \
	    SHA256)	  tool=${sha256sum} ;; \
	    MD5)      tool=${md5sum} ;; \
	  esac ; \
	  echo "$(LOCAL_FILE) $$type `$$tool $(DIST_FILE) | cut -d\" \" -f1`" >> $@ ; \
	done

dependency-tree:
	@echo `perl -e 'print "\\\t" x $(MAKELEVEL),"\n"'`+ $(NAME) $(PKG_VERS)
	@for depend in $(BUILD_DEPENDS) $(DEPENDS) ; \
	do \
	  $(MAKE) --no-print-directory -C ../../$$depend dependency-tree ; \
	done

.PHONY: all-archs
all-archs: $(addprefix arch-,$(AVAILABLE_ARCHS))

arch-%:
	@$(MSG) Building package for arch $*
	-@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*)))

.PHONY: kernel-required
kernel-required:
	@if [ -n "$(REQ_KERNEL)" ]; then \
	  exit 1 ; \
	fi
	@for depend in $(BUILD_DEPENDS) $(DEPENDS) ; do \
	  if $(MAKE) --no-print-directory -C ../../$$depend kernel-required >/dev/null 2>&1 ; then \
	    exit 0 ; \
	  else \
	    exit 1 ; \
	  fi ; \
	done

