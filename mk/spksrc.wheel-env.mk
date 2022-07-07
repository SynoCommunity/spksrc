#
# Configuration for python wheel build
#

# Enable pure-python packaging
ifeq ($(strip $(WHEELS_PURE_PYTHON_PACKAGING_ENABLE)),)
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = FALSE
endif

ifeq ($(strip $(WHEELS_DEFAULT)),)
WHEELS_DEFAULT = requirements.txt
endif
ifeq ($(strip $(WHEELS_LIMITED_API)),)
WHEELS_LIMITED_API = requirements-abi3.txt
endif
ifeq ($(strip $(WHEELS_PURE_PYTHON)),)
WHEELS_PURE_PYTHON = requirements-pure.txt
endif
ifeq ($(strip $(WHEELS_CROSS_COMPILE)),)
WHEELS_CROSS_COMPILE = requirements-cross.txt
endif
ifeq ($(strip $(WHEELS_CROSSENV_COMPILE)),)
WHEELS_CROSSENV_COMPILE = requirements-crossenv.txt
endif

ifeq ($(strip $(WHEEL_DEFAULT_PREFIX)),)
# If no ARCH then pure by default
ifeq ($(strip $(ARCH)),)
WHEEL_DEFAULT_PREFIX = pure
else
WHEEL_DEFAULT_PREFIX = cross
endif
endif

ifeq ($(strip $(WHEEL_DEFAULT_PREFIX)),pure)
WHEELS_DEFAULT_REQUIREMENT = $(WHEELS_PURE_PYTHON)
else
WHEELS_DEFAULT_REQUIREMENT = $(WHEELS_CROSSENV_COMPILE)
endif

# For generating abi3 wheels with limited
# python API (e.g cp35 = Python 3.5)
ifeq ($(strip $(PYTHON_LIMITED_API)),)
PYTHON_LIMITED_API = cp35
endif

#
# Define _PYTHON_HOST_PLATFORM so wheel
# prefix in file naming matches 'uname -m'
#
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
PYTHON_ARCH = armv5tel
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
PYTHON_ARCH = armv7l
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PYTHON_ARCH = aarch64
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
PYTHON_ARCH = ppc
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PYTHON_ARCH = x86_64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PYTHON_ARCH = i686
endif

install_python_wheel:
	@if [ -d "$(WHEELHOUSE)" ] ; then \
		mkdir -p $(STAGING_INSTALL_WHEELHOUSE) ; \
		cd $(WHEELHOUSE) ; \
		if stat -t requirements*.txt >/dev/null 2>&1; then \
			$(MSG) Copying $(WHEELS_DEFAULT) to wheelhouse ; \
			cp requirements*.txt $(STAGING_INSTALL_WHEELHOUSE) ; \
			cat requirements*.txt >> $(STAGING_INSTALL_WHEELHOUSE)/$(WHEELS_DEFAULT) ; \
			sed -i -e '/^#/! s/^.*egg=//g' $(STAGING_INSTALL_WHEELHOUSE)/requirements*.txt ; \
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

