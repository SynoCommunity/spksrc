###############################################################################
# spksrc.build/compile.mk
#
# Invoke make to (cross-) compile the software.
#
# Targets are executed in the following order:
#  compile_msg_target
#  pre_compile_target      (override with PRE_COMPILE_TARGET)
#  compile_target          (override with COMPILE_TARGET)
#  post_compile_target     (override with POST_COMPILE_TARGET)
#
# Variables:
#  COMPILE_ARGS            Extra arguments for the compile step. Replaces the
#                          make command for autotools/plain make; appended as-is
#                          to cmake --build and ninja.
#
###############################################################################

COMPILE_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)compile_done

# Sensible default for the classic gnu-make build path only (not cmake/meson,
# selected via DEFAULT_ENV): parallel jobs. This gives COMPILE_ARGS a usable
# value so package-specific make routines can simply reference $(COMPILE_ARGS)
# and inherit -j (e.g. cross/cairo-1.16, cross/glibc-*).
ifeq ($(filter cmake meson,$(DEFAULT_ENV)),)
COMPILE_ARGS ?= $(if $(filter $(NCPUS),0 1),,-j$(NCPUS))
endif

ifeq ($(strip $(PRE_COMPILE_TARGET)),)
PRE_COMPILE_TARGET = pre_compile_target
else
$(PRE_COMPILE_TARGET): compile_msg
endif
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = compile_target
else
$(COMPILE_TARGET): $(PRE_COMPILE_TARGET)
endif
ifeq ($(strip $(POST_COMPILE_TARGET)),)
POST_COMPILE_TARGET = post_compile_target
else
$(POST_COMPILE_TARGET): $(COMPILE_TARGET)
endif

.PHONY: compile compile_msg
.PHONY: $(PRE_COMPILE_TARGET) $(COMPILE_TARGET) $(POST_COMPILE_TARGET)

compile_msg:
	@$(MSG) "Compiling for $(NAME)"

pre_compile_target: compile_msg

compile_target:  $(PRE_COMPILE_TARGET)
ifeq ($(filter $(NCPUS),0 1),)
	@$(BUILD_RUN) $(MAKE) $(if $(findstring -j,$(COMPILE_ARGS)),,-j$(NCPUS)) $(COMPILE_ARGS)
else
	@$(BUILD_RUN) $(MAKE) $(COMPILE_ARGS)
endif


post_compile_target: $(COMPILE_TARGET)

ifeq ($(wildcard $(COMPILE_COOKIE)),)
compile: $(COMPILE_COOKIE)

$(COMPILE_COOKIE): $(POST_COMPILE_TARGET)
	$(create_target_dir)
	@touch -f $@
else
compile: ;
endif
