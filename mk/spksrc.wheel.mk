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
ifneq ($(strip $(WHEELS)),)
	@if [ -n "$(PIP_CACHE_OPT)" ] ; then \
	   mkdir -p $(PIP_DIR) ; \
	fi; \
	mkdir -p $(WHEELHOUSE) ; \
	for wheel in $(WHEELS) ; do \
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
	done
endif

# Build cross compiled wheels first, to fail fast.
# There might be an issue with some pure python wheels when built after that.
build_wheel_target: SHELL:=/bin/bash
build_wheel_target: $(PRE_WHEEL_TARGET)
ifneq ($(strip $(WHEELS)),)
	$(foreach e,$(shell cat $(WORK_DIR)/python-cc.mk),$(eval $(e)))
	@if [ -s $(WHEELHOUSE)/$(WHEELS_CROSSENV_COMPILE) -o -s $(WHEELHOUSE)/$(WHEELS_LIMITED_API) ]; then \
	   $(MSG) "Cross-compiling wheels" ; \
	   crossenvPIP=$(PIP) ; \
	   if [ -s "$(CROSSENV)" ] ; then \
	      crossenvPIP=$$(. $(CROSSENV) && which pip) ; \
	      $(MSG) "Python crossenv found: [$(CROSSENV)]" ; \
	      $(MSG) "pip crossenv found: [$${crossenvPIP}]" ; \
	   elif [ "$(PYTHON_VERSION)" != "2.7" ] ; then \
	      $(MSG) "WARNING: Python crossenv NOT found!" ; \
	      $(MSG) "WARNING: pip crossenv NOT found!" ; \
	   else \
	      $(MSG) "Python $(PYTHON_VERSION) uses pip: $${crossenvPIP}" ; \
	   fi ; \
	   while IFS= read -r requirement ; do \
	      wheel=$${requirement#*:} ; \
	      file=$$(basename $${requirement%%:*}) ; \
	      [ "$${file}" = "$(WHEELS_LIMITED_API)" ] && abi3="--build-option=--py-limited-api=$(PYTHON_LIMITED_API)" || abi3="" ; \
	      [ "$$(grep -s egg <<< $${wheel})" ] && name=$$(echo $${wheel#*egg=} | cut -f1 -d=) || name=$${wheel%%[<>=]=*} ; \
	      global_options=$$(echo $(WHEELS_BUILD_ARGS) | sed -e 's/ \[/\n\[/g' | grep -i $${name} | cut -f2 -d] | xargs) ; \
	      localCFLAGS=($$(echo $(WHEELS_CFLAGS) | sed -e 's/ \[/\n\[/g' | grep -i $${name} | cut -f2 -d] | xargs)) ; \
	      localLDFLAGS=($$(echo $(WHEELS_LDFLAGS) | sed -e 's/ \[/\n\[/g' | grep -i $${name} | cut -f2 -d] | xargs)) ; \
	      localCPPFLAGS=($$(echo $(WHEELS_CPPFLAGS) | sed -e 's/ \[/\n\[/g' | grep -i $${name} | cut -f2 -d] | xargs)) ; \
	      localCXXFLAGS=($$(echo $(WHEELS_CXXFLAGS) | sed -e 's/ \[/\n\[/g' | grep -i $${name} | cut -f2 -d] | xargs)) ; \
	      $(MSG) [$${name}] \
	         $$([ "$$(echo $${localCFLAGS[@]})" ] && echo "CFLAGS=\"$${localCFLAGS[@]}\" ") \
	         $$([ "$$(echo $${localCPPFLAGS[@]})" ] && echo "CPPFLAGS=\"$${localCPPFLAGS[@]}\" ") \
	         $$([ "$$(echo $${localCXXFLAGS[@]})" ] && echo "CXXFLAGS=\"$${localCXXFLAGS[@]}\" ") \
	         $$([ "$$(echo $${localLDFLAGS[@]})" ] && echo "LDFLAGS=\"$${localLDFLAGS[@]}\" ") \
	         $$([ "$$(echo $${abi3})" ] && echo "$${abi3} ")" \
	         $${global_options}" ; \
	      PIP_CROSSENV=$${crossenvPIP} \
	         REQUIREMENT=$${wheel} \
	         ADDITIONAL_CFLAGS="-I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR) $${localCFLAGS[@]}" \
	         ADDITIONAL_CPPFLAGS="-I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR) $${localCPPFLAGS[@]}" \
	         ADDITIONAL_CXXFLAGS="-I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR) $${localCXXFLAGS[@]}" \
	         ADDITIONAL_LDFLAGS="$${localLDFLAGS[@]}" \
	         ABI3="$${abi3}" \
	         PIP_GLOBAL_OPTION="$${global_options}" \
	         $(MAKE) \
	         cross-compile-wheel-$${name} || exit 1 ; \
	   done < <(grep -svH  -e "^\#" -e "^\$$" $(WHEELHOUSE)/$(WHEELS_CROSSENV_COMPILE) $(WHEELHOUSE)/$(WHEELS_LIMITED_API)) ; \
	else \
	   $(MSG) "[SKIP] Cross-compiling wheels" ; \
	fi
ifneq ($(filter 1 ON TRUE,$(WHEELS_PURE_PYTHON_PACKAGING_ENABLE)),)
	@if [ -s "$(WHEELHOUSE)/$(WHEELS_PURE_PYTHON)" ]; then \
	   $(MSG) "Building pure-python" ; \
	   export LD= LDSHARED= CPP= NM= CC= AS= RANLIB= CXX= AR= STRIP= OBJDUMP= OBJCOPY= READELF= CFLAGS= CPPFLAGS= CXXFLAGS= LDFLAGS= && \
	      $(RUN) $(PIP) $(PIP_WHEEL_ARGS) --requirement $(WHEELHOUSE)/$(WHEELS_PURE_PYTHON) ; \
	fi
else
	@$(MSG) "[SKIP] Building pure-python"
endif
endif


cross-compile-wheel-%: SHELL:=/bin/bash
cross-compile-wheel-%:
	@if [ "$(PIP_GLOBAL_OPTION)" ]; then \
	   pip_global_option=$$(echo $(PIP_GLOBAL_OPTION) | sed 's/=\([^ ]*\)/="\1"/g; s/[^ ]*/--global-option=&/g') ; \
	   pip_global_option=$${pip_global_option}" --no-use-pep517" ; \
	fi ; \
	$(MSG) \
	   _PYTHON_HOST_PLATFORM="$(TC_TARGET)" \
	   $(PIP_CROSSENV) \
	   $(PIP_WHEEL_ARGS) \
	   $${pip_global_option} \
	   --no-build-isolation \
	   $(ABI3) \
	   $(REQUIREMENT) ; \
	$(RUN) \
	   _PYTHON_HOST_PLATFORM="$(TC_TARGET)" \
	   $(PIP_CROSSENV) \
	   $(PIP_WHEEL_ARGS) \
	   $${pip_global_option} \
	   --no-build-isolation \
	   $(ABI3) \
	   $(REQUIREMENT)


post_wheel_target: $(WHEEL_TARGET) install_python_wheel

ifeq ($(wildcard $(WHEEL_COOKIE)),)
wheel: $(WHEEL_COOKIE)

$(WHEEL_COOKIE): $(POST_WHEEL_TARGET)
	$(create_target_dir)
	@touch -f $@
else
wheel: ;
endif
