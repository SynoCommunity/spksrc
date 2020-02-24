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
ifeq ($(findstring $(ARCH),'88f6281'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]5/*.patch patches/88f6281/*.patch))
else
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]5/*.patch))
endif

else ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
ifeq ($(findstring $(ARCH),'alpine'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/alpine/*.patch))
else ifeq ($(findstring $(ARCH),'armada370'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/armada370/*.patch))
else ifeq ($(findstring $(ARCH),'armada375'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/armada375/*.patch))
else ifeq ($(findstring $(ARCH),'armada38x'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/armada38x/*.patch))
else ifeq ($(findstring $(ARCH),'armadaxp'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/armadaxp/*.patch))
else ifeq ($(findstring $(ARCH),'comcerto2k'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/comcerto2k/*.patch))
else ifeq ($(findstring $(ARCH),'monaco'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/monaco/*.patch))
else ifeq ($(findstring $(ARCH),'hi3535'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/hi3535/*.patch))
else ifeq ($(findstring $(ARCH),'ipq806x'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/ipq806x/*.patch))
else ifeq ($(findstring $(ARCH),'northstarplus'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/northstarplus/*.patch))
else ifeq ($(findstring $(ARCH),'dakota'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/dakota/*.patch))
else
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch))
endif

else ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
ifeq ($(findstring $(ARCH),'rtd1296'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/rtd1296/*.patch))
else ifeq ($(findstring $(ARCH),'armada37xx'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/armada37xx/*.patch))
else ifeq ($(findstring $(ARCH),'aarch64'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch patches/aarch64/*.patch))
else
PATCHES = $(sort $(wildcard patches/*.patch patches/[aA][rR][mM]7/*.patch))
endif

else ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
ifeq ($(findstring $(ARCH),'powerpc'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[pP][pP][cC]/*.patch patches/powerpc/*.patch))
else ifeq ($(findstring $(ARCH),'ppc824x'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[pP][pP][cC]/*.patch patches/ppc824x/*.patch))
else ifeq ($(findstring $(ARCH),'ppc853x'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[pP][pP][cC]/*.patch patches/ppc853x/*.patch))
else ifeq ($(findstring $(ARCH),'ppc854x'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[pP][pP][cC]/*.patch patches/ppc854x/*.patch))
else ifeq ($(findstring $(ARCH),'qoriq'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[pP][pP][cC]/*.patch patches/qoriq/*.patch))
else
PATCHES = $(sort $(wildcard patches/*.patch patches/[pP][pP][cC]/*.patch))
endif

else ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
ifeq ($(findstring $(ARCH),'evansport'),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[xX]86/*.patch patches/evansport/*.patch))
else
PATCHES = $(sort $(wildcard patches/*.patch patches/[xX]86/*.patch))
endif

else ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
PATCHES = $(sort $(wildcard patches/*.patch patches/[xX]64/*.patch patches/[xX]86_64/*.patch))
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

