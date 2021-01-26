# * all goes in $(WORK_DIR) : work-arch, or simple work, in the current directory
# * it will be installed in $(INSTALL_PREFIX) on the target system (/usr/local/transmission)
# * each source package is unpacked in $(WORK_DIR)
# * the install target installs files in $(WORK_DIR)/install/, known as $(INSTALL_DIR)
#   depending on how the makefiles works, the install prefix may be $(INSTALL_DIR) or
#   $(INSTALL_DIR)/$(INSTALL_PREFIX). This must be assigned to $(STAGING_INSTALL_PREFIX) if needed.
# * the copy target creates a staging area, in $(WORK_DIR)/staging/, known as $(STAGING_DIR).
#   This staging dir does not contain the $(INSTALL_PREFIX)
# * Binaries and libraries are strip in $(STAGING_DIR)
# * The full content of $(STAGING_DIR) is packed, it will then be unpacked on the target in $(INSTALL_PREFIX)

PWD := $(shell pwd)

BASE_DISTRIB_DIR  = $(PWD)/../../distrib
PIP_DIR = $(BASE_DISTRIB_DIR)/pip
TOOLCHAIN_DIR = $(BASE_DISTRIB_DIR)/toolchain
TOOLKIT_DIR = $(BASE_DISTRIB_DIR)/toolkit
KERNEL_DIR = $(BASE_DISTRIB_DIR)/kernel
PACKAGES_DIR = $(PWD)/../../packages
# Default download location, see spksrc.download.mk
ifeq ($(strip $(DISTRIB_DIR)),)
DISTRIB_DIR = $(BASE_DISTRIB_DIR)
endif

ifndef WORK_DIR
WORK_DIR = $(PWD)/work$(ARCH_SUFFIX)
endif

ifndef INSTALL_DIR
INSTALL_DIR = $(WORK_DIR)/install
endif
STAGING_DIR = $(WORK_DIR)/staging

ifndef INSTALL_PREFIX
ifneq ($(strip $(SPK_NAME)),)
INSTALL_PREFIX = /var/packages/$(SPK_NAME)/target
else
ifneq ($(strip $(PKG_NAME)),)
INSTALL_PREFIX = /usr/local/$(PKG_NAME)
else
INSTALL_PREFIX = /usr/local
endif
endif
endif

ifndef KERNEL_SOURCE_DIR
KERNEL_SOURCE_DIR = $(PWD)/../../kernel/syno-$(ARCH)-$(TCVERSION)/work/linux
endif

ifeq ($(strip $(STAGING_INSTALL_PREFIX)),)
STAGING_INSTALL_PREFIX = $(INSTALL_DIR)$(INSTALL_PREFIX)
endif

define create_target_dir
@mkdir -p `dirname $@`
endef

