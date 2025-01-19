### Wheel rules
# Install wheels for modules listed in WHEELS. 
#
# Targets are executed in the following order:
#  wheel_install_msg_target
#  pre_wheel_install_target   (override with PRE_WHEEL_INSTALL_TARGET)
#  wheel_install_target       (override with WHEEL_INSTALL_TARGET)
#  post_wheel_install_target  (override with POST_WHEEL_INSTALL_TARGET)
# Variables:
#  REQUIREMENT             Requirement formatted wheel information
#  WHEEL_NAME              Name of wheel to process
#  WHEEL_VERSION           Version of wheel to process (can be empty)
#  WHEEL_TYPE              Type of wheel to process (abi3, crossenv, pure)

ifeq ($(WHEEL_VERSION),)
WHEEL_INSTALL_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)wheel_install-$(WHEEL_NAME)_done
else
WHEEL_INSTALL_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)wheel_install-$(WHEEL_NAME)-$(WHEEL_VERSION)_done
endif

##

ifeq ($(strip $(PRE_WHEEL_INSTALL_TARGET)),)
PRE_WHEEL_INSTALL_TARGET = pre_wheel_install_target
else
$(PRE_WHEEL_INSTALL_TARGET): wheel_install_msg_target
endif
ifeq ($(strip $(WHEEL_INSTALL_TARGET)),)
WHEEL_INSTALL_TARGET = wheel_install_target
else
$(WHEEL_INSTALL_TARGET): $(BUILD_WHEEL_INSTALL_TARGET)
endif
ifeq ($(strip $(POST_WHEEL_INSTALL_TARGET)),)
POST_WHEEL_INSTALL_TARGET = post_wheel_install_target
else
$(POST_WHEEL_INSTALL_TARGET): $(WHEEL_INSTALL_TARGET)
endif

wheel_install_msg_target:
	@$(MSG) "Processing wheels of $(NAME)"

pre_wheel_install_target: wheel_install_msg_target

wheel_install_target: SHELL:=/bin/bash
wheel_install_target:
	@$(MSG) Installing wheel [$(WHEEL_NAME)], version [$(WHEEL_VERSION)], type [$(WHEEL_TYPE)] ; \
	case $(WHEEL_TYPE) in \
	       abi3) $(MSG) Adding $(WHEEL_NAME)==$(WHEEL_VERSION) to wheelhouse/$(WHEELS_LIMITED_API) ; \
	             echo $(WHEEL_NAME)==$(WHEEL_VERSION) | sed -e '/^[[:blank:]]*$$\|^#/d' >> $(WHEELHOUSE)/$(WHEELS_LIMITED_API) ; \
	             ;; \
	      cross) $(MSG) Adding $(WHEEL_NAME)==$(WHEEL_VERSION) to wheelhouse/$(WHEELS_CROSS_COMPILE) ; \
	             echo $(WHEEL_NAME)==$(WHEEL_VERSION) | sed -e '/^[[:blank:]]*$$\|^#/d' >> $(WHEELHOUSE)/$(WHEELS_CROSS_COMPILE) ; \
	             ;; \
	   crossenv) $(MSG) Adding $(WHEEL_NAME)==$(WHEEL_VERSION) to wheelhouse/$(WHEELS_CROSSENV_COMPILE) ; \
	             echo $(WHEEL_NAME)==$(WHEEL_VERSION) | sed -e '/^[[:blank:]]*$$\|^#/d' >> $(WHEELHOUSE)/$(WHEELS_CROSSENV_COMPILE) ; \
	             ;; \
	       pure) $(MSG) Adding $(WHEEL_NAME)==$(WHEEL_VERSION) to wheelhouse/$(WHEELS_PURE_PYTHON) ; \
	             echo $(WHEEL_NAME)==$(WHEEL_VERSION) | sed -e '/^[[:blank:]]*$$\|^#/d' >> $(WHEELHOUSE)/$(WHEELS_PURE_PYTHON) ; \
	             ;; \
	          *) $(MSG) No type found for wheel [$(REQUIREMENT)] ; \
	             ;; \
	esac
	@for file in $$(ls -1 $(WHEELHOUSE)/requirements-*.txt) ; do \
	   sort -u -o $${file}{,} ; \
	done

install_python_wheel:
	@if [ -d "$(WHEELHOUSE)" ] ; then \
		mkdir -p $(STAGING_INSTALL_WHEELHOUSE) ; \
		cd $(WHEELHOUSE) ; \
		if stat -t requirements*.txt >/dev/null 2>&1; then \
			$(MSG) Copying $(WHEELS_DEFAULT) to wheelhouse ; \
			cp requirements*.txt $(STAGING_INSTALL_WHEELHOUSE) ; \
			cat requirements*.txt >> $(STAGING_INSTALL_WHEELHOUSE)/$(WHEELS_DEFAULT) ; \
			sort -u -o $(STAGING_INSTALL_WHEELHOUSE)/$(WHEELS_DEFAULT) $(STAGING_INSTALL_WHEELHOUSE)/$(WHEELS_DEFAULT) ; \
		else \
			$(MSG) [SKIP] Copying $(WHEELS_DEFAULT) to wheelhouse ; \
		fi ; \
		if stat -t *.whl >/dev/null 2>&1; then \
			for w in *.whl; do \
				if echo $${w} | grep -iq "-none-any\.whl" ; then \
					_new_name=$$(echo $$w | cut -d"-" -f -3)-none-any.whl ; \
				else \
					_new_name=$$(echo $$w | sed -E "s/(.*-).*(linux_).*(\.whl)/\1\2$(PYTHON_ARCH)\3/") ; \
				fi ; \
				$(MSG) Copying to wheelhouse: $$_new_name ; \
				cp -f $$w $(STAGING_INSTALL_WHEELHOUSE)/$$_new_name ; \
			done ; \
		fi ; \
	fi


post_wheel_install_target: $(WHEEL_INSTALL_TARGET)

ifeq ($(wildcard $(WHEEL_INSTALL_COOKIE)),)
wheel_install: $(WHEEL_INSTALL_COOKIE)

$(WHEEL_INSTALL_COOKIE): $(POST_WHEEL_INSTALL_TARGET)
	$(create_target_dir)
	@touch -f $@
else
wheel_install: ;
endif
