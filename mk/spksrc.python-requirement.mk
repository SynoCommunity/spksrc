### requirement rules
#
#   Part of the python wheel cross-compiling is managing the requirements.
#   These are processed here being passed using the REQUIREMENT variable
#   in the form of a:
#     1- <PATH>/requirement.txt                     -> requirement file
#     2- <PATH>/requirement-<crossenv|pure|etc>.txt -> requirement file for specific WHEEL_TYPE
#     3- requirement*.txt:<name>==<version>         -> wheel name & version with originating requirment filename for WHEEL_TYPE
#     4- <build|cross|wheelhouse>:<name>==<version> -> wheel type, name & version
#
#   Through multiple iteration the outcome is to populate the following default variables:
#     - WHEEL_TYPE    -> build,cross,wheelhouse
#     - WHEEL_NAME    -> name from the received requirement
#     - WHEEL_VERSION -> version received from requirement ELSE latest from pypi
#     - WHEEL_URL     -> for wheels using git+http type url based (OPTIONAL)
#     - REQUIREMENT   -> final form <name>==<version> -> ready to call wheel processing methods
#
#   There are two distinct directives, first is to process a normal wheels
#   which will call the standard wheel compiling stack by calling:
#       4. wheel         -> depends on 3 (top-level)
#       3. wheel_install -> depends on 2
#       2. wheel_compile -> depends on 1
#       1. wheel_download
#
#   The second directive is to process wheels to be install in a crossenv.
#   The REQUIREMENT_GOAL is then also being received in the form of:
#        1- crossenv-install-default          -> install in default crossenv/build|cross
#        2- crossenv-install-<name>-<version> -> install in wheel specific crossenv-<name>-<version>/build|cross (version is optional)
#   Once the the WHEEL_* variables are fully populated, calls
#   crossenv-install-% from spksrc.crossenv.mk which will install
#   the wheels in the appropriate crossenv sub-target (e.g. build/cross).
#
#   When called the MAKECMDGOALS is such as:
#                    spksrc.spk.mk: MAKECMDGOALS is empty
#                                   It then gets automatically set to 'requirement' to
#                                   populate then WHEEL_* variables. Once ready it calls
#                                   the standard wheel compiling stack.
#
#   make wheel-<arch>-<tcversion> : MAKECMDGOALS is wheel
#                                   Simulate spksrc.spk.mk by calling 'wheel' top level of
#                                   the standard wheel compiling stack.
#
#            make download-wheels : MAKECMDGOALS is 'download-wheels'
#                                   Enforces skipping 'wheel_<compile|install>' and goes directly
#                                   to 'wheel_download' of the standard wheel compiling stack
#                                   (used for github-action).
#
# Targets are executed in the following order:
#  requirement_msg_target
#  pre_requirement_target   (override with PRE_REQUIREMENT_TARGET)
#  requirement_target       (override with REQUIREMENT_TARGET)
#  post_requirement_target  (override with POST_REQUIREMENT_TARGET)
#

# Default to "requirement" when no explicit make goals are specified
REQUIREMENT_GOAL := $(if $(MAKECMDGOALS),$(MAKECMDGOALS),requirement)

ifeq ($(strip $(PRE_REQUIREMENT_TARGET)),)
PRE_REQUIREMENT_TARGET = pre_requirement_target
else
$(PRE_REQUIREMENT_TARGET): requirement_msg_target
endif
ifeq ($(strip $(REQUIREMENT_TARGET)),)
REQUIREMENT_TARGET = requirement_target
else
$(REQUIREMENT_TARGET): $(BUILD_REQUIREMENT_TARGET)
endif
ifeq ($(strip $(POST_REQUIREMENT_TARGET)),)
POST_REQUIREMENT_TARGET = post_requirement_target
else
$(POST_REQUIREMENT_TARGET): $(REQUIREMENT_TARGET)
endif

requirement_msg_target:
	@$(MSG) "Processing wheel for $(NAME)"

pre_requirement_target: requirement_msg_target

requirement-%:
ifneq ($(strip $(REQUIREMENT)),)
	@$(MSG) $(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) REQUIREMENT=\"$(REQUIREMENT)\" requirement
	@MAKEFLAGS= $(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) REQUIREMENT="$(REQUIREMENT)" requirement --no-print-directory
else
	$(error No python wheel requirement to process)
endif

