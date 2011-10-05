
# Constants
SHELL := $(SHELL) -e
default: all

include ../../mk/spksrc.directories.mk

# Configure the included makefiles
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
DIST_FILE     = $(DISTRIB_DIR)/$(PKG_DIST_NAME)

#####

include ../../mk/spksrc.cross-env.mk
RUN = cd $(WORK_DIR)/$(PKG_DIR) && $(ENV)
MSG = echo "===>   "

include ../../mk/spksrc.download.mk

include ../../mk/spksrc.depend.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum depend
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

# TODO: Clean up this
LDFLAGS  = -Wl,--rpath-link,$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib 
LDFLAGS += -Wl,--rpath,$(INSTALL_PREFIX)/lib
export LDFLAGS

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
	@cat PLIST

### Clean rules
clean:
	rm -fr $(WORK_DIR)
	
all: install
	