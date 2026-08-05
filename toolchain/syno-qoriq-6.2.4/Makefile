TC_ARCH = qoriq
TC_VERS = 6.2.4
TC_KERNEL = 2.6.32
TC_GLIBC = 2.20
TC_GCC = 4.9.3

TC_DIST = qoriq-gcc493_glibc220_hard_qoriq-GPL
TC_DIST_SITE_PATH = toolchains%2Fdsm6.2.4

TC_TARGET = powerpc-e500v2-linux-gnuspe
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_BUILD_FLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double
# +spe gives LLVM the SPE FP path for BOTH f32 (efs*) and f64 (efd*), matching the C
# toolchain's -mfloat-gprs=double SPE ABI (bat/lsd SIGILL on qoriq, #7304/#7119). NB:
# +efpu2 must NOT be added -- empirically it flips f64 back to soft-float (__muldf3),
# the exact mismatch. Only takes effect now that CARGO_TARGET_*_RUSTFLAGS is no longer
# clobbered by a global RUSTFLAGS. -Ctarget-cpu=e500 alone already implies SPE.
TC_EXTRA_RUSTFLAGS = -Ctarget-cpu=e500 -Ctarget-feature=+spe

# Declares this as a custom-rust arch (enters spksrc.toolchain/rustc.mk). The
# prebuilt rust-<id>-<rev>.txz is built by the host-native package
# native/rustc-$(TC_RUSTC) (make -C native/rustc-1.82 arch-qoriq-6.2.4) and
# downloaded via the consumer DEPENDS below.
RUST_BUILD_TOOLCHAIN = 0


# Versions available: https://releases.rs/docs/
TC_RUSTC = 1.82.0

# Rust target triple to build std for (declared here so env-rust.mk's arch map is
# not consulted -- single source of truth for the from-source toolchain).
RUST_TARGET = powerpc-unknown-linux-gnuspe

# <triple>-<tool> symlink prefixes the built rustc expects (rustc.mk creates them)
RUST_POSTFIX_ALIASES = powerpc-linux-gnuspe powerpc-unknown-linux-gnuspe

# the target has no native 64-bit atomics.
# -latomic is dropped automatically when the gcc does not ship it.
TC_EXTRA_LDFLAGS = -latomic

include ../../mk/spksrc.toolchain.mk

# Download the published prebuilt rustc .txz. The consumer dir carries gcc<ver> so
# a future gcc-8.5 overlay variant coexists. Skipped while a native toolchain
# producer extracts this gcc toolchain to BUILD the .txz (tc-extract passes
# NATIVE_TOOLCHAIN_EXTRACT=1), so the consumer does not try to download the very
# archive being produced (bootstrap cycle).
ifneq ($(NATIVE_TOOLCHAIN_EXTRACT),1)
DEPENDS = toolchain/syno-$(TC_ARCH)-$(TC_VERS)-rust-gcc$(TC_GCC)
endif
