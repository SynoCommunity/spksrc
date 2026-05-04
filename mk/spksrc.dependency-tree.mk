###############################################################################
# spksrc.dependency-tree.mk
#
# Provides targets to inspect, traverse, and list package dependencies.
#
# Main features:
#  - Recursive dependency traversal with caching
#  - Parallel execution using GNU make job server
#  - Deterministic, sorted output
#  - Per-run temporary directories to avoid collisions
#  - Optional dependency subtree exclusion
#  - Optional filtering of output by dependency relation type (DEPENDS_TYPE)
#  - Context-aware traversal: when ARCH and TCVERSION are both set, OPTIONAL_DEPENDS
#    are excluded at every level so only toolchain-resolved DEPENDS are reported.
#
# Root-level Targets (available only when BASEDIR is empty):
#  dependency-list-spk
#      Runs dependency-list for every package under spk/* in parallel and
#      aggregates the results into a sorted output.
#      When ARCH and TCVERSION are provided, each package is evaluated in
#      that toolchain context, yielding a resolved, arch-specific dependency list.
#
# Package-level Targets (available inside cross|spk|diyspk|toolchain directories):
#  dependency-tree
#      Recursively prints a dependency tree. Indentation reflects MAKELEVEL
#      and visualizes dependency depth.  Unaffected by EXCLUDE_DEPENDS and
#      DEPENDS_TYPE.
#
#  dependency-flat
#      Returns a sorted, unique list of dependency paths (one per line),
#      filtered by DEPENDS_TYPE.
#      Default: all types when ARCH/TCVERSION are absent;
#               OPTIONAL_DEPENDS excluded when both ARCH and TCVERSION are set.
#
#  dependency-list
#      Prints a single-line, space-separated list of dependencies for the
#      current package, filtered by DEPENDS_TYPE.
#      Output format:
#          $(NAME): cross/foo cross/bar native/baz ...
#
# Internal Supporting Targets:
#  dependency-flat-raw
#      Traverses all dependency types in parallel and emits annotated lines
#      "TYPE dep/path". Used internally by dependency-flat and dependency-list
#      to filter output by DEPENDS_TYPE without re-traversing the graph.
#      Cleans up the stamp directory on completion.
#
#  dependency-flat-mk
#      Parallel orchestrator — invokes all dep-flat-mk-% targets.
#      Emits nothing itself; all output comes from dep-flat-mk-% targets.
#
#  dep-flat-mk-%
#      Processes a single dependency during traversal.
#      Target name encodes the relation type and dependency path:
#          dep-flat-mk-DEPENDS__cross__openssl3
#          dep-flat-mk-NATIVE_DEPENDS__native__nasm
#      Emits "TYPE dep/path", then recurses into the dependency traversing
#      all applicable types. Stamp is keyed on dep path only to avoid
#      re-traversing; if already stamped the type annotation is still emitted
#      for this relation.
#      ARCH and TCVERSION are forwarded at every recursion level so that
#      conditional DEPENDS in sub-packages are evaluated in the correct
#      toolchain context.
#
#  dependency-list-spk-%
#      Executes dependency-list for a single spk package. Output is written
#      to a temporary file and later aggregated by dependency-list-spk.
#
# Variables:
#          ALL_DEPENDS: Sorted union of dependency types used for traversal.
#                       When ARCH and TCVERSION are both set, OPTIONAL_DEPENDS
#                       is excluded; otherwise all types are included.
#  DEP_FLAT_TARGETS_MK: Annotated dep-flat-mk-% targets for all dependencies.
#                       Uses deferred expansion (=) so that DEPENDS defined
#                       after the include of this file (e.g. in main-depends
#                       packages) are captured correctly at evaluation time.
#               RUN_ID: Unique identifier for the current dependency traversal run.
#   DEP_FLAT_STAMP_DIR: Temporary directory used to cache visited dependencies.
#                       Stamp files are named after the encoded dep path:
#                           /tmp/<RUN_ID>-dep-flat-mk/cross__openssl3
#                           /tmp/<RUN_ID>-dep-flat-mk/native__nasm
#                       Each stamp is an empty file — its presence means the
#                       dependency was already visited and recursed into.
#   SPK_LIST_STAMP_DIR: Temporary directory for per-package dependency-list output
#                       files during dependency-list-spk execution.
#      EXCLUDE_DEPENDS: Optional space-separated list of dependencies to ignore
#                       during traversal (e.g. "cross/ffmpeg7"). Excluded
#                       dependencies and their entire subtrees are skipped.
#         DEPENDS_TYPE: Filter output by dependency relation type.
#                       Values: DEPENDS BUILD_DEPENDS OPTIONAL_DEPENDS NATIVE_DEPENDS
#                       Can be combined: "DEPENDS OPTIONAL_DEPENDS"
#                       Default: all types when ARCH/TCVERSION absent;
#                                DEPENDS BUILD_DEPENDS NATIVE_DEPENDS when both set.
#                       Traversal always visits applicable types regardless of
#                       this setting.
#
# Notes:
#  - Target availability depends on call context:
#        * Root level (BASEDIR empty): dependency-list-spk
#        * Package directories: dependency-tree, dependency-flat, dependency-list
#  - When ARCH and TCVERSION are both provided, OPTIONAL_DEPENDS are suppressed
#    at every level of the traversal. Each package's conditional DEPENDS (e.g.
#    based on TC_GCC or TC_KERNEL) are resolved in that toolchain context,
#    producing an arch- and DSM-version-specific dependency list.
#  - When ARCH and TCVERSION are absent, OPTIONAL_DEPENDS are included to
#    ensure all possible dependencies across all toolchains are discovered.
#    Packages with conditional dependencies must define OPTIONAL_DEPENDS as a
#    superset of all possible DEPENDS variants for this to work correctly.
#  - Packages using spksrc.main-depends.mk that require toolchain macros
#    (version_ge, TC_GCC, TC_KERNEL, etc.) before their conditional DEPENDS
#    must include spksrc.common.mk early, then define their DEPENDS, and
#    include spksrc.main-depends.mk last. Example:
#        OPTIONAL_DEPENDS = cross/foo-latest cross/foo-1.0
#        include ../../mk/spksrc.common.mk
#        ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
#        DEPENDS = cross/foo-latest
#        else
#        DEPENDS = cross/foo-1.0
#        endif
#        include ../../mk/spksrc.main-depends.mk
#  - ALL_DEPENDS and DEP_FLAT_TARGETS_MK use deferred expansion (=) rather
#    than immediate expansion (:=) so that DEPENDS assigned after the include
#    of this file are visible when these variables are first used.
#  - ARCH and TCVERSION are explicitly forwarded to every recursive make call
#    so that sub-package Makefiles evaluate their conditional DEPENDS correctly.
#  - Recursive make calls must not abort when DEPENDENCY_WALK=1 is set
#    (errors are redirected to /dev/null).
#  - Temporary directories are unique per run and removed automatically.
#  - Output interleaving is avoided to ensure safe parallel execution.
###############################################################################

