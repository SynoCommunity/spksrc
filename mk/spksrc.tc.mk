
# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(shell pwd)/work
include ../../mk/spksrc.directories.mk


# Configure the included makefiles
URLS          = $(TC_DIST_SITE)/$(TC_DIST_NAME)
NAME          = $(TC_NAME)
COOKIE_PREFIX = $(TC_NAME)-
DIST_FILE     = $(DISTRIB_DIR)/$(TC_DIST_NAME)
DIST_EXT      = $(TC_EXT)

#####

RUN = cd $(WORK_DIR)/$(TC_BASE_DIR) && env $(ENV)
MSG = echo "===>   "

include ../../mk/spksrc.download.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk


all: patch


TOOLS = ld cpp nm cc:gcc as ranlib cxx:g++ ar strip objdump

CFLAGS  += $(TC_CFLAGS)
CFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include

CPPFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include

LDFLAGS += $(TC_LDFLAGS)
LDFLAGS += -L$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib 
LDFLAGS += -Wl,--rpath-link,$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib 
LDFLAGS += -Wl,--rpath,$(INSTALL_PREFIX)/lib


.PHONY: tc_env
tc_env: patch
	@for tool in $(TOOLS) ; \
	do \
	  target=`echo $${tool} | sed 's/\(.*\):\(.*\)/\1/'` ; \
	  source=`echo $${tool} | sed 's/\(.*\):\(.*\)/\2/'` ; \
	  echo `echo $${target} | tr [:lower:] [:upper:] `=$(WORK_DIR)/$(TC_BASE_DIR)/bin/$(TC_PREFIX)-$${source} ; \
	done
	@echo CFLAGS=\"$(CFLAGS)\"
	@echo CPPFLAGS=\"$(CPPFLAGS)\"
	@echo LDFLAGS=\"$(LDFLAGS)\"
	
.PHONY: tc_configure_args
tc_configure_args:
	@echo --host=$(TC_TARGET) --build=i686-pc-linux


### Clean rules
clean:
	rm -fr $(WORK_DIR)
