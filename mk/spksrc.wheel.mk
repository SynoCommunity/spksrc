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

## python wheel specific configurations
include ../../mk/spksrc.wheel-env.mk

##

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
		mkdir -p $(WHEELHOUSE) ; \
		for wheel in $(WHEELS) ; \
		do \
			if [ -f $$wheel ] ; then \
				if [ $$(basename $$wheel) = $(WHEELS_PURE_PYTHON) ]; then \
					$(MSG) "Adding existing $$wheel file as pure-python (discarding any cross-compiled)" ; \
					sed -e '/^cross:\|^#\|^$$/d' -e /^pure:/s/^pure://g $$wheel  >> $(WHEELHOUSE)/$(WHEELS_PURE_PYTHON) ; \
				elif [ $$(basename $$wheel) = $(WHEELS_CROSSENV_COMPILE) ]; then \
					$(MSG) "Adding existing $$wheel file as cross-compiled (discarding any pure-python)" ; \
					sed -e '/^pure:\|^#\|^$$/d' -e /^cross:/s/^cross://g $$wheel >> $(WHEELHOUSE)/$(WHEELS_CROSSENV_COMPILE) ; \
				elif [ $$(basename $$wheel) = $(WHEELS_LIMITED_API) ]; then \
					$(MSG) "Adding existing $$wheel file as ABI-limited" ; \
					cat $$wheel >> $(WHEELHOUSE)/$(WHEELS_LIMITED_API) ; \
				else \
					$(MSG) "Adapting existing $$wheel file" ; \
					sed -rn /^pure:/s/^pure://gp $$wheel         >> $(WHEELHOUSE)/$(WHEELS_PURE_PYTHON) ; \
					sed -rn /^cross:/s/^cross://gp $$wheel       >> $(WHEELHOUSE)/$(WHEELS_CROSSENV_COMPILE) ; \
					sed -e '/^pure:\|^cross:\|^#\|^$$/d' $$wheel >> $(WHEELHOUSE)/$(WHEELS_DEFAULT_REQUIREMENT) ; \
				fi ;\
			else \
				$(MSG) "ERROR: File $$wheel does not exist" ; \
			fi ; \
		done \
	fi

# Build cross compiled wheels first, to fail fast.
# There might be an issue with some pure python wheels when built after that.
build_wheel_target: SHELL:=/bin/bash
build_wheel_target: $(PRE_WHEEL_TARGET)
	@if [ -n "$(WHEELS)" ] ; then \
		$(foreach e,$(shell cat $(WORK_DIR)/python-cc.mk),$(eval $(e))) \
		$(MSG) "Cross-compiling wheels" ; \
		localPIP=$(PIP) ; \
		if [ -s "$(CROSSENV)" ] ; then \
			$(MSG) "Python crossenv found: [$(CROSSENV)]" ; \
			. $(CROSSENV) ; \
			localPIP=$(PIP_CROSSENV) ; \
		fi ; \
		while IFS= read -r requirement ; do \
			wheel=$${requirement#*:} ; \
			file=$$(basename $${requirement%%:*}) ; \
			[ "$${file}" = "$(WHEELS_LIMITED_API)" ] && abi3="--build-option=--py-limited-api=$(PYTHON_LIMITED_API)" || abi3="" ; \
			[ "$$(grep -s egg <<< $${wheel})" ] && name=$${wheel#*egg=} || name=$${wheel%%[<>=]=*} ; \
			options=($$(echo $(WHEELS_BUILD_ARGS) | sed -e 's/ \[/\n\[/g' | grep -i $${name} | cut -f2 -d] | xargs)) ; \
			[ "$${options}" ] && global_option=$$(printf "\x2D\x2Dglobal-option=%s " "$${options[@]}") || global_option="" ; \
			localCFLAGS=($$(echo $(WHEELS_CFLAGS) | sed -e 's/ \[/\n\[/g' | grep -i $${name} | cut -f2 -d] | xargs)) ; \
			localLDFLAGS=($$(echo $(WHEELS_LDFLAGS) | sed -e 's/ \[/\n\[/g' | grep -i $${name} | cut -f2 -d] | xargs)) ; \
			localCPPFLAGS=($$(echo $(WHEELS_CPPFLAGS) | sed -e 's/ \[/\n\[/g' | grep -i $${name} | cut -f2 -d] | xargs)) ; \
			localCXXFLAGS=($$(echo $(WHEELS_CXXFLAGS) | sed -e 's/ \[/\n\[/g' | grep -i $${name} | cut -f2 -d] | xargs)) ; \
			$(MSG) [$${name}] $$([ "$${localCFLAGS[@]}" ] && echo "CFLAGS=$${localCFLAGS[@]} ")$$([ "$${localLDFLAGS[@]}" ] && echo "LDFLAGS=$${localLDFLAGS[@]} ")$$([ "$${localCPPFLAGS[@]}" ] && echo "CPPFLAGS=$${localCPPFLAGS[@]} ")$$([ "$${localCXXFLAGS[@]}" ] && echo "CXXFLAGS=$${localCXXFLAGS[@]} ")$$([ "$${abi3}" ] && echo "$${abi3} ")"$${global_option}" ; \
			$(RUN) \
				_PYTHON_HOST_PLATFORM="$(TC_TARGET)" \
				CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR) $${localCFLAGS[@]}" \
				LDFLAGS="$(LDFLAGS) $${localLDFLAGS[@]}" \
				CPPFLAGS="$(CPPFLAGS) $${localCPPFLAGS[@]}" \
				CXXFLAGS="$(CXXFLAGS) $${localCXXFLAGS[@]}" \
				$${localPIP} \
				$(PIP_WHEEL_ARGS) \
				$${abi3} \
				$${global_option} \
				--no-build-isolation \
				$${wheel} ; \
		done < <(grep -svH  -e "^\#" -e "^\$$" $(WHEELHOUSE)/$(WHEELS_CROSSENV_COMPILE) $(WHEELHOUSE)/$(WHEELS_LIMITED_API)) || true ; \
	fi
ifneq ($(filter 1 ON TRUE,$(WHEELS_PURE_PYTHON_PACKAGING_ENABLE)),)
	@if [ -n "$(WHEELS)" ] ; then \
		$(foreach e,$(shell cat $(WORK_DIR)/python-cc.mk),$(eval $(e))) \
		if [ -s "$(WHEELHOUSE)/$(WHEELS_PURE_PYTHON)" ]; then \
			$(MSG) "Force pure-python" ; \
			export LD= LDSHARED= CPP= NM= CC= AS= RANLIB= CXX= AR= STRIP= OBJDUMP= READELF= CFLAGS= CPPFLAGS= CXXFLAGS= LDFLAGS= && $(RUN) \
				$(PIP) \
				$(PIP_WHEEL_ARGS) \
				--requirement $(WHEELHOUSE)/$(WHEELS_PURE_PYTHON) ; \
		fi ; \
	fi
endif

post_wheel_target: $(WHEEL_TARGET) install_python_wheel

ifeq ($(wildcard $(WHEEL_COOKIE)),)
wheel: $(WHEEL_COOKIE)

$(WHEEL_COOKIE): $(POST_WHEEL_TARGET)
	$(create_target_dir)
	@touch -f $@
else
wheel: ;
endif

clean-wheel:
	rm --force $(WHEEL_COOKIE)
	rm --recursive --force $(STAGING_INSTALL_PREFIX)/share/wheelhouse
	rm --recursive --force $(WORK_DIR)/wheelhouse
	rm --force $(COPY_COOKIE)
	rm --force $(WORK_DIR)/package.tgz
