### Package Icon creation
#   Create package icons for SPK
#   Icons are created if DSM_UI_DIR is set in 
#   spk/Makefile, otherwise skipped.

# Targets are executed in the following order:
#  icon_msg_target
#  pre_icon_target   (override with PRE_ICON_TARGET)
#  build_icon_target (override with ICON_TARGET)
#  post_icon_target  (override with POST_ICON_TARGET)

ICON_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)icon_done

ifneq ($(strip $(DSM_UI_DIR)),)
ICON_DIR = $(STAGING_DIR)/$(DSM_UI_DIR)/images
endif

ifeq ($(strip $(PRE_ICON_TARGET)),)
PRE_ICON_TARGET = pre_icon_target
else
$(PRE_ICON_TARGET): icon_msg_target
endif
ifeq ($(strip $(ICON_TARGET)),)
ICON_TARGET = $(ICON_DIR)
else
$(ICON_TARGET): $(ICON_DIR)
endif
ifeq ($(strip $(POST_ICON_TARGET)),)
POST_ICON_TARGET = post_icon_target
else
$(POST_ICON_TARGET): $(ICON_TARGET)
endif

.PHONY: icon icon_msg
.PHONY: $(PRE_ICON_TARGET) $(ICON_TARGET) $(POST_ICON_TARGET)

icon_msg:
	@$(MSG) "Creating package icons for $(NAME)"

pre_icon_target: icon_msg

$(ICON_DIR): $(PRE_ICON_TARGET)
	@mkdir -p $@
	@for size in 16 24 32 48 64 72 256; do \
	  convert $(SPK_ICON) -thumbnail $${size}x$${size} -strip \
	          $@/$(SPK_NAME)-$${size}.png ; \
	done ; \

post_icon_target: $(ICON_TARGET)

ifeq ($(wildcard $(ICON_COOKIE)),)
icon: $(ICON_COOKIE)

$(ICON_COOKIE): $(POST_ICON_TARGET)
	$(create_target_dir)
	@touch -f $@
else
icon: ;
endif

