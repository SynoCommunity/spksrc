### Wheel rules
# Process wheels for modules listed in WHEELS. 
#   1. wheel_download
#   2. wheel_compile
#   3. wheel_install
#
# Targets are executed in the following order:
#  wheel_msg_target
#  pre_wheel_target   (override with PRE_WHEEL_TARGET)
#  wheel_target (override with WHEEL_TARGET)
#  post_wheel_target  (override with POST_WHEEL_TARGET)
# Variables:
#  WHEELS             List of wheels to go through

# When wheel is called from:
#                  spksrc.spk.mk: MAKECMDGOALS is empty (needs to be set to wheel)
# make wheel-<arch>-<tcversion> : MAKECMDGOALS is wheel
#          make download-wheels : MAKECMDGOALS is download-wheels
WHEEL_GOAL := $(if $(MAKECMDGOALS),$(MAKECMDGOALS),wheel)

# Completion status file
WHEEL_COOKIE = $(WORK_DIR)/.wheel_done

## python wheel specific configurations
include ../../mk/spksrc.wheel-env.mk

## python wheel specific configurations
include ../../mk/spksrc.crossenv.mk

## meson specific configurations
include ../../mk/spksrc.cross-cmake-env.mk

## meson specific configurations
include ../../mk/spksrc.cross-meson-env.mk

include ../../mk/spksrc.wheel-download.mk

wheel_compile: wheel_download
include ../../mk/spksrc.wheel-compile.mk

wheel_install: wheel_compile
include ../../mk/spksrc.wheel-install.mk

##

ifneq ($(and $(WHEEL_NAME),$(or (WHEEL_VERISON),$(WHEEL_URL))),)
download-wheels: wheel_download
wheel: wheel_install
else

ifeq ($(strip $(PRE_WHEEL_TARGET)),)
PRE_WHEEL_TARGET = pre_wheel_target
else
$(PRE_WHEEL_TARGET): wheel_msg_target
endif
ifeq ($(strip $(WHEEL_TARGET)),)
WHEEL_TARGET = wheel_target
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
	@$(MSG) $(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) WHEELS=\"$(WHEELS)\" wheel | tee --append $(WHEEL_LOG)
	@MAKEFLAGS= $(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) WHEELS="$(WHEELS)" wheel --no-print-directory || false
else
	$(error No python wheel to process)
endif

wheel_target: SHELL:=/bin/bash
wheel_target: pre_wheel_target
ifneq ($(wildcard $(abspath $(addprefix $(WORK_DIR)/../,$(WHEELS)))),)
	@set -e ; \
	for requirement in $(wildcard $(abspath $(addprefix $(WORK_DIR)/../,$(WHEELS)))) ; do \
	   $(MSG) $(MAKE) ARCH=$(ARCH) TCVERSION=$(TCVERSION) REQUIREMENT=\"$${requirement}\" REQUIREMENT_GOAL=\"$(WHEEL_GOAL)\" requirement ; \
	   MAKEFLAGS= $(MAKE) ARCH="$(ARCH)" TCVERSION="$(TCVERSION)" REQUIREMENT="$${requirement}" REQUIREMENT_GOAL="$(WHEEL_GOAL)" requirement --no-print-directory || false ; \
	done
else
	@set -e ; \
	for requirement in $(filter-out $(addprefix src/,$(notdir $(wildcard $(abspath $(addprefix $(WORK_DIR)/../,$(WHEELS)))))),$(WHEELS)) ; do \
	   $(MSG) $(MAKE) ARCH=$(ARCH) TCVERSION=$(TCVERSION) REQUIREMENT=\"$${requirement}\" REQUIREMENT_GOAL=\"$(WHEEL_GOAL)\" requirement ; \
	   MAKEFLAGS= $(MAKE) ARCH="$(ARCH)" TCVERSION="$(TCVERSION)" REQUIREMENT="$${requirement}" REQUIREMENT_GOAL="$(WHEEL_GOAL)" requirement --no-print-directory || false ; \
	done
endif

download-wheels: $(WHEEL_TARGET)

post_wheel_target: $(WHEEL_TARGET) install_python_wheel

ifeq ($(wildcard $(WHEEL_COOKIE)),)
wheel: $(WHEEL_COOKIE)

$(WHEEL_COOKIE): $(POST_WHEEL_TARGET)
	$(create_target_dir)
	@touch -f $@

else
wheel: ;
endif

# endif $(and $(WHEEL_NAME),$(or (WHEEL_VERISON),$(WHEEL_URL))) non-empty
endif
