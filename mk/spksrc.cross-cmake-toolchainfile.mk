# CMake toolchain-file definitions

# Per-dependency configuration for CMake build
CMAKE_TOOLCHAIN_FILE_NAME = $(ARCH)-toolchain.cmake
CMAKE_TOOLCHAIN_FILE_WRK = $(WORK_DIR)/tc_vars.cmake
CMAKE_TOOLCHAIN_FILE_PKG = $(CMAKE_BUILD_DIR)/$(CMAKE_TOOLCHAIN_FILE_NAME)


ifeq ($(strip $(CMAKE_USE_TOOLCHAIN_FILE)),ON)
CMAKE_ARGS += -DCMAKE_TOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN_FILE_PKG)
endif

# Map DEFAULT_ENV definitions to filenames
TC_VARS_FILES := $(wildcard $(foreach b,$(DEFAULT_ENV),$(WORK_DIR)/tc_vars.$(b).mk))
# Include them (optional include)
-include $(TC_VARS_FILES)

# OpenSSL root for find_package(OpenSSL) (which ignores pkg-config): first dir of
# the ordered PKG_CONFIG_LIBDIR (cross-env.mk) providing libssl.so (local-first),
# else local staging.
CMAKE_OPENSSL_ROOT_DIR = $(abspath $(firstword $(foreach d,$(subst :,$(space),$(PKG_CONFIG_LIBDIR)),$(if $(wildcard $(patsubst %/lib/pkgconfig,%,$(d))/lib/libssl.so),$(patsubst %/lib/pkgconfig,%,$(d)),)) $(STAGING_INSTALL_PREFIX)))

# Meta staging roots for CMAKE_FIND_ROOT_PATH: cmake find_*() re-roots under it
# (MODE=ONLY), so meta libs (absolute) must be listed there to be found.
CMAKE_META_FIND_ROOTS = $(foreach d,$(META_PKG_CONFIG_LIBDIR),$(abspath $(patsubst %/lib/pkgconfig,%,$(d))))

.PHONY: $(CMAKE_TOOLCHAIN_FILE_PKG)
$(CMAKE_TOOLCHAIN_FILE_PKG):
ifeq ($(wildcard $(CMAKE_BUILD_DIR)),)
	@$(MSG) Creating CMake build directory: $(CMAKE_BUILD_DIR)
	@mkdir --parents $(CMAKE_BUILD_DIR)
endif
	@$(MSG) Generating $(CMAKE_TOOLCHAIN_FILE_PKG)
	@env $(ENV) $(MAKE) --no-print-directory cmake_pkg_toolchain > $(CMAKE_TOOLCHAIN_FILE_PKG) 2>/dev/null;

.PHONY: cmake_pkg_toolchain
cmake_pkg_toolchain:
	@cat $(CMAKE_TOOLCHAIN_FILE_WRK) ; \
	echo
	@echo "# Rust flags (linker, rpath, libs)" ; \
	echo "set(RUSTFLAGS" ; \
	echo "  \"-Clinker=\$${RUST_LINKER}\"" ; \
	echo $(call uniq,$(RUSTFLAGS) $(TC_EXTRA_RUSTFLAGS) $(ADDITIONAL_RUSTFLAGS)) | tr ' ' '\n' | sed -e "s/^/  \"/" -e "s/$$/\"/" ; \
	echo ")" ; \
	echo "set(ENV{RUSTFLAGS} \$${RUSTFLAGS})" ; \
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
	echo 'set(CMAKE_C_FLAGS "$(call uniq,$(CFLAGS) $(TC_EXTRA_CFLAGS) $(CMAKE_C_FLAGS) $(ADDITIONAL_CFLAGS))")' ; \
	echo 'set(CMAKE_CPP_FLAGS "$(call uniq,$(CPPFLAGS) $(CMAKE_CPP_FLAGS) $(ADDITIONAL_CPPFLAGS))")' ; \
	echo 'set(CMAKE_CXX_FLAGS "$(call uniq,$(CXXFLAGS) $(CMAKE_CXX_FLAGS) $(ADDITIONAL_CXXFLAGS))")'
ifneq ($(strip $(FFLAGS)),)
	@echo 'set(CMAKE_Fortran_FLAGS "$(call uniq,$(FFLAGS) $(CMAKE_Fortran_FLAGS) $(ADDITIONAL_FFLAGS))")'
endif
	@echo
ifeq ($(GCC_DEBUG_INFO),1)
	@echo "# set Debug compiler extra flags for cross-compiling (and deactivate C/C++ assert)" ; \
	echo 'set(CMAKE_C_FLAGS_DEBUG $(strip "$(GCC_DEBUG_FLAGS) -DNDEBUG") CACHE STRING "Debug C flags" FORCE)' ; \
	echo 'set(CMAKE_CPP_FLAGS_DEBUG $(strip "$(GCC_DEBUG_FLAGS) -DNDEBUG") CACHE STRING "Debug CPP flags" FORCE)' ; \
	echo 'set(CMAKE_CXX_FLAGS_DEBUG $(strip "$(GCC_DEBUG_FLAGS) -DNDEBUG") CACHE STRING "Debug CXX flags" FORCE)'
ifneq ($(strip $(FFLAGS)),)
	@echo 'set(CMAKE_Fortran_FLAGS_DEBUG $(strip "$(GCC_DEBUG_FLAGS) -DNDEBUG") CACHE STRING "Debug Fortran flags" FORCE)'
endif
	@echo
endif
ifneq ($(strip $(CMAKE_DISABLE_EXE_LINKER_FLAGS)),1)
	@echo 'set(CMAKE_EXE_LINKER_FLAGS "$(call uniq,$(LDFLAGS) $(CMAKE_EXE_LINKER_FLAGS) $(ADDITIONAL_LDFLAGS))")'
endif
	@echo 'set(CMAKE_SHARED_LINKER_FLAGS "$(call uniq,$(LDFLAGS) $(CMAKE_SHARED_LINKER_FLAGS) $(ADDITIONAL_LDFLAGS))")' ; \
	echo
ifneq ($(strip $(BUILD_SHARED_LIBS)),)
	@echo "# build shared library" ; \
	echo "set(BUILD_SHARED_LIBS $(BUILD_SHARED_LIBS))"
endif
	@echo "# define library rpath" ; \
	echo "set(CMAKE_INSTALL_RPATH $(subst $() $(),:,$(CMAKE_INSTALL_RPATH)))" ; \
	echo "set(CMAKE_INSTALL_RPATH_USE_LINK_PATH $(CMAKE_INSTALL_RPATH_USE_LINK_PATH))" ; \
	echo
	@echo "# set pkg-config path" ; \
	echo 'set(ENV{PKG_CONFIG_LIBDIR} "$(subst $(space),:,$(abspath $(subst :,$(space),$(PKG_CONFIG_LIBDIR))))")'
	@echo "# OpenSSL root (find_package(OpenSSL) ignores pkg-config)" ; \
	echo 'set(OPENSSL_ROOT_DIR "$(CMAKE_OPENSSL_ROOT_DIR)")'
ifneq ($(strip $(CMAKE_META_FIND_ROOTS)),)
	@echo "# meta staging roots for find_library/find_path/find_package" ; \
	$(foreach r,$(CMAKE_META_FIND_ROOTS),echo 'list(APPEND CMAKE_FIND_ROOT_PATH "$(r)")' ;)
endif
