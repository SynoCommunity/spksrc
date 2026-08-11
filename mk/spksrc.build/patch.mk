###############################################################################
# spksrc.build/patch.mk
#
# Apply local patch to a directory tree. Patches are applied from the software
#   directory, using patch -p0 <.
#
# Targets are executed in the following order:
#  patch_msg_target
#  pre_patch_target   (override with PRE_PATCH_TARGET)
#  patch_target       (override with PATCH_TARGET)
#  post_patch_target  (override with POST_PATCH_TARGET)
#
# Variables:
#  PATCHES_LEVEL      Level of the patches to apply (default = 0)
#  PATCHES            List of patches to apply. If not defined, will apply patch files in the
#                     patches directory.
#
# !!! WARNING -- patching is idempotent and MUST stay non-interactive !!!
#
#   patch_target is guarded by a cookie in WORK_DIR, but WORK_DIR is propagated
#   into a dependency's sub-make, so the SAME tree can legitimately reach this step
#   more than once (a toolchain resolved by two packages; the gcc8 overlay, whose
#   tcvars step depends on the patched base tree). On the second pass the tree is
#   already patched and GNU patch, left to itself, asks
#
#       "Reversed (or previously applied) patch detected!  Assume -R? [n]"
#
#   -- an interactive prompt that reads EOF under CI or the `script` log wrapper and
#   HANGS THE BUILD FOREVER (the arch then burns its whole time budget having built
#   nothing). So each patch is first tested with `patch -R --fuzz=0 --dry-run`: if it
#   reverses cleanly it is already applied and is skipped (with a loud warning);
#   otherwise it is applied with `--batch --forward`, which never stops to ask a
#   question. Do not remove --batch/--forward or the reverse-apply guard, and never
#   add a patch step that prompts.
#
#   --fuzz=0 on the detection dry-run is load-bearing, not cosmetic: GNU patch's
#   default fuzz (2) lets a hunk match on CONTEXT ALONE, ignoring some leading/
#   trailing lines of the hunk itself. A patch built entirely (or mostly) of
#   DELETED lines -- like cross/bzip2's, which strips a handful of hardcoded
#   CC/CFLAGS assignments -- can reverse-apply "successfully" against the
#   ORIGINAL, NEVER-PATCHED tree: with 2 lines of fuzz, patch drops enough of the
#   hunk to match on context alone and reports success. That is a false positive,
#   not the already-applied tree the check exists to detect, and it is silent: the
#   forward patch is skipped, the package builds against its unpatched upstream
#   Makefile (bzip2 keeps CC=gcc, which then resolves to the CI runner's own
#   compiler instead of the cross one -- objects it produces can be entirely the
#   wrong ABI for what the toolchain's linker expects). Reproduced directly: `patch
#   -p0 -R -f --dry-run` on a pristine bzip2-1.0.8 tree exits 0 ("Hunk #1 succeeded
#   ... with fuzz 2"); the same command with --fuzz=0 correctly exits 1, and still
#   exits 0 once the patch is genuinely applied -- an exact match, no fuzz needed,
#   is exactly what "already applied" means.
#
###############################################################################

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
PATCHES := $(call dedup-files,$(call uniq,$(realpath $(PATCHES))))

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
	  if cat $${patchfile} | ($(RUN) patch -p$(PATCHES_LEVEL) -R -f --fuzz=0 --dry-run) >/dev/null 2>&1 ; then \
	    echo "===> !!! WARNING !!! patch already applied on this tree -- skipping (a second pass reached an already-patched tree; not fatal, but see spksrc.build/patch.mk): $${patchfile}" ; \
	  else \
	    echo "patch -p$(PATCHES_LEVEL) < $${patchfile}" ; \
	    cat $${patchfile} | ($(RUN) patch -p$(PATCHES_LEVEL) --batch --forward) ; \
	  fi ; \
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
