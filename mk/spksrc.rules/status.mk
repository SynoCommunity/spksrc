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

# "GCC: <version> (overlay|legacy)" naming the compiler this build actually used.
#
# Stated in the positive for both modes rather than only marking the overlay: a
# reader should not have to infer "legacy" from the absence of a field. Reading a
# dependency chain then shows, line by line, which compiler each one got -- and
# since the whole chain is pinned to one, an odd line out is a bug worth seeing.
#
# TC_GCC_EFFECTIVE (the version) and TC_GCC_IS_OVERLAY (the mode) both come from
# tc-capability.mk and are known statically, before anything is built. That matters
# here: the status line is printed while WALKING the dependency tree, before each
# package's tc_vars.mk exists -- so TC_GCC / TC_GCC_SUFFIX read back stale or empty
# (an overlay build logging "4.3.2 (legacy)", or no field at all), while the static
# pair is always right. The field disappears where no cross compiler is involved
# (native, toolchain) -- TC_GCC_EFFECTIVE is empty there -- rather than blank.
#
# _status_comma: a literal comma cannot be written inside $(if ...) -- make reads it
# as an argument separator.
_status_comma := ,
STATUS_GCC = $(shell printf '%-23s' "$(if $(strip $(TC_GCC_EFFECTIVE)),GCC: $(strip $(TC_GCC_EFFECTIVE)) ($(if $(strip $(TC_GCC_IS_OVERLAY)),overlay,legacy))$(_status_comma))")

# The arch label is STATUS_ARCH (logs.mk), which also names the log file -- logs.mk
# says the two "can never disagree", and they did: every branch below re-derived the
# label by hand, and the toolchain one dropped STATUS_ARCH's fallback to TC_ARCH. An
# overlay package sets TC_ARCH but no TC_NAME, so it logged "ARCH: -6.2.4". Derive it
# once, in the place that already owns it.
#
# Widths: 18 is the longest arch-vers in the tree (broadwellntbap-7.3) and 22 the
# widest GCC field (gcc 12 on the overlay), both plus their comma. Padding is why the
# printf output must be quoted when handed to MSG -- unquoted, the shell word-splits
# it and collapses exactly the spaces being added.
STATUS_NAME = $(NAME)
ifeq ($(notdir $(abspath $(CURDIR)/..)),toolchain)
STATUS_NAME = toolchain
else ifeq ($(notdir $(abspath $(CURDIR)/..)),toolkit)
STATUS_NAME = toolkit
else ifeq ($(notdir $(abspath $(CURDIR)/..)),kernel)
STATUS_NAME = kernel
endif

status_target:  $(PRE_STATUS_TARGET)
	@$(MSG) "$$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, %sARCH: %-19s NAME: %s" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(STATUS_GCC)" "$(STATUS_ARCH)$(_status_comma)" "$(STATUS_NAME)")" | tee --append $(STATUS_LOG)

post_status_target: $(STATUS_TARGET)

ifeq ($(wildcard $(STATUS_COOKIE)),)
status: $(STATUS_COOKIE)

$(STATUS_COOKIE): $(POST_STATUS_TARGET)
	$(create_target_dir)
	@touch -f $@
else
status: ;
endif

