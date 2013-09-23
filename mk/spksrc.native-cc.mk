# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Force build in native tool directrory, not cross directory.
WORK_DIR := $(PWD)/work-native

# Package dependend
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
ifeq ($(COOKIE_PREFIX),)
COOKIE_PREFIX = $(PKG_NAME)-
endif
ifneq ($(PKG_DIST_FILE),)
DIST_FILE     = $(DISTRIB_DIR)/$(PKG_DIST_FILE)
else
DIST_FILE     = $(DISTRIB_DIR)/$(PKG_DIST_NAME)
endif
DIST_EXT      = $(PKG_EXT)

#####

include ../../mk/spksrc.native-env.mk

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

dependency-tree:
	@echo `perl -e 'print "\\\t" x $(MAKELEVEL),"\n"'`+ $(NAME) $(PKG_VERS)
	@for depend in $(DEPENDS) ; \
	do \
	  $(MAKE) --no-print-directory -C ../../$$depend dependency-tree ; \
	done

### Clean rules
clean:
	rm -fr $(WORK_DIR)

all: install

