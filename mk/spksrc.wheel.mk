### Wheel rules
#   Copy or build all wheels listed in WHEELS.

# Target are executed in the following order:
#  wheel_msg_target
#  pre_wheel_target   (override with PRE_WHEEL_TARGET)
#  wheel_target       (override with WHEEL_TARGET)
#  post_wheel_target  (override with POST_WHEEL_TARGET)
# Variables:
#  WHEELS             List of wheels to go through 

WHEEL_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)wheel_done

ifeq ($(strip $(PRE_WHEEL_TARGET)),)
PRE_WHEEL_TARGET = pre_wheel_target
else
$(PRE_WHEEL_TARGET): wheel_msg_target
endif
ifeq ($(strip $(WHEEL_TARGET)),)
WHEEL_TARGET = wheel_target
else
$(WHEEL_TARGET): $(PRE_WHEEL_TARGET)
endif
ifeq ($(strip $(POST_WHEEL_TARGET)),)
POST_WHEEL_TARGET = post_wheel_target
else
$(POST_WHEEL_TARGET): $(WHEEL_TARGET)
endif

wheel_msg_target:
	@$(MSG) "Processing wheels of $(NAME)"

pre_wheel_target: wheel_msg_target

wheel_target: $(PRE_WHEEL_TARGET)
	@if [ -n "$(WHEELS)" ] ; then \
		mkdir -p $(WORK_DIR)/wheelhouse ; \
		if [ -f "$(WHEELS)" ] ; then \
			$(MSG) "Using existing requirements file" ; \
			cp $(WHEELS) $(WORK_DIR)/wheelhouse ; \
		else \
			$(MSG) "Creating requirements file" ; \
			rm -f $(WORK_DIR)/wheelhouse/requirements.txt ; \
			for wheel in $(WHEELS) ; \
			do \
				echo $$wheel >> $(WORK_DIR)/wheelhouse/requirements.txt ; \
			done \
		fi ; \
		$(MSG) "Building wheels" ; \
		rm -rf $(WORK_DIR)/wheelbuild ; \
		mkdir -p $(WORK_DIR)/wheelbuild ; \
		$(RUN) $(PIP) wheel --no-deps -b $(WORK_DIR)/wheelbuild -w $(WORK_DIR)/wheelhouse -f $(WORK_DIR)/wheelhouse/ -r $(WORK_DIR)/wheelhouse/requirements.txt ; \
	else  \
		$(MSG) "No wheels to process" ; \
	fi

post_wheel_target: $(WHEEL_TARGET)

ifeq ($(wildcard $(WHEEL_COOKIE)),)
wheel: $(WHEEL_COOKIE)

$(WHEEL_COOKIE): $(POST_WHEEL_TARGET)
	$(create_target_dir)
	@touch -f $@
else
wheel: ;
endif

