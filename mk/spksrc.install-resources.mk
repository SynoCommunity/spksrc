# include this file to install arch independent resources
#
# packages using this have to:
# - implement a custom INSTALL_TARGET to copy the required files to the 
#   target location under $(STAGING_INSTALL_PREFIX)
# - create a PLIST file to include the target file(s)/folder(s)

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

#####

ifneq ($(REQUIRE_KERNEL),)
  @$(error install-resources cannot be used when REQUIRE_KERNEL is set)
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

install: patch
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

### For make dependency-tree
include ../../mk/spksrc.dependency-tree.mk

.PHONY: all-archs
all-archs: $(addprefix arch-,$(AVAILABLE_TOOLCHAINS))

####

arch-%:
	@$(MSG) Building package for arch $*
	-@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*)))

####
