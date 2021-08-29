### Compile rules
#   Invoke make to (cross-) compile the software.
# Target are executed in the following order:
#  compile_msg_target
#  pre_compile_target   (override with PRE_COMPILE_TARGET)
#  compile_target       (override with COMPILE_TARGET)
#  post_compile_target  (override with POST_COMPILE_TARGET)

.PARALLEL:

# Set parallel options in caller
ifneq ($(PARALLEL_MAKE),nop)
ifeq ($(call version_ge, ${MAKELEVEL}, 2),1)
MAKEFLAGS += -j$(NCPUS)
endif
endif

COMPILE_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)compile_done

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
ifneq ($(filter 1 on ON,$(PSTAT)),)
	@$(MSG) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $(ARCH)-$(TCVERSION) >> $(PSTAT_LOG)
endif

pre_compile_target: compile_msg

compile_target:  $(PRE_COMPILE_TARGET)
	@$(RUN) $(MAKE) $(COMPILE_MAKE_OPTIONS)

post_compile_target: $(COMPILE_TARGET)

ifeq ($(wildcard $(COMPILE_COOKIE)),)
compile: $(COMPILE_COOKIE)

$(COMPILE_COOKIE): $(POST_COMPILE_TARGET)
	$(create_target_dir)
	@touch -f $@
else
compile: ;
endif
