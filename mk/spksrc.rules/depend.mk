###############################################################################
# spksrc.rules/depend.mk
#
# Build all dependencies listed in DEPENDS.
#
# Targets are executed in the following order:
#  depend_msg_target
#  pre_depend_target   (override with PRE_DEPEND_TARGET)
#  depend_target       (override with DEPEND_TARGET)
#  post_depend_target  (override with POST_DEPEND_TARGET)
#
# Variables:
#  DEPENDS             List of dependencies to go through
#  REQUIRE_KERNEL      If set, will compile kernel modules and allow
#                      use of KERNEL_DIR
#  BUILD_DEPENDS       List of dependencies to go through, PLIST is ignored
#  NATIVE_DEPENDS      native/* to build INTO this package's own context
#
###############################################################################

### For managing kernel modules dependent builds
include ../../mk/spksrc.kernel/depend.mk

DEPEND_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)depend_done

# Stamps of the dependencies already walked during this run (dep_seen, macros.mk): a
# dependency shared by several packages is walked once, not once per path leading to it,
# each visit being a full make parse (and its cross-stage1/2 sub-makes) even when its
# cookies say there is nothing left to build.
#
# Bound to WORK_DIR rather than handed down: DEPEND_WALK carries the WORK_DIR of the make
# that started the walk. A sub-make building into another WORK_DIR (toolchain, toolkit)
# does not match it and starts a walk of its own, instead of skipping dependencies that
# were only built in its caller's. The owner of the walk clears the stamps first, so an
# interrupted or failed run never leaves one behind for the next.
DEPEND_SEEN = $(WORK_DIR)/.DEPEND
ifneq ($(DEPEND_WALK),$(WORK_DIR))
DEPEND_WALK_OWNER = 1
endif

ifeq ($(strip $(PRE_DEPEND_TARGET)),)
PRE_DEPEND_TARGET = pre_depend_target
else
$(PRE_DEPEND_TARGET): depend_msg_target
endif
ifeq ($(strip $(DEPEND_TARGET)),)
DEPEND_TARGET = depend_target
else
$(DEPEND_TARGET): $(PRE_DEPEND_TARGET)
endif
ifeq ($(strip $(POST_DEPEND_TARGET)),)
POST_DEPEND_TARGET = post_depend_target
else
$(POST_DEPEND_TARGET): $(DEPEND_TARGET)
endif

native-depend_msg_target:
	@$(MSG) "Processing NATIVE dependencies of $(NAME)"

# Called for 'make all-supported' prior to
# parallalizing build for every arch targets

# The env -i native loops (this one and depend_target's) stay without FWRD_ARGS: host tools,
# and the one that cares (native/rustc-1.98) sets a `?=` default a forwarded 0 would break.
native-depend: native-depend_msg_target
	@set -e; \
	for native in $$($(MAKE) -s dependency-flat DEPENDS_TYPE="DEPENDS BUILD_DEPENDS OPTIONAL_DEPENDS" | grep "^native/"); \
	do \
	  env -i PATH=$(PATH) LOG_DIR=$(LOG_DIR) $(MAKE) -C ../../$$native ; \
	done

# Build meta SOURCE packages (spk/*) listed in BUILD_DEPENDS. Invoked from
# spk-stage1 (spksrc.spk.mk) so the meta work dir exists for the stage2 parse
# that activates SPK_BASE_TEMPLATE. Only spk/* are built here (cross/* and
# native/* are built by depend_target below, which filters out spk/*). Each
# meta is a self-contained `arch-` build run under an isolated env (env -i) so
# the consumer's INSTALL_PREFIX/exports don't leak into it, and is skipped when
# its install staging already exists (re-running arch- on a built package is
# not idempotent at the packaging step). No-op when BUILD_DEPENDS has no spk/*.
#
# FWRD_ARGS crosses that isolation on purpose: those are decisions about the whole run,
# and a meta that disagrees links a libdrm the consumer then cannot resolve.
.PHONY: spk-meta-source
spk-meta-source:
	@set -e; \
	for metasrc in $(filter spk/%,$(BUILD_DEPENDS)); do \
	   if [ -d ../../$$metasrc/work-$(ARCH)-$(TCVERSION)/install ]; then \
	      $(MSG) "Stage1: meta source $$metasrc already built for $(ARCH)-$(TCVERSION)" ; \
	   else \
	      $(MSG) "Stage1: building meta source $$metasrc for $(ARCH)-$(TCVERSION)" ; \
	      env -i PATH="$(PATH)" HOME="$(HOME)" \
	         $(MAKE) $(FWRD_ARGS_SPK) --no-print-directory -C ../../$$metasrc arch-$(ARCH)-$(TCVERSION) ; \
	   fi ; \
	done

depend_msg_target:
	@$(MSG) "Processing dependencies of $(NAME)"

pre_depend_target: depend_msg_target

depend_target: $(PRE_DEPEND_TARGET)
ifneq ($(strip $(REQUIRE_KERNEL_MODULE)),)
# As depend is also ran at toolchain-time, ensure to skip kernel-depend
ifeq ($(filter toolchain,$(shell basename $(abspath $(CURDIR)/../))),)
depend_target: kernel-depend
endif
endif
	@set -e; \
	for native in $(filter native/%,$(BUILD_DEPENDS) $(DEPENDS)); \
	do \
	  env -i PATH=$(PATH) LOG_DIR=$(LOG_DIR) $(MAKE) -C ../../$$native ; \
	done
	@$(if $(DEPEND_WALK_OWNER),rm -rf $(DEPEND_SEEN) && mkdir -p $(DEPEND_SEEN),:)
	@set -e; \
	for depend in $(NATIVE_DEPENDS); \
	do \
	  $(call dep_seen,$(DEPEND_SEEN),$$depend) && continue ; \
	  env $(ENV) WORK_DIR=$(WORK_DIR) INSTALL_PREFIX=$(INSTALL_PREFIX) $(MAKE) DEPEND_WALK=$(WORK_DIR) $(FWRD_ARGS) -C ../../$$depend ; \
	done
	@set -e; \
	for depend in $(filter-out native/% spk/%,$(BUILD_DEPENDS) $(DEPENDS)); \
	do \
	  $(call dep_seen,$(DEPEND_SEEN),$$depend) && continue ; \
	  env $(ENV) $(MAKE) DEPEND_WALK=$(WORK_DIR) $(FWRD_ARGS) -C ../../$$depend ; \
	done
	@$(if $(DEPEND_WALK_OWNER),rm -rf $(DEPEND_SEEN),:)
	
post_depend_target: $(DEPEND_TARGET)

	
ifeq ($(wildcard $(DEPEND_COOKIE)),)
depend: $(DEPEND_COOKIE)

$(DEPEND_COOKIE): $(POST_DEPEND_TARGET)
	$(create_target_dir)
	@touch -f $@
else
depend: ;
endif
