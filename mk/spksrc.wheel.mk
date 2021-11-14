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

ifeq ($(strip $(WHEELS_PURE_PYTHON)),)
WHEELS_PURE_PYTHON    = requirements.txt
endif
ifeq ($(strip $(WHEELS_CROSS_COMPILE)),)
WHEELS_CROSS_COMPILE  = requirements-cross.txt
endif

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
	@if [ -n "$(WHEELS)" ] ; then \
		if [ -n "$(PIP_CACHE_OPT)" ] ; then \
			mkdir -p $(PIP_DIR) ; \
		fi; \
		rm -fr $(WHEELHOUSE) ; \
		mkdir -p $(WHEELHOUSE) ; \
		for wheel in $(WHEELS) ; \
		do \
			if [ -f $$wheel ] ; then \
				$(MSG) "Using existing $$wheel file" ; \
				$(MSG) cp -f $$wheel $(WHEELHOUSE)/$$(basename $$wheel) ; \
				cp -f $$wheel $(WHEELHOUSE)/$$(basename $$wheel) ; \
				sed -i -e '$$a\\' $(WHEELHOUSE)/$$(basename $$wheel) ; \
			else \
				$(MSG) "Adding to $(WHEELS_PURE_PYTHON) file" ; \
				echo $$wheel >> $(WHEELHOUSE)/$(WHEELS_PURE_PYTHON) ; \
			fi ; \
		done \
	fi

# Build cross compiled wheels first, to fail fast.
# There might be an issue with some pure python wheels when built after that.
build_wheel_target: $(PRE_WHEEL_TARGET)
	@if [ -n "$(WHEELS)" ] ; then \
		$(foreach e,$(shell cat $(WORK_DIR)/python-cc.mk),$(eval $(e))) \
		if [ -f "$(WHEELHOUSE)/$(WHEELS_CROSS_COMPILE)" ]; then \
			$(MSG) "Force cross-compile" ; \
			if [ -z "$(CROSSENV)" ]; then \
				$(RUN) _PYTHON_HOST_PLATFORM="$(TC_TARGET)" CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR) $(WHEELS_CFLAGS)" LDFLAGS="$(LDFLAGS) $(WHEELS_LDFLAGS)" $(PIP_WHEEL) --requirement $(WHEELHOUSE)/$(WHEELS_CROSS_COMPILE) ; \
			else \
				. $(CROSSENV) && $(RUN) _PYTHON_HOST_PLATFORM="$(TC_TARGET)" CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR) $(WHEELS_CFLAGS)" LDFLAGS="$(LDFLAGS) $(WHEELS_LDFLAGS)" pip $(PIP_WHEEL_ARGS) --no-build-isolation --requirement $(WHEELHOUSE)/$(WHEELS_CROSS_COMPILE) ; \
			fi ; \
		fi ; \
		if [ -f "$(WHEELHOUSE)/$(WHEELS_PURE_PYTHON)" ]; then \
			$(MSG) "Force pure-python" ; \
			export LD= LDSHARED= CPP= NM= CC= AS= RANLIB= CXX= AR= STRIP= OBJDUMP= READELF= CFLAGS= CPPFLAGS= CXXFLAGS= LDFLAGS= && \
				$(RUN) $(PIP_WHEEL) --requirement $(WHEELHOUSE)/$(WHEELS_PURE_PYTHON) ; \
		fi ; \
	fi

post_wheel_target: $(WHEEL_TARGET)
	@if [ -d "$(WHEELHOUSE)" ] ; then \
		mkdir -p $(STAGING_INSTALL_WHEELHOUSE) ; \
		cd $(WHEELHOUSE) ; \
		if stat -t requirements*.txt >/dev/null 2>&1; then \
			cat requirements*.txt > $(STAGING_INSTALL_WHEELHOUSE)/$(WHEELS_PURE_PYTHON) ; \
		fi ;\
		if [ "$(EXCLUDE_PURE_PYTHON_WHEELS)" = "yes" ] ; then \
			echo "Pure python wheels are excluded from the package wheelhouse." ; \
			for w in *.whl; do \
				if echo $${w} | grep -viq "-none-any\.whl" ; then \
					cp -f $$w $(STAGING_INSTALL_WHEELHOUSE)/`echo $$w | cut -d"-" -f -3`-none-any.whl; \
				fi ; \
			done ; \
		else \
			for w in *.whl; do \
				cp -f $$w $(STAGING_INSTALL_WHEELHOUSE)/`echo $$w | cut -d"-" -f -3`-none-any.whl; \
			done ; \
		fi ; \
	fi


ifeq ($(wildcard $(WHEEL_COOKIE)),)
wheel: $(WHEEL_COOKIE)

$(WHEEL_COOKIE): $(POST_WHEEL_TARGET)
	$(create_target_dir)
	@touch -f $@
else
wheel: ;
endif

