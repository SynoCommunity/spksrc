### Toolkit fix rules
#   Invoke fixes toolkit's libtool files
# Target are executed in the following order:
#  toolkit_fix_msg_target
#  pre_toolkit_fix_target   (override with PRE_FIX_TARGET)
#  toolkit_fix_target       (override with FIX_TARGET)
#  post_toolkit_fix_target  (override with POST_FIX_TARGET)

FIX_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)fix_done

ifeq ($(strip $(PRE_FIX_TARGET)),)
PRE_FIX_TARGET = pre_toolkit_fix_target
else
$(PRE_FIX_TARGET): toolkit_fix_msg
endif
ifeq ($(strip $(FIX_TARGET)),)
FIX_TARGET = toolkit_fix_target
else
$(FIX_TARGET): $(PRE_FIX_TARGET)
endif
ifeq ($(strip $(POST_FIX_TARGET)),)
POST_FIX_TARGET = post_toolkit_fix_target
else
$(POST_FIX_TARGET): $(FIX_TARGET)
endif

.PHONY: toolkit_fix toolkit_fix_msg
.PHONY: $(PRE_FIX_TARGET) $(FIX_TARGET) $(POST_FIX_TARGET)

toolkit_fix_msg:
	@$(MSG) "Fixing libtool files for $(NAME)"

pre_toolkit_fix_target: toolkit_fix_msg

toolkit_fix_target:  $(PRE_FIX_TARGET) 
	chmod -R u+w $(WORK_DIR)
	@find $(WORK_DIR) -type f -name '*.la' -exec sed -i -e "s|^libdir=.*$$|libdir='$(WORK_DIR)/lib'|" {} \;

post_toolkit_fix_target: $(FIX_TARGET)

ifeq ($(wildcard $(FIX_COOKIE)),)
toolkit_fix: $(FIX_COOKIE)

$(FIX_COOKIE): $(POST_FIX_TARGET)
	$(create_target_dir)
	@touch -f $@
else
toolkit_fix: ;
endif
