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
# Lazy on purpose, like TC_HAS_LIBATOMIC: the ifneq's that read it
# force the wildcard, and it only needs to be right where it is consumed -- the
# tc_vars sub-make, which re-parses this file after the toolchain is extracted, so
# the binary is there to find. Cross packages read the baked tc_vars result and
# never re-probe. (At the first, pre-extract parse it is empty; that value is not
# consumed -- the sub-make's is.)
TC_HAS_FORTRAN = $(if $(wildcard $(TC_WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)gfortran),1)

# The tools a binutils overlay provides, so tc_vars.mk can take those from it when one is
# active. A future gcc overlay gets its own TC_GCC_TOOLS list the same way.
TC_BINUTILS_TOOLS = ld as ar nm ranlib strip objdump objcopy readelf

TOOLS = ld ldshared:"gcc -shared" cpp nm cc:gcc as ranlib cxx:g++ ar strip objdump objcopy readelf
ifneq ($(strip $(TC_HAS_FORTRAN)),)
TOOLS += fc:gfortran
endif

# TC_EXTRA_LDFLAGS carries the ABI to the link and adds what a toolchain declares
# for the linker. The ABI (TC_EXTRA_BUILD_FLAGS -- the -march/-mcpu/... flags folded
# into every language just below) must reach the gcc link driver too, so it picks the
# right multilib and startfiles. On top of that: -lrt for glibc<2.17 (clock_gettime)
# and -latomic for targets without native 64-bit atomics (ARMv5, PowerPC e500v2),
# both previously carried as per-package arch lists (cups/flac). -latomic is dropped
# where the gcc does not ship it -- a gcc that old predates the __atomic_* builtins
# and emits __sync_* instead, so it never needs the library. Kept lazy via a captured
# copy: TC_HAS_LIBATOMIC runs the compiler, not extracted yet while the
# toolchain is being parsed.
#
# These libs are declared toolchain-wide now, not per package, so they would land on
# every link -- yet most binaries call neither clock_gettime nor an atomic builtin.
# Wrap them in -Wl,--as-needed so the linker records a librt/libatomic dependency
# only where the objects actually reference a symbol it provides, and -Wl,--no-as-needed
# restores the default right after: the policy change is scoped to these two libs and
# never drops a package library kept only for its side effects.
# The ABI flags a build compiles with. The Synology gcc is the reference an overlay must
# match to stay binary-compatible, so each overlay consumer is SEEDED from the legacy
# toolchain -- but it carries its own copy, and that copy wins while it is active.
#
# The two are identical everywhere today; the indirection is the point. A compiler that
# spells or defaults differently -- a future gcc-12, or gcc 8.5 already on the archs whose
# 2008 gcc under-declared its ABI -- is then corrected next to itself, instead of by
# editing a legacy toolchain every other package still builds against.
_TC_LEGACY_BUILD_FLAGS := $(TC_EXTRA_BUILD_FLAGS)
_TC_OVERLAY_BUILD_FLAGS = $(if $(OVERLAY_GCC_ON),$(shell sed -n 's/^TC_EXTRA_BUILD_FLAGS *= *//p' $(TC_OVERLAY_GCC)/Makefile 2>/dev/null))
TC_EXTRA_BUILD_FLAGS = $(or $(_TC_OVERLAY_BUILD_FLAGS),$(_TC_LEGACY_BUILD_FLAGS))

_tc_comma := ,
_TC_EXTRA_LDFLAGS := $(TC_EXTRA_LDFLAGS)
_tc_ld_syslibs = $(if $(TC_HAS_LIBATOMIC),$(_TC_EXTRA_LDFLAGS),$(filter-out -latomic,$(_TC_EXTRA_LDFLAGS)))

