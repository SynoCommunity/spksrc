###############################################################################
# spksrc.dependency.mk
#
# Provides targets to inspect, traverse, and list package dependencies.
#
# Targets:
#  dependency-flat-mk       : Aggregates dependencies for the current package.
#  dep-flat-mk-%            : Single dependency target with caching in /tmp.
#  dependency-flat          : Wrapper around dependency-flat-mk with automatic cleanup.
#  dependency-list          : Prints a single-line list of all dependencies
#                             (cross/native only, sorted, unique).
#  dependency-tree          : Recursively prints a tree of dependencies
#                             with indentation representing depth.
#
# Variables:
#  ALL_DEPENDS             : Sorted list of all dependencies (BUILD, DEP, OPTIONAL)
#  ENCODED_DEPENDS         : Dependency names encoded for Make targets (/ → __)
#  DEP_FLAT_TARGETS_MK     : List of dep-flat-mk targets
#  DEP_FLAT_RUN_ID         : Unique identifier for this dependency traversal run
#  DEP_FLAT_STAMP_DIR      : Temporary directory for caching visited dependencies
#
# Notes:
#  - Packages with conditional dependencies must define OPTIONAL_DEPENDS to
#    ensure all dependencies are found.
#  - All targets recursively call make; therefore, Makefiles must not abort
#    or print errors/warnings when DEPENDENCY_WALK=1.
#  - dep-flat-mk-% targets use stamp files in /tmp to avoid repeated traversal.
#  - dependency-flat automatically cleans up the stamp directory after execution.
#  - dependency-list prints dependencies in the format:
#       $(NAME): cross/foo cross/bar native/baz ...
#  - dependency-tree prints a hierarchical tree of dependencies with indentation.
###############################################################################

# -------------------------------------------------------------------
# Encode dependencies for Make targets (replace / → __)
# -------------------------------------------------------------------
ALL_DEPENDS         := $(sort $(NATIVE_DEPENDS) $(BUILD_DEPENDS) $(DEPENDS) $(OPTIONAL_DEPENDS))
ENCODED_DEPENDS     := $(subst /,__,$(ALL_DEPENDS))
DEP_FLAT_TARGETS_MK := $(addprefix dep-flat-mk-,$(ENCODED_DEPENDS))

# -------------------------------------------------------------------
# Stamp directory for caching processed dependencies
# -------------------------------------------------------------------
ifndef DEP_FLAT_RUN_ID
DEP_FLAT_RUN_ID     := $(shell mktemp -u spksrc-dep-flat-mk-XXXXXXXX)
DEP_FLAT_STAMP_DIR  := /tmp/$(DEP_FLAT_RUN_ID)
export DEP_FLAT_STAMP_DIR
export DEP_FLAT_RUN_ID
endif

# Ensure stamp directory exists
$(DEP_FLAT_STAMP_DIR):
	@mkdir -p $@

# -------------------------------------------------------------------
# dependency-flat wrapper
# - calls dependency-flat-mk
# - cleans up stamp cache in /tmp after execution
# -------------------------------------------------------------------
.PHONY: dependency-flat
dependency-flat:
	@$(MAKE) -s dependency-flat-mk 2>/dev/null || true
	@rm -rf $(DEP_FLAT_STAMP_DIR)

# -------------------------------------------------------------------
# dependency-list
# - prints final list of dependencies (cross|native only)
# -------------------------------------------------------------------
.PHONY: dependency-list
dependency-list:
	@echo -n "$(NAME): "
	@$(MAKE) -s dependency-flat | grep -P "^(cross|python|native)" | sort -u | tr '\n' ' '
	@echo ""

# -------------------------------------------------------------------
# dependency-flat-mk
# - aggregator target
# - calls each dependency once
# -------------------------------------------------------------------
.PHONY: dependency-flat-mk
dependency-flat-mk: $(DEP_FLAT_TARGETS_MK)
	@echo "$(CURDIR)" | grep -Po "/\K(spk|cross|python|native|diyspk|toolchain)/.*"

# -------------------------------------------------------------------
# Each dependency = one target (cached in /tmp)
# -------------------------------------------------------------------
.PHONY: dep-flat-mk-%
dep-flat-mk-%: | $(DEP_FLAT_STAMP_DIR)
	@stamp=$(DEP_FLAT_STAMP_DIR)/$*; \
	if [ -f $$stamp ]; then \
	  exit 0; \
	fi; \
	touch $$stamp; \
	DEPENDENCY_WALK=1 \
	$(MAKE) -s --output-sync=target -C ../../$(subst __,/,$*) dependency-flat-mk

# -------------------------------------------------------------------
# dependency-tree
# - recursively prints a tree of package dependencies
# - indentation corresponds to MAKELEVEL
# -------------------------------------------------------------------
.PHONY: dependency-tree
dependency-tree:
	@echo $$(perl -e 'print "\\\t" x $(MAKELEVEL),"\n"')+ $(NAME) $(PKG_VERS)
	@for depend in $$(echo "$(BUILD_DEPENDS) $(DEPENDS) $(OPTIONAL_DEPENDS)" | tr ' ' '\n' | sort -u | tr '\n' ' ') ; \
	do \
	  DEPENDENCY_WALK=1 $(MAKE) -s -C ../../$$depend dependency-tree ; \
	done
