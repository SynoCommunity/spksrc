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
#
# Root-level Targets (available only when BASEDIR is empty):
#  dependency-list-spk
#      Runs dependency-list for every package under spk/* in parallel and
#      aggregates the results into a sorted output.
#
# Package-level Targets (available inside cross|spk|diyspk|toolchain directories):
#  dependency-tree
#      Recursively prints a dependency tree. Indentation reflects MAKELEVEL
#      and visualizes dependency depth.  Unaffected by EXCLUDE_DEPENDS and
#      DEPENDS_TYPE.
#
#  dependency-flat
#      Returns a sorted, unique list of dependency paths (one per line),
#      filtered by DEPENDS_TYPE. Default: all types
#
#  dependency-list
#      Prints a single-line, space-separated list of dependencies for the
#      current package, filtered by DEPENDS_TYPE.  Default: all types
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
#      all types. Stamp is keyed on dep path only to avoid re-traversing;
#      if already stamped the type annotation is still emitted for this relation.
#
#  dependency-list-spk-%
#      Executes dependency-list for a single spk package. Output is written
#      to a temporary file and later aggregated by dependency-list-spk.
#
# Variables:
#          ALL_DEPENDS: Sorted union of all dependency types for traversal.
#  DEP_FLAT_TARGETS_MK: Annotated dep-flat-mk-% targets for all dependencies.
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
#                       Default: all types included.
#                       Traversal always visits all types regardless of this setting.
#
# Notes:
#  - Target availability depends on call context:
#        * Root level (BASEDIR empty): dependency-list-spk
#        * Package directories: dependency-tree, dependency-flat, dependency-list
#  - Packages with conditional dependencies must define OPTIONAL_DEPENDS
#    to ensure all possible dependencies are discovered.
#  - Recursive make calls must not abort when DEPENDENCY_WALK=1 is set
#    (errors are redirected to /dev/null).
#  - Temporary directories are unique per run and removed automatically.
#  - Output interleaving is avoided to ensure safe parallel execution.
###############################################################################

# Allows early access to stage0 environment
include ../../mk/spksrc.common.mk

# DEPENDS_TYPE filters output by dependency relation type.
# Traversal always visits all dependency types regardless of this setting.
# Values: DEPENDS BUILD_DEPENDS OPTIONAL_DEPENDS NATIVE_DEPENDS
# Can be combined: "DEPENDS OPTIONAL_DEPENDS"
# Default: all types included with exception of OPTIONAL_DEPEND if
#          ARCH and TCVERSION exists
_DEFAULT_DEPENDS_TYPE := DEPENDS BUILD_DEPENDS NATIVE_DEPENDS
ifeq (,$(and $(ARCH),$(TCVERSION)))
  _DEFAULT_DEPENDS_TYPE += OPTIONAL_DEPENDS
endif
DEPENDS_TYPE ?= $(_DEFAULT_DEPENDS_TYPE)

# -------------------------------------------------------------------
# ALL_DEPENDS: union of all dependency types — traversal is never filtered.
#
# DEP_FLAT_TARGETS_MK: annotated dep-flat-mk-% targets encoding relation
# type and dependency path:
#   dep-flat-mk-DEPENDS__cross__openssl3
#   dep-flat-mk-NATIVE_DEPENDS__native__nasm
# dep-flat-mk-% extracts the type and path from the target name and emits
# "TYPE dep/path" so dependency-flat and dependency-list can filter by
# DEPENDS_TYPE without re-traversing the graph.
#
# Also, if ARCH and TCVERSION are set then discard OPTIONAL_DEPENDS.
# -------------------------------------------------------------------
ALL_DEPENDS         := $(sort $(NATIVE_DEPENDS) $(BUILD_DEPENDS) $(DEPENDS) $(OPTIONAL_DEPENDS))
DEP_FLAT_TARGETS_MK := $(strip \
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

# At root level, only dependency-list-spk is available
.PHONY: dependency-list-spk
dependency-list-spk: | $(SPK_LIST_STAMP_DIR)
	@$(MAKE) -j $(nproc) --silent --no-print-directory $(SPK_TARGETS)
	@cat $(SPK_LIST_STAMP_DIR)/*.out | sort
	@rm -rf $(SPK_LIST_STAMP_DIR)

# -------------------------------------------------------------------
# dependency-list-spk-%
# Runs dependency-list for a single spk package and writes output to a file
# -------------------------------------------------------------------
.PHONY: dependency-list-spk-%
dependency-list-spk-%: | $(SPK_LIST_STAMP_DIR)
	@DEP_FLAT_RUN_ID=spk-$* \
	DEP_FLAT_STAMP_DIR=/tmp/spksrc-dep-$* \
	$(MAKE) -s --no-print-directory -C spk/$* dependency-list \
		> $(SPK_LIST_STAMP_DIR)/$*.out 2>/dev/null || true

else
# -------------------------------------------------------------------
# Package-level targets (only available inside package directories)
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# dependency-tree
# Recursively prints a dependency tree with indentation based on MAKELEVEL
# -------------------------------------------------------------------
.PHONY: dependency-tree
dependency-tree:
	@echo $$(perl -e 'print "\\\t" x $(MAKELEVEL),"\n"')+ $(NAME) $(PKG_VERS)
	@for depend in $$(echo "$(ALL_DEPENDS)" | tr ' ' '\n' | sort -u | tr '\n' ' ') ; \
	do \
	  DEPENDENCY_WALK=1 $(MAKE) -s -C ../../$$depend dependency-tree ; \
	done

# -------------------------------------------------------------------
# dependency-flat-raw
# Internal target. Traverses all dependency types in parallel and emits
# annotated lines "TYPE dep/path" via dep-flat-mk-% targets.
# Used by dependency-flat and dependency-list to filter by DEPENDS_TYPE
# without re-traversing the dependency graph.
# Cleans up the stamp directory on completion.
# -------------------------------------------------------------------
.PHONY: dependency-flat-raw
dependency-flat-raw:
	@PARALLEL_MAKE=max $(MAKE) -j $(nproc) --silent --no-print-directory \
		dependency-flat-mk 2>/dev/null || true
	@rm -rf $(DEP_FLAT_STAMP_DIR)

# -------------------------------------------------------------------
# dependency-flat
# Returns a sorted, unique list of dependency paths (one per line),
# filtered by DEPENDS_TYPE. Default: all types, identical to original.
# -------------------------------------------------------------------
.PHONY: dependency-flat
dependency-flat:
	@$(MAKE) -s dependency-flat-raw \
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
#  - Recursively invokes dependency-flat-mk in the dependency directory,
#    always traversing all types regardless of DEPENDS_TYPE.
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
		-C ../../$$dep dependency-flat-mk

# -------------------------------------------------------------------
# dependency-list
# Prints a single-line, space-separated list of dependencies filtered
# by DEPENDS_TYPE. Delegates to dependency-flat for traversal and filtering.
# Output format:
#     $(NAME): cross/foo cross/bar native/baz ...
# -------------------------------------------------------------------
.PHONY: dependency-list
dependency-list:
	@echo -n "$(NAME): "
	@$(MAKE) -s dependency-flat | tr '\n' ' '
	@echo ""

# End of package-level targets
endif
