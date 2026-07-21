###############################################################################
# spksrc.toolchain/tc-flags.mk
#
# Defines compiler, linker, and language tool defaults for the toolchain.
#
# This file:
#  - derives missing toolchain paths (prefix, include, library)
#  - detects optional language support (Fortran)
#  - declares tool mappings (gcc, g++, ld, ar, gfortran, etc.)
#  - assembles default build flags for C, C++, Fortran, and Rust
#
# Variables:
#  TC_PREFIX       : Toolchain binary prefix (<target>-)
#  TC_INCLUDE      : Toolchain include directory (sysroot)
#  TC_LIBRARY      : Toolchain library directory (sysroot)
#  TC_HAS_FORTRAN  : Indicates availability of gfortran
#  TOOLS           : Logical-to-compiler tool mapping
#
# Flags defined:
#  CFLAGS / CPPFLAGS / CXXFLAGS / FFLAGS
#  LDFLAGS
#  RUSTFLAGS
#
# Notes:
#  - Fortran support is inferred from TC_VERS and ARCH, not from filesystem.
#  - Flags include both toolchain sysroot and package install paths.
#
###############################################################################

ifeq ($(strip $(TC_PREFIX)),)
TC_PREFIX = $(TC_TARGET)-
endif

ifeq ($(strip $(TC_INCLUDE)),)
TC_INCLUDE = $(TC_SYSROOT)/usr/include
endif

ifeq ($(strip $(TC_LIBRARY)),)
TC_LIBRARY = $(TC_SYSROOT)/lib
endif

####
# Define capabilities

# we can't check whether gfortran exists, because toolchain is not yet extracted
ifeq ($(strip $(firstword $(subst ., ,$(TC_VERS)))),7)
TC_HAS_FORTRAN = 1
else ifeq ($(strip $(TC_VERS)),1.3)
TC_HAS_FORTRAN = 1
else ifeq ($(strip $(TC_VERS)),6.2.4)
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
TC_HAS_FORTRAN = 1
endif
endif

TOOLS = ld ldshared:"gcc -shared" cpp nm cc:gcc as ranlib cxx:g++ ar strip objdump objcopy readelf
ifneq ($(strip $(TC_HAS_FORTRAN)),)
TOOLS += fc:gfortran
endif

# Does this toolchain's gcc ship libatomic? Ask it, rather than tabulate.
#
# A target without native 64-bit atomics (ARMv5, PowerPC e500v2) makes gcc emit
# calls into libatomic, which the link then has to resolve. But the library only
# ships from gcc 4.7 on, and handing -latomic to an older gcc is fatal ("cannot
# find -latomic"). Availability is the exact criterion, not a proxy: a gcc old
# enough to lack libatomic also predates the __atomic_* builtins, emits __sync_*
# instead, and so never needs the library. One question answers both.
TC_HAS_LIBATOMIC = $(if $(filter /%,$(shell $(TC_WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)gcc -print-file-name=libatomic.so 2>/dev/null)),1)

# Link flags a TOOLCHAIN declares for itself, beside TC_EXTRA_BUILD_FLAGS: what the
# target needs from the linker, stated once where it is known. Packages carry this
# today as arch lists -- cups enumerates ARMv5/old-PPC to add -lrt (exactly the
# toolchains whose glibc predates 2.17, when clock_gettime moved into libc), flac
# adds -lrt everywhere.
#
# -latomic is dropped in place when the gcc does not ship it (a gcc that old also
# predates the __atomic_* builtins, so it never needs the library), which keeps
# TC_EXTRA_LDFLAGS the single variable every consumer reads. Done via a captured
# copy so it stays lazy: TC_HAS_LIBATOMIC runs the compiler, which is not yet
# extracted while the toolchain itself is being parsed.
_TC_EXTRA_LDFLAGS := $(TC_EXTRA_LDFLAGS)
TC_EXTRA_LDFLAGS = $(if $(TC_HAS_LIBATOMIC),$(_TC_EXTRA_LDFLAGS),$(filter-out -latomic,$(_TC_EXTRA_LDFLAGS)))

####
# Define regular build flags
#
# TC_EXTRA_BUILD_FLAGS holds the target's ABI/arch flags (-march, -mcpu, -mfpu,
# -mfloat-abi, -mthumb, ...). They select the ABI, so they must reach every
# language AND the link: C, C++, the preprocessor, Fortran, and the gcc link
# driver, which reads them to pick the right multilib and startfiles. Passing
# them only to CFLAGS would silently build C++ or Fortran objects with a
# different ABI. The per-language TC_EXTRA_<LANG>FLAGS beside them are for
# genuinely language-specific extras (none in the tree today).

CFLAGS += -I$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE))
CFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
CFLAGS += $(TC_EXTRA_BUILD_FLAGS) $(TC_EXTRA_CFLAGS)

CPPFLAGS += -I$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE))
CPPFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
CPPFLAGS += $(TC_EXTRA_BUILD_FLAGS) $(TC_EXTRA_CPPFLAGS)

CXXFLAGS += -I$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE))
CXXFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
CXXFLAGS += $(TC_EXTRA_BUILD_FLAGS) $(TC_EXTRA_CXXFLAGS)

ifneq ($(strip $(TC_HAS_FORTRAN)),)
FFLAGS += -I$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE))
FFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
FFLAGS += $(TC_EXTRA_BUILD_FLAGS) $(TC_EXTRA_FFLAGS)
endif

LDFLAGS += -L$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_LIBRARY)) $(TC_EXTRA_BUILD_FLAGS)
LDFLAGS += -L$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
LDFLAGS += -Wl,--rpath-link,$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
LDFLAGS += -Wl,--rpath,$(abspath $(INSTALL_PREFIX)/lib)
LDFLAGS += $(TC_EXTRA_LDFLAGS)

RUSTFLAGS += -Clink-arg=-L$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_LIBRARY))
RUSTFLAGS += -Clink-arg=-L$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
RUSTFLAGS += -Clink-arg=-Wl,--rpath-link,$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
RUSTFLAGS += -Clink-arg=-Wl,--rpath,$(abspath $(INSTALL_PREFIX)/lib)
