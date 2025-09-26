# CMake toolchain-file definitions

# Per-dependency configuration for CMake build
CMAKE_TOOLCHAIN_FILE_NAME = $(ARCH)-toolchain.cmake
CMAKE_TOOLCHAIN_FILE_WRK = $(WORK_DIR)/tc_vars.cmake
CMAKE_TOOLCHAIN_FILE_PKG = $(WORK_DIR)/$(PKG_DIR)/$(CMAKE_TOOLCHAIN_FILE_NAME)

ifeq ($(strip $(CMAKE_USE_TOOLCHAIN_FILE)),ON)
CMAKE_ARGS += -DCMAKE_TOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN_FILE_PKG)
endif

# Enforce unsetting all flags as using cross-file with the
# exception of PKG_CONFIG_LIBDIR to force default pkgconfig.
empty :=
space := $(empty) $(empty)
VARS_TO_CLEAN = AR AS CC CPP CXX LD LDSHARED OBJCOPY OBJDUMP RANLIB READELF STRIP \
                CFLAGS ADDITIONAL_CFLAGS CPPFLAGS ADDITIONAL_CPPFLAGS \
                CXXFLAGS ADDITIONAL_CXXFLAGS FFLAGS ADDITIONAL_FFLAGS \
                LDFLAGS ADDITIONAL_LDFLAGS PKG_CONFIG_PATH SYSROOT
ENV_FILTERED = $(shell env -i $(ENV) sh -c 'env' | \
    grep -v -E '^($(subst $(space),|,$(VARS_TO_CLEAN)))=' | \
    awk -F'=' '{if($$2 ~ / /) print $$1"=\""$$2"\""; else print $$0}' | \
    tr '\n' ' ')
ENV_CMAKE = $(addprefix -u ,$(VARS_TO_CLEAN)) $(ENV_FILTERED)
RUN_CMAKE = cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV_CMAKE)

.PHONY: $(CMAKE_TOOLCHAIN_FILE_PKG)
$(CMAKE_TOOLCHAIN_FILE_PKG):
	@$(MSG) Generating $(CMAKE_TOOLCHAIN_FILE_PKG)
	env $(MAKE) --no-print-directory cmake_pkg_toolchain > $(CMAKE_TOOLCHAIN_FILE_PKG) 2>/dev/null;

.PHONY: cmake_pkg_toolchain
cmake_pkg_toolchain:
	@cat $(CMAKE_TOOLCHAIN_FILE_WRK) ; \
	echo
ifeq ($(strip $(CMAKE_USE_NASM)),1)
ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
	@echo "# set assembly compiler" ; \
	echo "set(ENABLE_ASSEMBLY $(ENABLE_ASSEMBLY))" ; \
	echo "set(CMAKE_ASM_COMPILER $(CMAKE_ASM_COMPILER))" ; \
	echo
endif
endif
	@echo "# set default compiler flags for cross-compiling" ; \
	echo 'set(CMAKE_C_FLAGS $(strip "$(CFLAGS) $(CMAKE_C_FLAGS) $(ADDITIONAL_CFLAGS)"))' ; \
	echo 'set(CMAKE_CPP_FLAGS $(strip "$(CPPFLAGS) $(CMAKE_CPP_FLAGS) $(ADDITIONAL_CPPFLAGS)"))' ; \
	echo 'set(CMAKE_CXX_FLAGS $(strip "$(CXXFLAGS) $(CMAKE_CXX_FLAGS) $(ADDITIONAL_CXXFLAGS)"))'
ifeq ($(GCC_DEBUG_INFO),1)
	@echo "# set Debug compiler extra flags for cross-compiling (and deactivate C/C++ assert)" ; \
	echo 'set(CMAKE_C_FLAGS_DEBUG $(strip "$(GCC_DEBUG_FLAGS) -DNDEBUG"))' ; \
	echo 'set(CMAKE_CPP_FLAGS_DEBUG $(strip "$(GCC_DEBUG_FLAGS) -DNDEBUG"))' ; \
	echo 'set(CMAKE_CXX_FLAGS_DEBUG $(strip "$(GCC_DEBUG_FLAGS) -DNDEBUG"))'
endif
ifneq ($(strip $(CMAKE_DISABLE_EXE_LINKER_FLAGS)),1)
	@echo 'set(CMAKE_EXE_LINKER_FLAGS $(strip "$(LDFLAGS) $(CMAKE_EXE_LINKER_FLAGS) $(ADDITIONAL_LDFLAGS)"))'
endif
	@echo 'set(CMAKE_SHARED_LINKER_FLAGS $(strip "$(LDFLAGS) $(CMAKE_SHARED_LINKER_FLAGS) $(ADDITIONAL_LDFLAGS)"))' ; \
	echo
ifneq ($(strip $(BUILD_SHARED_LIBS)),)
	@echo "# build shared library" ; \
	echo "set(BUILD_SHARED_LIBS $(BUILD_SHARED_LIBS))"
endif
	@echo "# define library rpath" ; \
	echo "set(CMAKE_INSTALL_RPATH $(subst $() $(),:,$(CMAKE_INSTALL_RPATH)))" ; \
	echo "set(CMAKE_INSTALL_RPATH_USE_LINK_PATH $(CMAKE_INSTALL_RPATH_USE_LINK_PATH))" ; \
	echo "set(CMAKE_BUILD_WITH_INSTALL_RPATH $(CMAKE_BUILD_WITH_INSTALL_RPATH))" ; \
	echo
	@echo "# set pkg-config path" ; \
	echo 'set(ENV{PKG_CONFIG_LIBDIR} "$(abspath $(PKG_CONFIG_LIBDIR))")'
