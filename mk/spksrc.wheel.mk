### Wheel rules
#   Create wheels for modules listed in WHEELS. 
#   If CROSS_COMPILE_WHEELS is set via python-cc.mk,
#   wheels are cross-compiled. If not, pure-python 
#   wheels are created.

# Targets are executed in the following order:
#  wheel_msg_target
#  pre_wheel_target   (override with PRE_WHEEL_TARGET)
#  build_wheel_target (override with WHEEL_TARGET)
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
WHEEL_TARGET = build_wheel_target
else
$(WHEEL_TARGET): $(BUILD_WHEEL_TARGET)
endif
ifeq ($(strip $(POST_WHEEL_TARGET)),)
POST_WHEEL_TARGET = post_wheel_target
else
$(POST_WHEEL_TARGET): $(WHEEL_TARGET)
endif


wheel_msg_target:
	@$(MSG) "Processing wheels of $(NAME)"

# PIP distributions caching requires that the user running it owns the cache directory.
# PIP_CACHE_OPT is default "--cache-dir $(PIP_DIR)", PIP_DIR defaults to $(DISTRIB_DIR)/pip, so
# will move if the user chooses a custom persistent distribution dir for caching downloads between
# containers and builds.
pre_wheel_target: wheel_msg_target
	@if [ ! -z "$(WHEELS)" ] ; then \
		if [ ! -z "$(PIP_CACHE_OPT)" ] ; then \
			mkdir -p $(PIP_DIR) ; \
		fi; \
		mkdir -p $(WORK_DIR)/wheelhouse ; \
		if [ -f "$(WHEELS)" ] ; then \
			$(MSG) "Using existing requirements file" ; \
			cp -f $(WHEELS) $(WORK_DIR)/wheelhouse/requirements.txt ; \
		else \
			$(MSG) "Creating requirements file" ; \
			rm -f $(WORK_DIR)/wheelhouse/requirements.txt ; \
			for wheel in $(WHEELS) ; \
			do \
				echo $$wheel >> $(WORK_DIR)/wheelhouse/requirements.txt ; \
			done \
		fi ; \
	fi

build_wheel_target: $(PRE_WHEEL_TARGET)
	@if [ ! -z "$(WHEELS)" ] ; then \
		$(foreach e,$(shell cat $(WORK_DIR)/python-cc.mk),$(eval $(e))) \
		if [ ! -z "$(CROSS_COMPILE_WHEELS)" ] ; then \
			$(MSG) "Force cross-compile" ; \
			$(RUN) CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR) $(WHEELS_CFLAGS)" LDFLAGS="$(LDFLAGS) $(WHEELS_LDFLAGS)" $(PIP_WHEEL) ; \
		else \
			$(MSG) "Force pure-python" ; \
			export LD= LDSHARED= CPP= NM= CC= AS= RANLIB= CXX= AR= STRIP= OBJDUMP= READELF= CFLAGS= CPPFLAGS= CXXFLAGS= LDFLAGS= && \
			  $(RUN) $(PIP_WHEEL) ; \
		fi ; \
	fi


post_wheel_target: $(WHEEL_TARGET)
	@if [ -d "$(WORK_DIR)/wheelhouse" ] ; then \
		mkdir -p $(STAGING_INSTALL_PREFIX)/share/wheelhouse ; \
		cd $(WORK_DIR)/wheelhouse && \
		  for w in *.whl; do \
		    cp -f $$w $(STAGING_INSTALL_PREFIX)/share/wheelhouse/`echo $$w | cut -d"-" -f -3`-none-any.whl; \
		  done ; \
	fi


ifeq ($(wildcard $(WHEEL_COOKIE)),)
wheel: $(WHEEL_COOKIE)

$(WHEEL_COOKIE): $(POST_WHEEL_TARGET)
	$(create_target_dir)
	@touch -f $@
else
wheel: ;
endif

