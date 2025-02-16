# Build CMake programs
#
# prerequisites:
# - cross/module depends on meson + ninja
#

# Force path to pkg-config for cross-building
ENV += PKG_CONFIG=/usr/bin/pkg-config

# CMake - begin
ifeq ($(strip $(CMAKE_USE_NINJA)),1)

# Set default build directory
ifeq ($(strip $(NINJA_BUILD_DIR)),)
NINJA_BUILD_DIR = $(CMAKE_BUILD_DIR)
endif

# set default use destdir
ifeq ($(strip $(NINJA_USE_DESTDIR)),)
ifneq ($(strip $(CMAKE_USE_DESTDIR)),)
NINJA_USE_DESTDIR = $(CMAKE_USE_DESTDIR)
endif
endif

# set default destdir directory
ifeq ($(strip $(NINJA_DESTDIR)),)
NINJA_DESTDIR = $(CMAKE_DESTDIR)
endif

# CMake - end
# Meson - begin (default)
else

# Set default build directory
NINJA_BUILD_DIR = $(MESON_BUILD_DIR)
# set default use destdir
NINJA_USE_DESTDIR = 1
# set default destdir directory
NINJA_DESTDIR = $(INSTALL_DIR)

# Meson - end (default)
endif

# compile
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = ninja_compile_target
endif

# install
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = ninja_install_target
endif

# post-install
ifeq ($(strip $(GCC_NO_DEBUG_INFO)),1)
ifeq ($(strip $(POST_INSTALL_TARGET)),)
POST_INSTALL_TARGET = ninja_post_install_target
endif
endif

###
#
# python wheel using meson use-case
ifeq ($(strip $(MESON_PYTHON)),1)

# Define where is located the crossenv
CROSSENV_WHEEL_PATH = $(firstword $(wildcard $(WORK_DIR)/crossenv-$(PKG_NAME)-$(PKG_VERS) $(WORK_DIR)/crossenv-$(PKG_NAME) $(WORK_DIR)/crossenv-default))

# If using spksrc.python.mk with PYTHON_STAGING_PREFIX defined
# then redirect STAGING_INSTALL_PREFIX so rust
# wheels can find openssl and other libraries
ifneq ($(wildcard $(PYTHON_STAGING_PREFIX)),)
STAGING_INSTALL_PREFIX := $(PYTHON_STAGING_PREFIX)
endif
endif

###

.PHONY: ninja_compile_target

# default ninja compile:
ninja_compile_target:
	@$(MSG) - Ninja compile
	@$(MSG)    - Ninja build path = $(WORK_DIR)/$(PKG_DIR)/$(NINJA_BUILD_DIR)
ifeq ($(strip $(CMAKE_USE_NINJA)),1)
	@$(MSG)    - Use NASM = $(CMAKE_USE_NASM)
endif
ifeq ($(strip $(MESON_CROSSENV)),1)
	@$(MSG)    - Python wheel = $(MESON_CROSSENV)
	$(foreach e,$(shell cat $(CROSSENV_WHEEL_PATH)/build/python-cc.mk),$(eval $(e)))
	@. $(CROSSENV) ; \
	if [ -e "$(CROSSENV)" ] ; then \
	   export PATH=$${PATH}:$(CROSSENV_PATH)/build/bin ; \
	   $(MSG) "crossenv: [$(CROSSENV)]" ; \
	   $(MSG) "cython: [$$(which cython)]" ; \
	else \
	   echo "ERROR: crossenv not found!" ; \
	   exit 2 ; \
	fi ; \
	$(RUN) PATH=$${PATH} ninja -C $(NINJA_BUILD_DIR)
else
	$(RUN) ninja -C $(NINJA_BUILD_DIR)
endif

.PHONY: ninja_install_target

# default ninja install:
ninja_install_target:
	@$(MSG) - Ninja install
	@$(MSG)    - Ninja installation path = $(NINJA_DESTDIR)
	@$(MSG)    - Ninja use DESTDIR = $(NINJA_USE_DESTDIR)
ifeq ($(strip $(NINJA_USE_DESTDIR)),0)
	$(RUN) ninja -C $(NINJA_BUILD_DIR) install
else
	$(RUN) DESTDIR=$(NINJA_DESTDIR) ninja -C $(NINJA_BUILD_DIR) install
endif

.PHONY: ninja_post_install_target

# default ninja post-install: clean
ninja_post_install_target:
	@$(MSG) - Ninja post-install \(clean\)
	$(RUN) ninja -C $(NINJA_BUILD_DIR) clean
	$(RUN) rm -f $(NINJA_BUILD_DIR)/build.ninja
	$(RUN) rm -f $(NINJA_BUILD_DIR)/compile_commands.json
