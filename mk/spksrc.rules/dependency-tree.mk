###############################################################################
# spksrc.dependency.mk
#
# Provides targets to inspect, traverse, and list package dependencies.
#
# Main features:
#  - Recursive dependency traversal with caching
#  - Parallel execution using GNU make job server
#  - Deterministic, sorted output
#  - Per-run temporary directories to avoid collisions
#
# Main Targets:
#  dependency-tree
#      Recursively prints a dependency tree. Indentation reflects the current
#      MAKELEVEL and visualizes dependency depth.
#
#  dependency-flat
#      Wrapper around dependency-flat-mk. Enables parallel execution and
#      automatically cleans up the dependency traversal cache on completion.
#
#  dependency-list
#      Prints a single-line, space-separated list of dependencies for the
#      current package, restricted to cross/python/native dependencies.
#      Output format:
#          $(NAME): cross/foo cross/bar native/baz ...
#
#  dependency-list-spk
#      Runs dependency-list for every package under spk/* in parallel and
#      aggregates the results into a sorted output.
#
# Supporting Targets:
#  dependency-flat-mk
#      Aggregates all dependencies for the current package by recursively
#      traversing BUILD, DEPENDS, NATIVE and OPTIONAL dependencies.
#
#  dep-flat-mk-%
#      Processes a single dependency. Each dependency is visited only once
#      per run, using stamp files stored in a temporary directory.
#
#  dependency-list-spk-%
#      Executes dependency-list for a single spk package. The output is written
#      to a per-run temporary file and later aggregated by dependency-list-spk.
#
# Variables:
#          ALL_DEPENDS: Sorted list of all dependencies (BUILD, DEPENDS, OPTIONAL).
#      ENCODED_DEPENDS: Dependency names encoded for Make targets (/ replaced by __).
#  DEP_FLAT_TARGETS_MK: List of dep-flat-mk-% targets generated from ALL_DEPENDS.
#               RUN_ID: Unique identifier for the current dependency traversal run.
#   DEP_FLAT_STAMP_DIR: Temporary directory used to cache visited dependencies during
#                       dependency-flat traversal.
#   SPK_LIST_STAMP_DIR: Temporary directory used to store per-package dependency-list output
#                       files during dependency-list-spk execution.
#
# Notes:
#  - Packages with conditional dependencies must define OPTIONAL_DEPENDS
#    to ensure all possible dependencies are discovered.
#  - All targets recursively invoke make. Makefiles must not abort or emit
#    errors when DEPENDENCY_WALK=1 is set (although errors redirected to /dev/null)
#  - Temporary directories are unique per run and removed automatically after completion.
#  - Avoids output interleaving to ensures safe parallelism.
###############################################################################

# -------------------------------------------------------------------
# Encode dependencies for Make targets (replace / with __)
# -------------------------------------------------------------------
ALL_DEPENDS         := $(sort $(NATIVE_DEPENDS) $(BUILD_DEPENDS) $(DEPENDS) $(OPTIONAL_DEPENDS))
ENCODED_DEPENDS     := $(subst /,__,$(ALL_DEPENDS))
DEP_FLAT_TARGETS_MK := $(addprefix dep-flat-mk-,$(ENCODED_DEPENDS))

# -------------------------------------------------------------------
# Root-level detection and spk package discovery
#
# When BASEDIR is empty, we are at the spksrc root directory.
# At root level, only dependency-list-spk should be available.
# In package directories, all other targets are exposed.
# -------------------------------------------------------------------
AT_ROOT_LEVEL := $(if $(BASEDIR),,1)

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
# dependency-flat
# Wrapper target enabling parallel traversal and automatic cleanup
# -------------------------------------------------------------------
.PHONY: dependency-flat
dependency-flat:
	@PARALLEL_MAKE=max $(MAKE) -j $(nproc) --silent --no-print-directory \
		dependency-flat-mk 2>/dev/null || true
	@rm -rf $(DEP_FLAT_STAMP_DIR)

# -------------------------------------------------------------------
# dependency-flat-mk
# Aggregates dependencies by invoking dep-flat-mk-% targets
# -------------------------------------------------------------------
.PHONY: dependency-flat-mk
dependency-flat-mk: $(DEP_FLAT_TARGETS_MK)
	@echo "$(CURDIR)" | grep -Po "/\K(spk|cross|python|native|diyspk|toolchain)/.*"

# -------------------------------------------------------------------
# dep-flat-mk-%
# Processes a single dependency and caches the result using a stamp file
# -------------------------------------------------------------------
.PHONY: dep-flat-mk-%
dep-flat-mk-%: | $(DEP_FLAT_STAMP_DIR)
	@stamp=$(DEP_FLAT_STAMP_DIR)/$*; \
	if [ -f $$stamp ]; then exit 0; fi; \
	touch $$stamp; \
	DEPENDENCY_WALK=1 \
	$(MAKE) -s --output-sync=target \
		-C ../../$(subst __,/,$*) dependency-flat-mk

# -------------------------------------------------------------------
# dependency-list
# Prints a sorted, unique list of cross/python/native dependencies
# -------------------------------------------------------------------
.PHONY: dependency-list
dependency-list:
	@echo -n "$(NAME): "
	@$(MAKE) -s dependency-flat \
		| grep -P "^(cross|python|native)" \
		| sort -u \
		| tr '\n' ' '
	@echo ""

# End of package-level targets
endif
