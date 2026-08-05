TC_ARCH = ppc853x
TC_VERS = 5.2
TC_KERNEL = 2.6.32
TC_GLIBC = 2.8
TC_GCC = 4.3.7

TC_DIST = 853x-gcc4374_eglibc2874_qoriq-GPL
TC_DIST_SITE_URL = https://github.com/SynoCommunity/spksrc/releases/download/
TC_DIST_SITE_PATH = toolchains%2Fdsm5.2

TC_TARGET = powerpc-none-linux-gnuspe
TC_SYSROOT = $(TC_TARGET)
TC_INCLUDE = $(TC_SYSROOT)/include
TC_EXTRA_BUILD_FLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double
# +spe gives LLVM the SPE FP path for BOTH f32 (efs*) and f64 (efd*), matching the C
# toolchain's -mfloat-gprs=double SPE ABI. NB: +efpu2 must NOT be added -- empirically
# it flips f64 back to soft-float (__muldf3), the exact ABI mismatch behind the qoriq/
# ppc SIGILL (#7119). -Ctarget-cpu=e500 alone already implies SPE; +spe is explicit.
TC_EXTRA_RUSTFLAGS = -Ctarget-cpu=e500 -Ctarget-feature=+spe

# Declares this as a custom-rust arch (enters spksrc.toolchain/rustc.mk). The
# prebuilt rust-<id>-<rev>.txz is built by the host-native package
# native/rustc-$(TC_RUSTC) (make -C native/rustc-1.82 arch-ppc853x-5.2) and
# downloaded via the consumer DEPENDS below.
RUST_BUILD_TOOLCHAIN = 0


# Versions available: https://releases.rs/docs/
TC_RUSTC = 1.82.0

# Rust target triple to build std for (declared here so env-rust.mk's arch map is
# not consulted -- single source of truth for the from-source toolchain).
RUST_TARGET = powerpc-unknown-linux-gnuspe

# ppc853x's 2008 GNU ld 2.18 SEGFAULTS linking modern Rust cdylibs (cryptography).
# Build rustc with LLVM lld shipped in the sysroot and route package-build links
# through it (see rustc.mk RUST_LINK_VIA_LLD).
RUST_LINK_VIA_LLD = 1

# <triple>-<tool> symlink prefixes the built rustc expects (rustc.mk creates them)
RUST_POSTFIX_ALIASES = powerpc-linux-gnuspe powerpc-unknown-linux-gnuspe

# ppc853x's 2008-era binutils ld rejects the TLSLD reloc LLVM emits for std's
# thread-local guard. initial-exec makes it emit GOT_TPREL instead (older ld knows
# it) -- an attempt to build rustc here without a newer ld. Build-only (-Z needs
# the from-source bootstrap; must not reach the cross rust packages).
RUST_BUILD_EXTRA_RUSTFLAGS = -Ztls-model=initial-exec

# glibc 2.8 predates clock_gettime in libc (2.17); the target has no native 64-bit atomics.
# -latomic is dropped automatically when the gcc does not ship it.
TC_EXTRA_LDFLAGS = -lrt -latomic

include ../../mk/spksrc.toolchain.mk

# Download the published prebuilt rustc .txz. The consumer dir carries gcc<ver> so
# a future gcc-8.5 overlay variant coexists. Skipped while a native toolchain
# producer extracts this gcc toolchain to BUILD the .txz (tc-extract passes
# NATIVE_TOOLCHAIN_EXTRACT=1), so the consumer does not try to download the very
# archive being produced (bootstrap cycle).
ifneq ($(NATIVE_TOOLCHAIN_EXTRACT),1)
DEPENDS = toolchain/syno-$(TC_ARCH)-$(TC_VERS)-rust-gcc$(TC_GCC)
endif
