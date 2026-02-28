###############################################################################
# spksrc.toolkit/tk_vars.mk
#
# This makefile generates the toolkit-specific environment definition file
# $(WORK_DIR)/tk_vars.mk used by spksrc cross-compilation stages.
#
# It is responsible for:
#  - emitting Makefile fragments (tk_vars.mk) consumed by cross-env.mk
#
# The tk_vars.mk file is generated once per toolkit and cached using a
# status cookie to avoid unnecessary regeneration.
#
# Generated files:
#  $(WORK_DIR)/tk_vars.mk
#      Core toolkit metadata and paths
#
# Targets are executed in the following order:
#  tkvars_msg
#  pre_tkvars_target    (override with PRE_TKVARS_TARGET)
#  tkvars_target        (override with TKVARS_TARGET)
#  post_tkvars_target   (override with POST_TKVARS_TARGET)
#
# Variables:
#  TKVARS_COOKIE    : Status cookie indicating tk_vars generation completion
#  TKVARS_SUBMAKE   : Internal flag to avoid recursive default goal execution
#
# Notes:
#  - This makefile only emits configuration files; it does not build anything.
#  - All output is written to $(WORK_DIR).
#  - tk_vars.mk is consumed by spksrc.cross-env.mk and package builds.
#  - The tkvars target is idempotent and skipped if the cookie exists.
#
###############################################################################

# Variables
COOKIE_PREFIX =

# Mark tk_vars generation as completed using status cookie
TKVARS_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)tkvars_done

#####

# Avoid looping when calling itself
ifeq ($(TKVARS_SUBMAKE),1)
.DEFAULT_GOAL :=
else
.DEFAULT_GOAL := tkvars
endif

#####

# Mappings (target_name:output_file)
TK_VAR_MAPPING_MK = tk_vars:tk_vars.mk

# Common variables to simply calls
# (e.g. direct call such as 'make work/tk_vars.mk')
TK_VARS_MK           = $(WORK_DIR)/tk_vars.mk

# Template to generate toolchain rule
define make_tk_var_rule
$(WORK_DIR)/$(2):
	@$(MSG) "Generating $(WORK_DIR)/$(2)"
	@mkdir -p $(WORK_DIR)
	@$(MAKE) --no-print-directory \
		-f Makefile \
		TKVARS_SUBMAKE=1 \
		$(1) > $$@
endef

# Generate all .mk files
$(foreach mapping,$(TK_VAR_MAPPING_MK),\
  $(eval $(call make_tk_var_rule,$(word 1,$(subst :, ,$(mapping))),$(word 2,$(subst :, ,$(mapping))))))

# Grouped targets to generate multiple files
.PHONY: generate_tk_vars_mk
generate_tk_vars_mk: $(foreach m,$(TK_VAR_MAPPING_MK),$(WORK_DIR)/$(word 2,$(subst :, ,$(m))))

#####

.PHONY: $(PRE_TKVARS_TARGET) $(TKVARS_TARGET) $(POST_TKVARS_TARGET)
ifeq ($(strip $(PRE_TKVARS_TARGET)),)
PRE_TKVARS_TARGET = pre_tkvars_target
else
$(PRE_TKVARS_TARGET): tkvars_msg
endif
ifeq ($(strip $(TKVARS_TARGET)),)
TKVARS_TARGET = tkvars_target
else
$(TKVARS_TARGET): $(PRE_TKVARS_TARGET)
endif
ifeq ($(strip $(POST_TKVARS_TARGET)),)
POST_TKVARS_TARGET = post_tkvars_target
else
$(POST_TKVARS_TARGET): $(TKVARS_TARGET)
endif

.PHONY: tkvars_msg
tkvars_msg:
	@$(MSG) "Generating toolkit cross-compilation configuration files for $(or $(lastword $(subst -, ,$(TK_NAME))),$(TK_ARCH))-$(TK_VERS)"

#####

pre_tkvars_target: tkvars_msg

.PHONY: tkvars_target
tkvars_target: $(TK_VARS_MK)

post_tkvars_target: $(TKVARS_TARGET)

#####

.PHONY: tk_vars
tk_vars:
	@echo TK_TYPE := $(TK_TYPE) ; \
	echo TK_WORK_DIR := $(TK_WORK_DIR) ; \
	echo TK_SYSROOT := $(TK_WORK_DIR)/$(TK_PREFIX)/$(TK_SYSROOT) ; \
	echo TK_TARGET := $(TK_TARGET) ; \
	echo TK_PATH := $(TK_WORK_DIR)/$(TK_PREFIX)/$(TK_PATH) ; \
	echo TK_INCLUDE := $(TK_INCLUDE) ; \
	echo TK_LIBRARY := $(TK_LIBRARY) ; \
	echo TK_VERS := $(TK_VERS) ; \
	echo TK_ARCH := $(TK_ARCH)

#####

ifeq ($(wildcard $(TKVARS_COOKIE)),)
tkvars: generate_tk_vars_mk $(TKVARS_COOKIE)

$(TKVARS_COOKIE): $(POST_TKVARS_TARGET)
	$(create_target_dir)
	@touch -f $@

else
tkvars: ;
endif
