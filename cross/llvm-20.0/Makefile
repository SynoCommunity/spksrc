PKG_NAME = llvm-20.0
PKG_LLVM_MAJ = 20
PKG_VERS = $(PKG_LLVM_MAJ).1.8
PKG_EXT = tar.xz
PKG_DIST_NAME = llvm-project-$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/llvm/llvm-project/releases/download/llvmorg-$(PKG_VERS)
PKG_DIR = llvm-project-$(PKG_VERS).src

HOMEPAGE = https://llvm.org/
COMMENT = Minimal LLVM 20 build for llvmlite
LICENSE = Apache v2.0 with LLVM Exceptions

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS) comcerto2k
REQUIRED_MIN_SRM = 1.3

# Dependencies
DEPENDS += cross/zlib
CMAKE_ARGS += -DLLVM_ENABLE_ZLIB=ON
CMAKE_ARGS += -DLLVM_ENABLE_ZSTD=OFF
_LLVM_SYSROOT = $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_SYSROOT)
_LLVM_LDFLAGS = -L$(_LLVM_SYSROOT)/lib -L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -Wl,--rpath-link,$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -Wl,--rpath,$(INSTALL_PREFIX)/lib
# Toolchain wraps staging -L in CMAKE_EXE_LINKER_FLAGS; disable to prevent
# leaking into LLVM's native sub-build. Pass sysroot via CMAKE_ARGS instead.
export CMAKE_DISABLE_EXE_LINKER_FLAGS = 1
CMAKE_ARGS += -DCMAKE_EXE_LINKER_FLAGS="$(_LLVM_LDFLAGS)"
CMAKE_ARGS += -DCMAKE_SHARED_LINKER_FLAGS="$(_LLVM_LDFLAGS)"

# Directories
CMAKE_DIR = $(WORK_DIR)/$(PKG_DIR)/llvm

# CMake arguments
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=MinSizeRel
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DLLVM_DEFAULT_TARGET_TRIPLE=$(TC_TARGET)
CMAKE_ARGS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF
CMAKE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CMAKE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON
CMAKE_ARGS += -DLLVM_ENABLE_RTTI=ON
CMAKE_ARGS += -DLLVM_ENABLE_WARNINGS=OFF
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF
CMAKE_ARGS += -DLLVM_BUILD_TESTS=OFF
CMAKE_ARGS += -DLLVM_BUILD_DOCS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_DOCS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_EXAMPLES=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -Wno-dev

# Remove build warnings
ADDITIONAL_CXXFLAGS  = -Wno-parentheses
ADDITIONAL_CXXFLAGS += -Wno-dangling-reference

# Remove aarch64 libraries from staging before native sub-build
# LLVM_ENABLE_ZSTD=OFF so cross build doesn't need zstd
COMPILE_TARGET = my_llvm_compile

include ../../mk/spksrc.cross-cmake.mk

# Prevent native sub-build from finding aarch64 libraries
export CMAKE_DISABLE_EXE_LINKER_FLAGS = 1
cmake_generate_toolchain_file:
	$(MAKE) --no-print-directory DEFAULT_ENV="flags rust" $(CMAKE_TOOLCHAIN_FILE_PKG)
	@sed -i '/set(ENV{PKG_CONFIG_LIBDIR}/d' $(CMAKE_TOOLCHAIN_FILE_PKG)

.PHONY: my_llvm_compile
my_llvm_compile:
	@_staging="$(INSTALL_DIR)$(INSTALL_PREFIX)"; \
	_backup="$(CMAKE_BUILD_DIR)/.zstd_backup"; \
	mkdir -p "$${_backup}"; \
	for f in libzstd.so libzstd.so.1 libzstd.so.1.5.7; do \
	   if [ -f "$${_staging}/lib/$$f" ]; then \
	      mv -f "$${_staging}/lib/$$f" "$${_backup}/"; \
	   fi; \
	done; \
	$(RUN) cmake --build $(CMAKE_BUILD_DIR) -j $(NCPUS) || true; \
	_rc=$$?; \
	for f in libzstd.so libzstd.so.1 libzstd.so.1.5.7; do \
	   if [ -f "$${_backup}/$$f" ]; then \
	      mv -f "$${_backup}/$$f" "$${_staging}/lib/"; \
	   fi; \
	done; \
	rm -rf "$${_backup}"; \
	exit $$_rc

# ARCH specific target selection
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=ARM
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=AArch64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
endif
