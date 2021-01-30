### Patch rules
#   Apply local patch to a directory tree. Patches will be applied from the software directory,
#   using patch -p0 <.
# Target are executed in the following order:
#  patch_msg_target
#  pre_patch_target   (override with PRE_PATCH_TARGET)
#  patch_target       (override with PATCH_TARGET)
#  post_patch_target  (override with POST_PATCH_TARGET)
# Variables:
#  PATCHES_LEVEL      Level of the patches to apply
#  PATCHES            List of patches to apply. If not defined, will apply patch files in the
#                     patches directory.

ifeq ($(strip $(PATCHES_LEVEL)),)
PATCHES_LEVEL = 0
endif

# find patches into the following directory order:
#    patches/*.patch
#    patches/kernel-$(TC_KERNEL)/*.patch
#    patches/DSM-$(TCVERSION)/*.patch
#    patches/$(group)/*.patch
#    patches/$(group)-$(TCVERSION)/*.patch
#    patches/$(arch)/*.patch
#    patches/$(arch)-$(TCVERSION)/*.patch
# supported groups: armv5, armv7, armv7l, armv8, ppc, i686, x64
ifeq ($(strip $(PATCHES)),)
PATCHES = $(foreach group,ARMv5_ARCHS ARMv7_ARCHS ARMv7L_ARCHS ARMv8_ARCHS PPC_ARCHS i686_ARCHS x64_ARCHS, \
	$(foreach arch,$($(group)), \
	$(if $(filter $(ARCH),$(arch)),$(sort $(wildcard patches/*.patch patches/kernel-$(TC_KERNEL)/*.patch patches/DSM-$(TCVERSION)/*.patch patches/$(shell echo ${group} | cut -f1 -d'_'| tr '[:upper:]' '[:lower:]')/*.patch  patches/$(shell echo ${group} | cut -f1 -d'_'| tr '[:upper:]' '[:lower:]')-$(TCVERSION)/*.patch patches/$(arch)/*.patch patches/$(arch)-$(TCVERSION)/*.patch)),)))
endif

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
