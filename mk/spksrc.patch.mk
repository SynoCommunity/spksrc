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

ifeq ($(strip $(PATCHES)),)
ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM][vV]?5/*.patch))
else ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM][vV]?7/*.patch))
else ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM][vV]?8/*.patch))
else ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[pP][pP][cC]/*.patch))
else ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[xX]86/*.patch))
else ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[xX]8?6?_?64/*.patch))
else
PATCHES = $(sort $(wildcard patches/*.patch))
endif
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

