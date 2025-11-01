### Status rules
# Only serves as a placeholder to avoid repetition of
# already processed dependencies when running through
# the dependency tree and printing to $(STATUS_LOG)
# 
# Targets are executed in the following order:
#  pre_status_target    (override with PRE_STATUS_TARGET)
#  status_target        (override with STATUS_TARGET)
#  post_status_target   (override with POST_STATUS_TARGET)
# Variables: none

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
ifeq ($(strip $(ARCH)),)
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "native" "$(NAME)") | tee --append $(STATUS_LOG)
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

