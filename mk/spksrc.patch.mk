### Patch rules
#   Apply local patch to a directory tree. Patches will be applied from the software directory,
#   using patch -p0 <.
# Targets are executed in the following order:
#  patch_msg_target
#  pre_patch_target   (override with PRE_PATCH_TARGET)
#  patch_target       (override with PATCH_TARGET)
#  post_patch_target  (override with POST_PATCH_TARGET)
# Variables:
#  PATCHES_LEVEL      Level of the patches to apply (default = 0)
#  PATCHES            List of patches to apply. If not defined, will apply patch files in the
#                     patches directory.

ifeq ($(strip $(PATCHES_LEVEL)),)
PATCHES_LEVEL = 0
endif

# find patches into the following directory order:
#    patches/*.patch                                   ## this is the default location (and the only location for native)
#    patches/kernel-$(subst +,,$(TC_KERNEL))/*.patch   ## Discards trailing + in version number
#    patches/DSM-$(TCVERSION)/*.patch                  ## Ex: DSM-6.2.4, DSM-7.2, also applies to noarch
#    patches/DSM-<major>/*.patch                       ## Ex: DSM-6, DSM-7, also applies to noarch
#    patches/$(arch)-$(TCVERSION)/*.patch
#    patches/$(arch)/*.patch
#    patches/$(group)-$(TCVERSION)/*.patch
#    patches/$(group)/*.patch                          ## supported groups: arm, armv5, armv7, armv7l, armv8, ppc, i686, x64
PATCHES += $(sort $(wildcard patches/*.patch))
PATCHES += $(sort $(wildcard patches/kernel-$(subst +,,$(TC_KERNEL))/*.patch))
PATCHES += $(sort $(wildcard patches/DSM-$(TCVERSION)/*.patch \
	                     patches/DSM-$(firstword $(subst ., ,$(TCVERSION)))/*.patch))
ifneq ($(ARCH),)
PATCHES += $(sort $(wildcard patches/$(ARCH)-$(TCVERSION)/*.patch \
	                     patches/$(ARCH)/*.patch))
PATCHES += $(sort $(foreach group,ARM_ARCHS ARMv5_ARCHS ARMv7_ARCHS ARMv7L_ARCHS ARMv8_ARCHS PPC_ARCHS i686_ARCHS x64_ARCHS, \
	   $(if $(filter $(ARCH),$($(group))), \
	   $(wildcard patches/$(shell echo $(group) | cut -f1 -d '_' | tr 'A-Z' 'a-z')/*.patch \
	              patches/$(shell echo $(group) | cut -f1 -d '_' | tr 'A-Z' 'a-z')-$(TCVERSION)/*.patch))))
endif
PATCHES := $(realpath $(PATCHES))

PATCH_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)patch_done

ifeq ($(strip $(PRE_PATCH_TARGET)),)
PRE_PATCH_TARGET = pre_patch_target
else
$(PRE_PATCH_TARGET): patch_msg
endif
ifeq ($(strip $(PATCH_TARGET)),)
PATCH_TARGET = patch_target
else
$(PATCH_TARGET): $(PRE_PATCH_TARGET)
endif
ifeq ($(strip $(POST_PATCH_TARGET)),)
POST_PATCH_TARGET = post_patch_target
else
$(POST_PATCH_TARGET): $(PATCH_TARGET)
endif

.PHONY: patch patch_msg
.PHONY: $(PRE_PATCH_TARGET) $(PATCH_TARGET) $(POST_PATCH_TARGET)

patch_msg:
	@$(MSG) "Patching for $(NAME)"

pre_patch_target: patch_msg

patch_target: $(PRE_PATCH_TARGET)
ifneq ($(strip $(PATCHES)),)
	@for patchfile in $(PATCHES) ; \
	do \
	  echo "patch -p$(PATCHES_LEVEL) < $${patchfile}" ; \
	  cat $${patchfile} | ($(RUN) patch -p$(PATCHES_LEVEL)) ; \
	done
endif

post_patch_target: $(PATCH_TARGET) 

ifeq ($(wildcard $(PATCH_COOKIE)),)
patch: $(PATCH_COOKIE)

$(PATCH_COOKIE): $(POST_PATCH_TARGET)
	$(create_target_dir)
	@touch -f $@
else
patch: ;
endif
