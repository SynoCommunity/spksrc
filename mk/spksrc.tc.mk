
# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(shell pwd)/work
include ../../mk/spksrc.directories.mk


# Configure the included makefiles
URLS          = $(TC_DIST_SITE)/$(TC_DIST_NAME)
NAME          = $(TC_NAME)
COOKIE_PREFIX = $(TC_NAME)-
DIST_FILE     = $(TOOLCHAINS_DIR)/$(TC_VERS)/$(TC_DIST_NAME)
DIST_EXT      = $(TC_EXT)
DISTRIB_DIR   = $(TOOLCHAINS_DIR)/$(TC_VERS)
LOCAL_FILE    = $(TC_DIST_NAME)

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

fix: patch
include ../../mk/spksrc.tc-fix.mk


all: fix


TOOLS = ld ldshared:"gcc -shared" cpp nm cc:gcc as ranlib cxx:g++ ar strip objdump readelf

CFLAGS += $(TC_CFLAGS)
CFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include

CPPFLAGS += $(TC_CPPFLAGS)
CPPFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include

CXXFLAGS += $(TC_CXXFLAGS)
CXXFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include

LDFLAGS += $(TC_LDFLAGS)
LDFLAGS += -L$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib
LDFLAGS += -Wl,--rpath-link,$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib
LDFLAGS += -Wl,--rpath,$(INSTALL_PREFIX)/lib


.PHONY: tc_vars
tc_vars: patch
	@echo TC_ENV :=
	@for tool in $(TOOLS) ; \
	do \
	  target=`echo $${tool} | sed 's/\(.*\):\(.*\)/\1/'` ; \
	  source=`echo $${tool} | sed 's/\(.*\):\(.*\)/\2/'` ; \
	  echo TC_ENV += `echo $${target} | tr [:lower:] [:upper:] `=\"$(WORK_DIR)/$(TC_BASE_DIR)/bin/$(TC_PREFIX)-$${source}\" ; \
	done
	@echo TC_ENV += CFLAGS=\"$(CFLAGS) $$\(ADDITIONAL_CFLAGS\)\"
	@echo TC_ENV += CPPFLAGS=\"$(CPPFLAGS) $$\(ADDITIONAL_CPPFLAGS\)\"
	@echo TC_ENV += CXXFLAGS=\"$(CXXFLAGS) $$\(ADDITIONAL_CXXFLAGS\)\"
	@echo TC_ENV += LDFLAGS=\"$(LDFLAGS) $$\(ADDITIONAL_LDFLAGS\)\"
	@echo TC_CONFIGURE_ARGS := --host=$(TC_TARGET) --build=i686-pc-linux
	@echo TC_TARGET := $(TC_TARGET)
	@echo TC_PREFIX := $(TC_PREFIX)-
	@echo TC_PATH := $(WORK_DIR)/$(TC_BASE_DIR)/bin/
	@echo CFLAGS := $(CFLAGS) $$\(ADDITIONAL_CFLAGS\)
	@echo CPPFLAGS := $(CPPFLAGS) $$\(ADDITIONAL_CPPFLAGS\)
	@echo CXXFLAGS := $(CXXFLAGS) $$\(ADDITIONAL_CXXFLAGS\)
	@echo LDFLAGS := $(LDFLAGS) $$\(ADDITIONAL_LDFLAGS\)
	@echo TC_FIRMWARE := $(TC_FIRMWARE)
	@echo TC_OS_MIN_VER := $(TC_OS_MIN_VER)
	@echo TC_ARCH := $(TC_ARCH)


### Clean rules
clean:
	rm -fr $(WORK_DIR)

$(DIGESTS_FILE): download
	@$(MSG) "Generating digests for $(TC_NAME)"
	@rm -f $@ && touch -f $@
	@for type in SHA1 SHA256 MD5; do \
	  case $$type in \
	    SHA1)     tool=sha1sum ;; \
	    SHA256)   tool=sha256sum ;; \
	    MD5)      tool=md5sum ;; \
	  esac ; \
	  echo "$(LOCAL_FILE) $$type `$$tool $(DIST_FILE) | cut -d\" \" -f1`" >> $@ ; \
	done
