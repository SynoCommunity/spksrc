# Build go programs
# 
# prerequisites:
# - cross/module depends on native/go only
# - module does not require kernel (REQ_KERNEL)
# 
# remarks:
# - Restriction for minimal DSM version is not supported (toolchains are not used for go builds)
# - CONFIGURE_TARGET is not supported/bypassed
# - most content is taken from spksrc.cc.mk and modified for go build and install
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

##### golang specific configurations
include ../../mk/spksrc.cross-go-env.mk

# avoid run of make configure
CONFIGURE_TARGET = nop


ifeq ($(strip $(COMPILE_TARGET)),)
ifneq ($(strip $(GO_SRC_DIR)),)
COMPILE_TARGET = go_build_target
endif
endif

# default go build:
go_build_target:
	@$(MSG) - Compile with go build
	cd $(GO_SRC_DIR) && env $(ENV) go build $(GO_BUILD_ARGS)


ifeq ($(strip $(INSTALL_TARGET)),)
ifneq ($(strip $(GO_BIN_DIR)),)
INSTALL_TARGET = go_install_target
endif
endif

# default go install:
go_install_target:
	@$(MSG) - Install go binaries
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(GO_BIN_DIR) $(STAGING_INSTALL_PREFIX)/bin/


#####

ifneq ($(REQ_KERNEL),)
  @$(error go modules cannot build when REQ_KERNEL is set)
endif

# Check if package supports ARCH
ifneq ($(UNSUPPORTED_ARCHS),)
  ifneq (,$(findstring $(ARCH),$(UNSUPPORTED_ARCHS)))
    @$(error Arch '$(ARCH)' is not a supported architecture )
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
	rm -rf $(EXTRACT_PATH)/
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
