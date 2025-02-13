### Wheel rules
# Process wheels for modules listed in WHEELS. 
#   1. wheel_download
#   2. wheel_compile
#   3. wheel_install
#
# Targets are executed in the following order:
#  requirement_msg_target
#  pre_requirement_target   (override with PRE_REQUIREMENT_TARGET)
#  requirement_target       (override with REQUIREMENT_TARGET)
#  post_requirement_target  (override with POST_REQUIREMENT_TARGET)
# Variables:
#  WHEELS             List of wheels to go through

# When wheel is called from:
#                  spksrc.spk.mk: MAKECMDGOALS is empty (needs to be set to wheel)
# make wheel-<arch>-<tcversion> : MAKECMDGOALS is wheel
#          make download-wheels : MAKECMDGOALS is download-wheels
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
	   $(MSG) $(MAKE) ARCH=$(ARCH) TCVERSION=$(TCVERSION) REQUIREMENT=\"$${wheel}\" WHEEL_TYPE=\"$${type}\" REQUIREMENT_GOAL=\"$(REQUIREMENT_GOAL)\" requirement ; \
	   MAKEFLAGS= $(MAKE) ARCH="$(ARCH)" TCVERSION="$(TCVERSION)" REQUIREMENT="$${wheel}" WHEEL_TYPE="$${type}" REQUIREMENT_GOAL="$(REQUIREMENT_GOAL)" requirement --no-print-directory || exit 1 ; \
	done < <(grep -svH  -e "^\#" -e "^\$$" $(wildcard $(REQUIREMENT)) | sed 's/\s* #.*//')
else
	@for requirement in $(REQUIREMENT) ; do \
	   $(MSG) Processing requirement [$${requirement}] ; \
	   wheel=$$(echo $${requirement} | sed -E "s/^(abi3|build|cross|crossenv|pure)://") ; \
	   case $${requirement} in \
	          abi3:*) type=abi3 ;; \
	         build:*) type=build ;; \
	         cross:*) type=cross ;; \
	      crossenv:*) type=crossenv ;; \
	          pure:*) type=pure ;; \
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
	   if [ "$(REQUIREMENT_GOAL)" = "wheel" ]; then \
	      $(MSG) $(MAKE) ARCH=\"$(ARCH)\" \
	                     TCVERSION=\"$(TCVERSION)\" \
	                     WHEEL_NAME=\"$${name}\" \
	                     WHEEL_VERSION=\"$${version}\" \
	                     WHEEL_TYPE=\"$(or $(WHEEL_TYPE),$${type})\" \
	                     WHEEL_URL=\"$${wheel_url}\" \
	                     $(REQUIREMENT_GOAL) | tee --append $(WHEEL_LOG) ; \
	      MAKEFLAGS= $(MAKE) ARCH="$(ARCH)" \
	                     TCVERSION="$(TCVERSION)" \
	                     WHEEL_NAME="$${name}" \
	                     WHEEL_VERSION="$${version}" \
	                     WHEEL_TYPE="$(or $(WHEEL_TYPE),$${type})" \
	                     WHEEL_URL="$${wheel_url}" \
	                     $(REQUIREMENT_GOAL) \
	                     --no-print-directory | tee --append $(WHEEL_LOG) ; \
	                     [ $${PIPESTATUS[0]} -eq 0 ] || false ; \
	   else \
	      $(MSG) $(MAKE) ARCH=\"$(ARCH)\" \
	                     TCVERSION=\"$(TCVERSION)\" \
	                     WHEEL_NAME=\"$${name}\" \
	                     WHEEL_VERSION=\"$${version}\" \
	                     WHEEL_TYPE=\"$(or $(WHEEL_TYPE),$${type})\" \
	                     WHEEL_URL=\"$${wheel_url}\" \
	                     $(REQUIREMENT_GOAL) ; \
	      MAKEFLAGS= $(MAKE) ARCH="$(ARCH)" \
	                     TCVERSION="$(TCVERSION)" \
	                     WHEEL_NAME="$${name}" \
	                     WHEEL_VERSION="$${version}" \
	                     WHEEL_TYPE="$(or $(WHEEL_TYPE),$${type})" \
	                     WHEEL_URL="$${wheel_url}" \
	                     $(REQUIREMENT_GOAL) \
	                     --no-print-directory ; \
	   fi ; \
	done
endif

post_requirement_target: $(REQUIREMENT_TARGET)

requirement: $(POST_REQUIREMENT_TARGET)