# Allows early access to stage0 environment
include $(BASEDIR)/mk/spksrc.common.mk

# DEPENDS_TYPE filters output by dependency relation type.
# Values: DEPENDS BUILD_DEPENDS OPTIONAL_DEPENDS NATIVE_DEPENDS
# Can be combined: "DEPENDS OPTIONAL_DEPENDS"
# Default: all types when ARCH and TCVERSION are absent.
#          When both ARCH and TCVERSION are set, OPTIONAL_DEPENDS is excluded
#          so that only toolchain-resolved DEPENDS are reported.
_DEFAULT_DEPENDS_TYPE := DEPENDS BUILD_DEPENDS NATIVE_DEPENDS
ifeq (,$(and $(ARCH),$(TCVERSION)))
  _DEFAULT_DEPENDS_TYPE += OPTIONAL_DEPENDS
endif
DEPENDS_TYPE ?= $(_DEFAULT_DEPENDS_TYPE)

# -------------------------------------------------------------------
# ALL_DEPENDS: union of dependency types used for traversal.
#   When ARCH and TCVERSION are both set, OPTIONAL_DEPENDS is excluded
#   so traversal follows only the resolved dependency graph for that
#   toolchain context.  When absent, all types are included to discover
#   every possible dependency across all toolchains.
#
# DEP_FLAT_TARGETS_MK: annotated dep-flat-mk-% targets encoding relation
#   type and dependency path:
#       dep-flat-mk-DEPENDS__cross__openssl3
#       dep-flat-mk-NATIVE_DEPENDS__native__nasm
#   dep-flat-mk-% extracts the type and path from the target name and emits
#   "TYPE dep/path" so dependency-flat and dependency-list can filter by
#   DEPENDS_TYPE without re-traversing the graph.
#
# Both variables use deferred expansion (=) rather than immediate (:=) so
# that DEPENDS defined after the include of this file — as is required for
# packages using spksrc.main-depends.mk — are visible when these variables
# are first evaluated (i.e. when dependency-flat-mk resolves its prerequisites).
# -------------------------------------------------------------------
ALL_DEPENDS         = $(sort $(NATIVE_DEPENDS) $(BUILD_DEPENDS) $(DEPENDS) $(if $(and $(ARCH),$(TCVERSION)),,$(OPTIONAL_DEPENDS)))
DEP_FLAT_TARGETS_MK = $(strip \
  $(addprefix dep-flat-mk-DEPENDS__,          $(subst /,__,$(DEPENDS))) \
  $(addprefix dep-flat-mk-BUILD_DEPENDS__,    $(subst /,__,$(BUILD_DEPENDS))) \
  $(addprefix dep-flat-mk-OPTIONAL_DEPENDS__, $(subst /,__,$(if $(and $(ARCH),$(TCVERSION)),,$(OPTIONAL_DEPENDS)))) \
  $(addprefix dep-flat-mk-NATIVE_DEPENDS__,   $(subst /,__,$(NATIVE_DEPENDS))))

