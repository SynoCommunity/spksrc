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

# Completion status file
WHEEL_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)wheel_done

## python wheel specific configurations
include ../../mk/spksrc.wheel-env.mk

## python wheel specific configurations
include ../../mk/spksrc.crossenv.mk

## meson specific configurations
include ../../mk/spksrc.cross-cmake-env.mk

## meson specific configurations
include ../../mk/spksrc.cross-meson-env.mk

include ../../mk/spksrc.wheel-download.mk

#wheel_configure: wheel_download
#include ../../mk/spksrc.wheel-configure.mk
#
#wheel_compile: wheel_configure
#include ../../mk/spksrc.wheel-compile.mk
#
#wheel_install: wheel_compile
#include ../../mk/spksrc.wheel-install.mk
#
#all: wheel_install

##

ifneq ($(strip $(REQUIREMENT)),)
wheel: wheel_download
else

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
	@$(MSG) "Processing wheel for $(NAME)"

pre_wheel_target: wheel_msg_target

wheel-%:
ifneq ($(strip $(WHEELS)),)
	@$(MSG) $(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) WHEELS=\"$(WHEELS)\" wheel
	-@MAKEFLAGS= $(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) WHEELS="$(WHEELS)" wheel --no-print-directory
else
	$(error No wheel to process)
endif

build_wheel_target: SHELL:=/bin/bash
build_wheel_target: pre_wheel_target
ifneq ($(wildcard $(abspath $(addprefix $(WORK_DIR)/../,$(WHEELS)))),)
	@while IFS= read -r requirement ; do \
	   $(MSG) Processing requirement [$${requirement}] ; \
	   wheel=$${requirement#*requirements-*.txt:} ; \
	   file=$$(basename $${requirement%%:*}) ; \
	   case $${file} in \
	           requirements-pure.txt) type=pure ;; \
	      requirements-crossenv*.txt) type=crossenv ;; \
	           requirements-abi3.txt) type=abi3 ;; \
	                               *) type=$(WHEEL_DEFAULT_PREFIX) ;; \
	   esac ; \
	   if [ "$$(grep -s egg <<< $${wheel})" ]; then \
	      name=$$(echo $${wheel#*egg=} | cut -f1 -d=) ; \
	   else \
	      name=$$(echo $${wheel%%[<>=]=*} | sed -E "s/^(abi3|crossenv|pure)://") ; \
	   fi ; \
	   version=$$(echo $${wheel} | grep -oP '(?<=([<>=]=))[^ ]*' || echo "") ; \
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
#	   $(MSG) requirement: [$${requirement}] ; \
#	   $(MSG) file: [$${file}] ; \
#	   $(MSG) wheel: [$${wheel}] ; \
#	   $(MSG) name: [$${name}] ; \
#	   $(MSG) version: [$${version}] ; \
#	   $(MSG) type: [$${type}] ; \
	   $(MSG) $(MAKE) ARCH=$(ARCH) TCVERSION=$(TCVERSION) REQUIREMENT=\"$${wheel}\" WHEEL_NAME=\"$${name}\" WHEEL_VERSION=\"$${version}\" WHEEL_TYPE=\"$${type}\" wheel ; \
	   $(MAKE) ARCH="$(ARCH)" TCVERSION="$(TCVERSION)" REQUIREMENT="$${wheel}" WHEEL_NAME="$${name}" WHEEL_VERSION="$${version}" WHEEL_TYPE="$${type}" wheel --no-print-directory ; \
	done < <(sed '/^\#/d; /^\s*$$/d; s/\s* #.*//' $(wildcard $(abspath $(addprefix $(WORK_DIR)/../,$(WHEELS)))))
endif
ifneq ($(filter-out $(addprefix src/,$(notdir $(wildcard $(abspath $(addprefix $(WORK_DIR)/../,$(WHEELS)))))),$(WHEELS)),)
	@for requirement in $(filter-out $(addprefix src/,$(notdir $(wildcard $(abspath $(addprefix $(WORK_DIR)/../,$(WHEELS)))))),$(WHEELS)) ; do \
	   $(MSG) Processing requirement [$${requirement}] ; \
	   wheel=$$(echo $${requirement} | sed -E "s/^(abi3|crossenv|pure)://") ; \
	   case $${requirement} in \
	          abi3:*) type=abi3 ;; \
	      crossenv:*) type=crossenv ;; \
	          pure:*) type=pure ;; \
	               *) type=$(WHEEL_DEFAULT_PREFIX) ;; \
	   esac ; \
	   if [ "$$(grep -s egg <<< $${requirement})" ]; then \
	      name=$$(echo $${wheel#*egg=} | cut -f1 -d=) ; \
	   else \
	      name=$$(echo $${wheel%%[<>=]=*} | sed -E "s/^(abi3|crossenv|pure)://") ; \
	   fi ; \
	   version=$$(echo $${wheel} | grep -oP '(?<=([<>=]=))[^ ]*' || echo "") ; \
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
#	   $(MSG) requirement: [$${requirement}] ; \
#	   $(MSG) wheel: [$${wheel}] ; \
#	   $(MSG) name: [$${name}] ; \
#	   $(MSG) version: [$${version}] ; \
#	   $(MSG) type: [$${type}] ; \
	   $(MSG) $(MAKE) ARCH=$(ARCH) TCVERSION=$(TCVERSION) REQUIREMENT=\"$${wheel}\" WHEEL_NAME=\"$${name}\" WHEEL_VERSION=\"$${version}\" WHEEL_TYPE=\"$${type}\" wheel ; \
	   $(MAKE) ARCH="$(ARCH)" TCVERSION="$(TCVERSION)" REQUIREMENT="$${wheel}" WHEEL_NAME="$${name}" WHEEL_VERSION="$${version}" WHEEL_TYPE="$${type}" wheel --no-print-directory ; \
	done
endif

post_wheel_target: $(WHEEL_TARGET)

ifeq ($(wildcard $(WHEEL_COOKIE)),)
wheel: $(WHEEL_COOKIE)

$(WHEEL_COOKIE): $(POST_WHEEL_TARGET)
	$(create_target_dir)
	@touch -f $@
else
wheel: ;
endif

# endif REQUIREMENT non-empty
endif
