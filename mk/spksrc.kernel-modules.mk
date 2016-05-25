# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(shell pwd)/work
include ../../mk/spksrc.directories.mk

# Configure the included makefiles
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
DIST_FILE     = $(DISTRIB_DIR)/$(PKG_DIST_NAME)
DIST_EXT      = $(PKG_EXT)
DISTRIB_DIR   = $(KERNELS_DIR)/$(PKG_BRANCH)
COMPILE_TARGET = kernel_module_compile_target
EXTRACT_TARGET = kernel_extract_target
CONFIGURE_TARGET = kernel_configure_target
COPY_TARGET = nop

TC ?= syno-$(ARCH)-$(TCVERSION)

include ../../mk/spksrc.cross-env.mk
#####

KERNEL_ENV ?=
KERNEL_ENV += PATH=$$PATH

RUN = cd $(KERNEL_DIR) && env -i $(KERNEL_ENV)
MSG = echo "===>   "

.PHONY: kernel_module_compile_target kernel_extract_target kernel_configure_target

include ../../mk/spksrc.download.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

configure: patch
include ../../mk/spksrc.configure.mk

compile: configure
include ../../mk/spksrc.compile.mk


all: compile

### Clean rules
clean:
	rm -fr $(WORK_DIR)

$(DIGESTS_FILE):
	@$(MSG) "Generating digests for $(PKG_NAME)"
	@rm -f $@ && touch -f $@
	@for type in SHA1 SHA256 MD5; do \
	  case $$type in \
	    SHA1|sha1)     tool=sha1sum ;; \
	    SHA256|sha256) tool=sha256sum ;; \
	    MD5|md5)       tool=md5sum ;; \
	  esac ; \
	  echo "$(PKG_DIST_NAME) $$type `$$tool $(DISTRIB_DIR)/$(PKG_DIST_NAME) | cut -d\" \" -f1`" >> $@ ; \
	done

kernel_module_compile_target:
	$(RUN) $(MAKE) modules

kernel_extract_target:
	mkdir -p $(KERNEL_DIR)
	rm -rf $(KERNEL_DIR)
	tar -xpf $(DIST_FILE) -C $(EXTRACT_PATH) $(PKG_EXTRACT)
	mv $(EXTRACT_PATH)/$(PKG_EXTRACT) $(KERNEL_DIR)

kernel_configure_target: 
	@$(MSG) "Configuring depended kernel source"
	cp $(KERNEL_DIR)/$(SYNO_CONFIG) $(KERNEL_DIR)/.config
	# Update the Makefile
	sed -i -r 's,^ARCH\s*.+,ARCH\t= $(BASE_ARCH),' $(KERNEL_DIR)/Makefile
	sed -i -r 's,^CROSS_COMPILE\s*.+,CROSS_COMPILE\t= $(TC_PATH)$(TC_PREFIX),' $(KERNEL_DIR)/Makefile
	test -e $(WORK_DIR)/$(KERNEL_DIR)/arch/$(ARCH) || ln -sf $(BASE_ARCH) $(KERNEL_DIR)/arch/$(ARCH)