# -------------------------------------------------------------------
# Root-level detection and spk package discovery
#
# AT_ROOT_LEVEL is set when BASEDIR resolves to the current directory,
# meaning make was invoked from the spksrc root. Comparison uses
# absolute paths to be independent of directory name.
#
# At root level, only dependency-list-spk is available.
# -------------------------------------------------------------------
AT_ROOT_LEVEL := $(if $(filter $(abspath $(BASEDIR)),$(CURDIR)),1,)

SPK_DIRS    := $(sort $(dir $(wildcard spk/*/Makefile)))
SPK_NAMES   := $(notdir $(patsubst %/,%,$(SPK_DIRS)))
SPK_TARGETS := $(addprefix dependency-list-spk-,$(SPK_NAMES))

# -------------------------------------------------------------------
# Per-run temporary directories
# -------------------------------------------------------------------
ifndef RUN_ID
RUN_ID              := $(shell mktemp -u spksrc-dependency-tree-XXXXXXXX)
DEP_FLAT_STAMP_DIR  := /tmp/$(RUN_ID)-dep-flat-mk
SPK_LIST_STAMP_DIR  := /tmp/$(RUN_ID)-spk-list

export RUN_ID
export DEP_FLAT_STAMP_DIR
export SPK_LIST_STAMP_DIR
endif

# Ensure dependency traversal stamp directory exists
$(DEP_FLAT_STAMP_DIR):
	@mkdir -p $@

# Ensure per-spk output directory exists
$(SPK_LIST_STAMP_DIR):
	@mkdir -p $@

# -------------------------------------------------------------------
# Root-level only targets
# -------------------------------------------------------------------
ifeq ($(AT_ROOT_LEVEL),1)

# At root level, only dependency-list-spk is available.
# ARCH and TCVERSION are forwarded when provided so each package is
# evaluated in the correct toolchain context.
.PHONY: dependency-list-spk
dependency-list-spk: | $(SPK_LIST_STAMP_DIR)
	@$(MAKE) -j $(nproc) --silent --no-print-directory \
		$(if $(ARCH),ARCH=$(ARCH)) \
		$(if $(TCVERSION),TCVERSION=$(TCVERSION)) \
		$(SPK_TARGETS)
	@cat $(SPK_LIST_STAMP_DIR)/*.out | sort
	@rm -rf $(SPK_LIST_STAMP_DIR)

# -------------------------------------------------------------------
# dependency-list-spk-%
# Runs dependency-list for a single spk package and writes output to a file.
# ARCH and TCVERSION are forwarded so the package Makefile resolves its
# conditional DEPENDS in the correct toolchain context.
# -------------------------------------------------------------------
.PHONY: dependency-list-spk-%
dependency-list-spk-%: | $(SPK_LIST_STAMP_DIR)
	@DEP_FLAT_RUN_ID=spk-$* \
	DEP_FLAT_STAMP_DIR=/tmp/spksrc-dep-$* \
	$(MAKE) -s --no-print-directory -C spk/$* \
		$(if $(ARCH),ARCH=$(ARCH)) \
		$(if $(TCVERSION),TCVERSION=$(TCVERSION)) \
		dependency-list \
		> $(SPK_LIST_STAMP_DIR)/$*.out 2>/dev/null || true

else
# -------------------------------------------------------------------
# Package-level targets (only available inside package directories)
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# dependency-tree
# Recursively prints a dependency tree with indentation based on MAKELEVEL.
# ARCH and TCVERSION are forwarded at each level so conditional DEPENDS
# in sub-packages are evaluated in the correct toolchain context.
# -------------------------------------------------------------------
.PHONY: dependency-tree
dependency-tree:
	@echo $$(perl -e 'print "\\\t" x $(MAKELEVEL),"\n"')+ $(NAME) $(PKG_VERS)
	@for depend in $$(echo "$(ALL_DEPENDS)" | tr ' ' '\n' | sort -u | tr '\n' ' ') ; \
	do \
	  DEPENDENCY_WALK=1 $(MAKE) -s -C ../../$$depend \
	      $(if $(ARCH),ARCH=$(ARCH)) \
	      $(if $(TCVERSION),TCVERSION=$(TCVERSION)) \
	      dependency-tree ; \
	done

# -------------------------------------------------------------------
# dependency-flat-raw
# Internal target. Traverses all applicable dependency types in parallel
# and emits annotated lines "TYPE dep/path" via dep-flat-mk-% targets.
# Used by dependency-flat and dependency-list to filter by DEPENDS_TYPE
# without re-traversing the dependency graph.
# ARCH and TCVERSION are forwarded to dependency-flat-mk so that the
# correct set of dependencies is traversed for the given toolchain context.
# Cleans up the stamp directory on completion.
# -------------------------------------------------------------------
.PHONY: dependency-flat-raw
dependency-flat-raw:
	@PARALLEL_MAKE=max $(MAKE) -j $(nproc) --silent --no-print-directory \
		$(if $(ARCH),ARCH=$(ARCH)) \
		$(if $(TCVERSION),TCVERSION=$(TCVERSION)) \
		dependency-flat-mk 2>/dev/null || true
	@rm -rf $(DEP_FLAT_STAMP_DIR)

# -------------------------------------------------------------------
# dependency-flat
# Returns a sorted, unique list of dependency paths (one per line),
# filtered by DEPENDS_TYPE.
# Default: all types when ARCH/TCVERSION are absent;
#          OPTIONAL_DEPENDS excluded when both ARCH and TCVERSION are set.
# -------------------------------------------------------------------
.PHONY: dependency-flat
dependency-flat:
	@$(MAKE) -s \
		$(if $(ARCH),ARCH=$(ARCH)) \
		$(if $(TCVERSION),TCVERSION=$(TCVERSION)) \
		dependency-flat-raw \
		| awk -v types=" $(DEPENDS_TYPE) " ' \
		  /^(DEPENDS|BUILD_DEPENDS|OPTIONAL_DEPENDS|NATIVE_DEPENDS) / { \
		    if (index(types, " " $$1 " ") > 0) print $$2 \
		  }' \
		| grep -P "^(cross|python|native|spk|diyspk)/" \
		| sort -u

# -------------------------------------------------------------------
# dependency-flat-mk
# Parallel orchestrator — invokes all annotated dep-flat-mk-% targets.
# Emits nothing itself; all output comes from dep-flat-mk-% targets.
# -------------------------------------------------------------------
.PHONY: dependency-flat-mk
dependency-flat-mk: $(DEP_FLAT_TARGETS_MK)

# -------------------------------------------------------------------
# dep-flat-mk-%
# Processes a single dependency during traversal.
#
#  - Extracts dep_type (DEPENDS, BUILD_DEPENDS, etc.) from target name.
#  - Extracts dep path by stripping the type prefix and decoding __ -> /.
#  - Skips the dependency if it appears in EXCLUDE_DEPENDS.
#  - Emits "TYPE dep/path" for filtering by dependency-flat/dependency-list.
#  - Uses a stamp file keyed on dep path to avoid re-traversing;
#    if already stamped, the type annotation is still emitted for this relation.
#    Stamp file structure (empty file, presence = visited):
#        $(DEP_FLAT_STAMP_DIR)/cross__openssl3
#        $(DEP_FLAT_STAMP_DIR)/native__nasm
#  - Recursively invokes dependency-flat-mk in the dependency directory.
#    ARCH and TCVERSION are forwarded so each sub-package evaluates its own
#    conditional DEPENDS in the correct toolchain context, and excludes its
#    own OPTIONAL_DEPENDS when the context is set.
# -------------------------------------------------------------------
.PHONY: dep-flat-mk-%
dep-flat-mk-%: | $(DEP_FLAT_STAMP_DIR)
	@raw=$*; \
	dep_type=$$(echo "$$raw" | grep -Po '^(DEPENDS|BUILD_DEPENDS|OPTIONAL_DEPENDS|NATIVE_DEPENDS)'); \
	dep=$$(echo "$$raw" | sed "s/^$${dep_type}__//" | sed 's/__/\//g'); \
	case " $(EXCLUDE_DEPENDS) " in \
	   *" $$dep "*) exit 0 ;; \
	esac; \
	echo "$${dep_type} $${dep}"; \
	stamp="$(DEP_FLAT_STAMP_DIR)/$$(echo $$dep | sed 's|/|__|g')"; \
	if [ -f "$$stamp" ]; then exit 0; fi; \
	touch "$$stamp"; \
	DEPENDENCY_WALK=1 \
	$(MAKE) -s --output-sync=target \
		-C ../../$$dep \
		$(if $(ARCH),ARCH=$(ARCH)) \
		$(if $(TCVERSION),TCVERSION=$(TCVERSION)) \
		dependency-flat-mk

# -------------------------------------------------------------------
# dependency-list
# Prints a single-line, space-separated list of dependencies filtered
# by DEPENDS_TYPE. Delegates to dependency-flat for traversal and filtering.
# ARCH and TCVERSION are forwarded so the correct dependency graph is used.
# Output format:
#     $(NAME): cross/foo cross/bar native/baz ...
# -------------------------------------------------------------------
.PHONY: dependency-list
dependency-list:
	@echo -n "$(NAME): "
	@$(MAKE) -s \
	    $(if $(ARCH),ARCH=$(ARCH)) \
	    $(if $(TCVERSION),TCVERSION=$(TCVERSION)) \
	    dependency-flat | tr '\n' ' '
	@echo ""

# End of package-level targets
endif
