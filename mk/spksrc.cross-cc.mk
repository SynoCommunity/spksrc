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


#####

ifneq ($(REQ_KERNEL),)
  ifeq ($(ARCH),x64)
    @$(error x64 arch cannot be used when REQ_KERNEL is set )
  endif
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

plist: install
include ../../mk/spksrc.plist.mk


### Clean rules
smart-clean:
	rm -rf $(WORK_DIR)/$(PKG_DIR)
	rm -f $(WORK_DIR)/.$(COOKIE_PREFIX)*

clean:
	rm -fr work work-*


all: install plist

### For make digests
include ../../mk/spksrc.generate-digests.mk

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