requirement_target: SHELL:=/bin/bash
requirement_target: pre_requirement_target
ifneq ($(wildcard $(REQUIREMENT)),)
	@set -e ; \
	while IFS= read -r requirement ; do \
	   $(MSG) Processing requirement file [$${requirement}] ; \
	   wheel=$${requirement#*requirements-*.txt:} ; \
	   prefix=$$(basename $${requirement%%:*}) ; \
	   case $${prefix} in \
	           requirements-abi3.txt) type=abi3 ;; \
	      requirements-crossenv*.txt) type=crossenv ;; \
	           requirements-pure.txt) type=pure ;; \
	   esac ; \
	   $(MSG) $(MAKE) \
		ARCH=$(ARCH) \
		TCVERSION=$(TCVERSION) \
		REQUIREMENT=\"$${wheel}\" \
		WHEEL_TYPE=\"$${type}\" \
		REQUIREMENT_GOAL=\"$(REQUIREMENT_GOAL)\" \
		requirement ; \
	   MAKEFLAGS= $(MAKE) \
		ARCH="$(ARCH)" \
		TCVERSION="$(TCVERSION)" \
		REQUIREMENT="$${wheel}" \
		WHEEL_TYPE="$${type}" \
		REQUIREMENT_GOAL="$(REQUIREMENT_GOAL)" \
		requirement --no-print-directory || exit 1 ; \
	done < <(grep -svH  -e "^\#" -e "^\$$" $(wildcard $(REQUIREMENT)) | sed 's/\s* #.*//')
else
	@for requirement in $(REQUIREMENT) ; do \
	   $(MSG) Processing requirement [$${requirement}] ; \
	   wheel=$$(echo $${requirement} | sed -E "s/^(abi3|build|cross|crossenv|pure|wheelhouse)://") ; \
	   case $${requirement} in \
	          abi3:*) type=abi3 ;; \
	         build:*) type=build ;; \
	         cross:*) type=cross ;; \
	      crossenv:*) type=crossenv ;; \
	          pure:*) type=pure ;; \
	    wheelhouse:*) type=wheelhouse ;; \
	               *) [[ "$(REQUIREMENT_GOAL)" == crossenv-install-* ]] && type=build || type=$(WHEEL_DEFAULT_PREFIX) ;; \
	   esac ; \
	   version=$$(echo $${wheel} | grep -oP '(?<=([<>=]=))[^ ]*' || echo "") ; \
	   if [ "$$(grep -s egg <<< $${requirement})" ]; then \
	      name=$$(echo $${wheel#*egg=} | cut -f1 -d=) ; \
	      wheel_url=$$(echo $${wheel%%#egg=*}) ; \
	   else \
	      name=$$(echo $${wheel%%[<>=]=*} | sed -E "s/^(abi3|build|cross|crossenv|pure)://") ; \
	   fi ; \
	   if [ ! "$${version}" ]; then \
	      $(MSG) Fetching latest version available ; \
	      query="curl -s https://pypi.org/pypi/$${name}/json" ; \
	      query+=" | jq -r '.releases[][]" ; \
	      query+=" | select(.packagetype==\"sdist\")" ; \
	      query+=" | .filename'" ; \
	      query+=" | sort -V" ; \
	      query+=" | tail -1" ; \
	      query+=" | sed -e 's/.tar.gz//g' -e 's/.zip//g'" ; \
	      query+=" | awk -F'-' '{print \$$2}'" ; \
	      version=$$(eval $${query} 2>/dev/null) ; \
	   fi ; \
	   $(MSG) $(MAKE) ARCH=\"$(ARCH)\" \
	                  DEFAULT_ENV=\"autotools flags rust\" \
	                  TCVERSION=\"$(TCVERSION)\" \
	                  WHEEL_NAME=\"$${name}\" \
	                  WHEEL_VERSION=\"$${version}\" \
	                  WHEEL_TYPE=\"$(or $(WHEEL_TYPE),$${type})\" \
	                  WHEEL_URL=\"$${wheel_url}\" \
	                  REQUIREMENT_GOAL=\"$(REQUIREMENT_GOAL)\" \
	                  $(REQUIREMENT_GOAL) ; \
	   MAKEFLAGS= $(MAKE) ARCH="$(ARCH)" \
	                  DEFAULT_ENV="autotools flags rust" \
	                  TCVERSION="$(TCVERSION)" \
	                  WHEEL_NAME="$${name}" \
	                  WHEEL_VERSION="$${version}" \
	                  WHEEL_TYPE="$(or $(WHEEL_TYPE),$${type})" \
	                  WHEEL_URL="$${wheel_url}" \
	                  REQUIREMENT_GOAL="$(REQUIREMENT_GOAL)" \
	                  $(REQUIREMENT_GOAL) \
	                  --no-print-directory ; \
	done
endif

post_requirement_target: $(REQUIREMENT_TARGET)

requirement: $(POST_REQUIREMENT_TARGET)
