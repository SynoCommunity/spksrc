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

# Does this toolchain ship a Fortran compiler? Ask it, rather than tabulate per
# DSM/arch. A hardcoded "7.x, SRM 1.3 and 6.2.4-x64 have Fortran" list is a proxy
# that only holds for the stock toolchains: it cannot see a compiler swapped in
# underneath -- a gcc8 overlay, say, adds gfortran to a 6.2.4 arch the list calls
# Fortran-less. Probing the actual binary stays correct whatever provides it.
#
# Lazy on purpose, exactly like TC_HAS_LIBATOMIC below: the ifneq's that read it
# force the wildcard, and it only needs to be right where it is consumed -- the
# tc_vars sub-make, which re-parses this file after the toolchain is extracted, so
# the binary is there to find. Cross packages read the baked tc_vars result and
# never re-probe. (At the first, pre-extract parse it is empty; that value is not
# consumed -- the sub-make's is.)
TC_HAS_FORTRAN = $(if $(wildcard $(TC_WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)gfortran),1)

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

# TC_EXTRA_LDFLAGS carries the ABI to the link and adds what a toolchain declares
# for the linker. The ABI (TC_EXTRA_BUILD_FLAGS -- the -march/-mcpu/... flags folded
# into every language just below) must reach the gcc link driver too, so it picks the
# right multilib and startfiles. On top of that: -lrt for glibc<2.17 (clock_gettime)
# and -latomic for targets without native 64-bit atomics (ARMv5, PowerPC e500v2),
# both previously carried as per-package arch lists (cups/flac). -latomic is dropped
# where the gcc does not ship it -- a gcc that old predates the __atomic_* builtins
# and emits __sync_* instead, so it never needs the library. Kept lazy via a captured
# copy: TC_HAS_LIBATOMIC (just above) runs the compiler, not extracted yet while the
# toolchain is being parsed.
#
# These libs are declared toolchain-wide now, not per package, so they would land on
# every link -- yet most binaries call neither clock_gettime nor an atomic builtin.
# Wrap them in -Wl,--as-needed so the linker records a librt/libatomic dependency
# only where the objects actually reference a symbol it provides, and -Wl,--no-as-needed
# restores the default right after: the policy change is scoped to these two libs and
# never drops a package library kept only for its side effects.
_tc_comma := ,
_TC_EXTRA_LDFLAGS := $(TC_EXTRA_LDFLAGS)
_tc_ld_syslibs = $(if $(TC_HAS_LIBATOMIC),$(_TC_EXTRA_LDFLAGS),$(filter-out -latomic,$(_TC_EXTRA_LDFLAGS)))
TC_EXTRA_LDFLAGS = $(TC_EXTRA_BUILD_FLAGS) $(if $(strip $(_tc_ld_syslibs)),-Wl$(_tc_comma)--as-needed $(_tc_ld_syslibs) -Wl$(_tc_comma)--no-as-needed)

# TC_EXTRA_BUILD_FLAGS holds the target's ABI/arch flags (-march, -mcpu, -mfpu,
# -mfloat-abi, -mthumb, ...). They select the ABI, so they must reach every language
# (and the link, above) -- passing them only to CFLAGS would silently build C++ or
# Fortran objects with a different ABI. Fold them once into each per-language
# TC_EXTRA_<LANG>FLAGS, which then becomes the single residual list that language
# reads: the ABI first, then whatever a toolchain adds for that language -- always
# last in the chain, and a clean place to extend.
#
# TC_EXTRA_RUSTFLAGS is left out on purpose: rustc takes its ABI another way
# (-Ctarget-cpu, in TC_EXTRA_RUSTFLAGS already), and rust's C dependencies get the
# build flags through CFLAGS_<target> = TC_EXTRA_CFLAGS in tc-rust.mk.
TC_EXTRA_CFLAGS   := $(TC_EXTRA_BUILD_FLAGS) $(TC_EXTRA_CFLAGS)
TC_EXTRA_CPPFLAGS := $(TC_EXTRA_BUILD_FLAGS) $(TC_EXTRA_CPPFLAGS)
TC_EXTRA_CXXFLAGS := $(TC_EXTRA_BUILD_FLAGS) $(TC_EXTRA_CXXFLAGS)
TC_EXTRA_FFLAGS   := $(TC_EXTRA_BUILD_FLAGS) $(TC_EXTRA_FFLAGS)

####
# Define regular build flags -- each language reads its own residual list, ABI
# already folded in, kept last so a package/toolchain addition stays at the end.

CFLAGS += -I$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE))
CFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
CFLAGS += $(TC_EXTRA_CFLAGS)

CPPFLAGS += -I$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE))
CPPFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
CPPFLAGS += $(TC_EXTRA_CPPFLAGS)

CXXFLAGS += -I$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE))
CXXFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
CXXFLAGS += $(TC_EXTRA_CXXFLAGS)

ifneq ($(strip $(TC_HAS_FORTRAN)),)
FFLAGS += -I$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE))
FFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
FFLAGS += $(TC_EXTRA_FFLAGS)
endif

LDFLAGS += -L$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_LIBRARY))
LDFLAGS += -L$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
LDFLAGS += -Wl,--rpath-link,$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
LDFLAGS += -Wl,--rpath,$(abspath $(INSTALL_PREFIX)/lib)
LDFLAGS += $(TC_EXTRA_LDFLAGS)

RUSTFLAGS += -Clink-arg=-L$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_LIBRARY))
RUSTFLAGS += -Clink-arg=-L$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
RUSTFLAGS += -Clink-arg=-Wl,--rpath-link,$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib)
RUSTFLAGS += -Clink-arg=-Wl,--rpath,$(abspath $(INSTALL_PREFIX)/lib)
