# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Configure the included makefiles
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
ifneq ($(PKG_DIST_FILE),)
DIST_FILE     = $(DISTRIB_DIR)/$(PKG_DIST_FILE)
else
DIST_FILE     = $(DISTRIB_DIR)/$(PKG_DIST_NAME)
endif
DIST_EXT      = $(PKG_EXT)

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)
TC = syno$(ARCH_SUFFIX)
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

.PHONY: cat_PLIST
cat_PLIST:
	@for depend in $(DEPENDS) ; \
	do                          \
	  $(MAKE) WORK_DIR=$(WORK_DIR) --no-print-directory -C ../../$$depend cat_PLIST ; \
	done
	@if [ -f PLIST ] ; \
	then \
	  cat PLIST ; \
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


SUPPORTED_TCS = $(notdir $(wildcard ../../toolchains/syno-*))
SUPPORTED_ARCHS = $(notdir $(subst -,/,$(SUPPORTED_TCS)))

$(DIGESTS_FILE):
	@$(MSG) "Generating digests for $(PKG_NAME)"
	@touch -f $@
	@for type in SHA1 SHA256 MD5; do \
	  localFile=$(PKG_DIST_FILE) ; \
	  if [ -z "$${localFile}" ]; then \
	    localFile=$(PKG_DIST_NAME) ; \
	  fi ; \
	  case $$type in \
	    SHA1|sha1)     tool=sha1sum ;; \
	    SHA256|sha256) tool=sha256sum ;; \
	    MD5|md5)       tool=md5sum ;; \
	  esac ; \
	  echo "$${localFile} $$type `$$tool $(DISTRIB_DIR)/$${localFile} | cut -d\" \" -f1`" >> $@ ; \
	done

dependency-tree:
	@echo `perl -e 'print "\\\t" x $(MAKELEVEL),"\n"'`+ $(NAME)
	@for depend in $(DEPENDS) ; \
	do \
	  $(MAKE) --no-print-directory -C ../../$$depend dependency-tree ; \
	done

.PHONY: all-archs
all-archs: $(addprefix arch-,$(SUPPORTED_ARCHS))

arch-%:
	@$(MSG) Building package for arch $(subst arch-,,$@) 
	@env $(MAKE) ARCH=$(subst arch-,,$@)

