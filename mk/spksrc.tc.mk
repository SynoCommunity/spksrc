
# Constants
SHELL=sh -e
DISTRIB_DIR = ../../distrib
override WORK_DIR := $(shell pwd)/work

# Package dependend
TC_DIST_FILE = $(DISTRIB_DIR)/$(TC_DIST_NAME)

MSG = echo "===>   "

all: $(WORK_DIR) fetch checksum extract patch

$(DISTRIB_DIR):
	@mkdir $@
$(WORK_DIR):
	@mkdir $@


### Fetch rules
.PHONY: fetch
fetch: $(TC_DIST_FILE)

ifneq ($(subst http://sourceforge.net/,,$(TC_DIST_SITE)),$(TC_DIST_SITE))
FETCH_EXTRA_PARAM = "?use_mirror=autoselect"
endif

$(TC_DIST_FILE): $(DISTRIB_DIR)
ifeq ($(wildcard $(TC_DIST_FILE)),)
	@$(MSG) "Fetching $(TC_NAME)"
	wget -O $@ $(TC_DIST_SITE)/$(TC_DIST_NAME)$(FETCH_EXTRA_PARAM)
else
	@true
endif

### Checksum rules
.PHONY: checksum 
checksum: $(TC_DIST_FILE)
	@true


### Extract rules
EXTRACT_CMD.tar.gz = tar xzpf $(TC_DIST_FILE) -C $(WORK_DIR)
EXTRACT_CMD.tgz = tar xzpf $(TC_DIST_FILE) -C $(WORK_DIR)
EXTRACT_CMD.tar.bz2 = tar xjpf $(TC_DIST_FILE) -C $(WORK_DIR)
EXTRACT_CMD.tar.xz = tar xJpf $(TC_DIST_FILE) -C $(WORK_DIR)

EXTRACT_CMD = $(EXTRACT_CMD.$(TC_EXT)) 

EXTRACT_COOKIE = $(WORK_DIR)/$(PKG_NAME).extract_done

ifeq ($(wildcard $(EXTRACT_COOKIE)),)
extract: checksum
	@$(MSG) "Extracting for $(TC_NAME)"
	$(EXTRACT_CMD)
	@touch -f $(EXTRACT_COOKIE)
else
extract:
	@true 
endif


### Patch rules
PATCH_COOKIE = $(WORK_DIR)/$(PKG_NAME).patch_done
PATCHES = $(wildcard patches/*.patch)
.PHONY: patch
patch: extract
ifeq ($(wildcard $(PATCH_COOKIE)),)
patch: patch_msg
ifeq ($(PATCH_TARGET),)
ifneq ($(PATCHES),)
patch: patch_effective
endif
else
patch: $(PATCH_TARGET)
endif
patch: patch_cookie
else
patch:
	@true 
endif

.PHONY: patch_msg patch_effective patch_cookie
patch_msg:
	@$(MSG) "Patching $(TC_NAME)"
patch_effective:
	for patchfile in $(PATCHES) \
	do \
	  patch -C $(WORK_DIR) -p0 < $${patchfile} \
	done 
patch_cookie:
	@touch -f $(PATCH_COOKIE)


TOOLS = ld cpp nm cc:gcc as ranlib cxx:g++ ar strip objdump

.PHONY: tc_env
tc_env: patch
	@for tool in $(TOOLS) ; \
	do \
	  target=`echo $${tool} | sed 's/\(.*\):\(.*\)/\1/'` ; \
	  source=`echo $${tool} | sed 's/\(.*\):\(.*\)/\2/'` ; \
	  echo `echo $${target} | tr [:lower:] [:upper:] `=$(WORK_DIR)/$(TC_BASE_DIR)/bin/$(TC_PREFIX)-$${source} ; \
	done ; \

.PHONY: tc_configure_args
tc_configure_args:
	@echo --host=$(TC_TARGET) --build=i686-pc-linux


### Clean rules
clean:
	rm -fr $(WORK_DIR)
