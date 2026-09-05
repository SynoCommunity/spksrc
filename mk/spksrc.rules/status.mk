###############################################################################
# spksrc.rules/status.mk
#
# Build status tracking: a placeholder target that records already-processed
# dependencies while walking the dependency tree, to avoid repeating them in
# $(STATUS_LOG).
#
# Targets are executed in the following order:
#  pre_status_target    (override with PRE_STATUS_TARGET)
#  status_target        (override with STATUS_TARGET)
#  post_status_target   (override with POST_STATUS_TARGET)
###############################################################################

STATUS_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)status_done

ifeq ($(strip $(PRE_STATUS_TARGET)),)
PRE_STATUS_TARGET = pre_status_target
else
$(PRE_STATUS_TARGET): status_msg
endif
ifeq ($(strip $(STATUS_TARGET)),)
STATUS_TARGET = status_target
else
$(STATUS_TARGET): $(PRE_STATUS_TARGET)
endif
ifeq ($(strip $(POST_STATUS_TARGET)),)
POST_STATUS_TARGET = post_status_target
else
$(POST_STATUS_TARGET): $(STATUS_TARGET)
endif

.PHONY: status
.PHONY: $(PRE_STATUS_TARGET) $(STATUS_TARGET) $(POST_STATUS_TARGET)

pre_status_target:

status_target:  $(PRE_STATUS_TARGET)
ifeq ($(notdir $(abspath $(CURDIR)/..)),native)
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "native" "$(NAME)") | tee --append $(STATUS_LOG)
else ifeq ($(notdir $(abspath $(CURDIR)/..)),toolchain)
	@# The directory name carries the whole identity, overlays included: syno-aarch64-6.2.4
	@# -> aarch64-6.2.4, syno-qoriq-6.2.4_rust-1.82_gcc-4.9.3 -> qoriq-6.2.4_rust-1.82_gcc-4.9.3.
	@# TC_NAME/TC_ARCH cannot do this: a consumer sets no TC_NAME, and on the generic toolchains
	@# TC_ARCH is the reference model (rtd1296, apollolake) rather than the arch name.
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(patsubst syno-%,%,$(notdir $(CURDIR)))" "toolchain") | tee --append $(STATUS_LOG)
else ifeq ($(notdir $(abspath $(CURDIR)/..)),toolkit)
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(lastword $(subst -, ,$(TK_NAME)))-$(TK_VERS)" "toolkit") | tee --append $(STATUS_LOG)
else ifeq ($(notdir $(abspath $(CURDIR)/..)),kernel)
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(lastword $(subst -, ,$(KERNEL_NAME)))-$(KERNEL_VERS)" "kernel") | tee --append $(STATUS_LOG)
else
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(ARCH)-$(TCVERSION)" "$(NAME)") | tee --append $(STATUS_LOG)
endif

post_status_target: $(STATUS_TARGET)

ifeq ($(wildcard $(STATUS_COOKIE)),)
status: $(STATUS_COOKIE)

$(STATUS_COOKIE): $(POST_STATUS_TARGET)
	$(create_target_dir)
	@touch -f $@
else
status: ;
endif