# LDFLAGS precedes the objects, so --as-needed drops libatomic before anything needs it.
# Harmless on the 2008 compilers (no libatomic -> filtered above), fatal under gcc 8.5,
# which emits __atomic_*_8 calls (openssl3/ppc853x). Keep it outside the bracket.
_tc_ld_atomic  = $(if $(OVERLAY_GCC_ON),$(filter -latomic,$(_tc_ld_syslibs)))
_tc_ld_needed  = $(filter-out $(_tc_ld_atomic),$(_tc_ld_syslibs))
TC_EXTRA_LDFLAGS = $(TC_EXTRA_BUILD_FLAGS) $(if $(strip $(_tc_ld_needed)),-Wl$(_tc_comma)--as-needed $(_tc_ld_needed) -Wl$(_tc_comma)--no-as-needed) $(_tc_ld_atomic)

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

# The toolchain's declared include dir. Under a gcc overlay it moves to -idirafter, the
# END of the search chain, instead of -I at the front.
#
# It cannot simply be dropped: it carries headers the sysroot does not (FlexLexer.h,
# sysfs/ on ppc853x-5.2), and packages do use them. But it cannot stay in front either.
# On most archs it names the very directory gcc already ends on and is merely redundant;
# on ppc853x-5.2 it names a different tree -- TC_INCLUDE is <target>/include, the gcc
# 4.3.7 headers, while the real sysroot is <target>/libc/usr/include -- and ahead of gcc
# 8.5's own it redeclares what the compiler provides: "redundant redeclaration of
# 'ftruncate64'", "'INT32_MAX' was not declared". Its stale c++/ subtree is the same trap.
#
# -idirafter keeps every header that is only there, and lets gcc's own win wherever both
# have one. Unlike -L this is not a reordering: gcc orders its include chain correctly by
# itself, it just must not be overruled from the front.
TC_INCLUDE_FLAG = $(if $(OVERLAY_GCC_ON),-idirafter ,-I)$(abspath $(TC_WORK_DIR)/$(TC_TARGET)/$(TC_INCLUDE))

CFLAGS += $(TC_INCLUDE_FLAG)
CFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
CFLAGS += $(TC_EXTRA_CFLAGS)

CPPFLAGS += $(TC_INCLUDE_FLAG)
CPPFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
CPPFLAGS += $(TC_EXTRA_CPPFLAGS)

CXXFLAGS += $(TC_INCLUDE_FLAG)
CXXFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
CXXFLAGS += $(TC_EXTRA_CXXFLAGS)

ifneq ($(strip $(TC_HAS_FORTRAN)),)
FFLAGS += $(TC_INCLUDE_FLAG)
FFLAGS += -I$(abspath $(INSTALL_DIR)/$(INSTALL_PREFIX)/include)
FFLAGS += $(TC_EXTRA_FFLAGS)
endif

# The gcc overlay's own runtimes come FIRST. --enable-version-specific-runtime-libs puts
# them in lib/gcc/<target>/<vers>/, and the sysroot below still holds the vendor gcc's
# libstdc++ -- 2008-era on ppc853x. Left in the default order the link picks that one and
# fails on the C++11 ABI ("undefined reference to std::__cxx11::basic_string"), because
# gcc 8.5 compiles into the __cxx11 namespace the old library never had. Wildcard rather
# than a composed path: the directory only exists once the consumer is extracted.
#
# --rpath-link as well as -L: ld does NOT use -L to resolve a shared library's transitive
# DT_NEEDED. Without it, a C program linking a C++ .so finds libstdc++.so.6 through the
# sysroot instead -- the vendor's -- and fails on __cxx11 even though -L was right.
ifeq ($(OVERLAY_GCC_ON),1)
_TC_OVERLAY_GCC_LIBS = $(wildcard $(TC_OVERLAY_GCC)/work/install/usr/local/lib/gcc/$(TC_TARGET)/*)
LDFLAGS += $(addprefix -L,$(_TC_OVERLAY_GCC_LIBS))
LDFLAGS += $(addprefix -Wl$(_tc_comma)--rpath-link$(_tc_comma),$(_TC_OVERLAY_GCC_LIBS))
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
