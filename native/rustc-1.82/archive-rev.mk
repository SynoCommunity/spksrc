# Rust archive revision, per (arch, DSM). Single source of truth lives HERE, in the
# native producer structure -- NOT in the base toolchain Makefiles. Override on the
# command line without editing anything:
#
#   make -C native/rustc-1.82 arch-ppc853x-5.2 RUST_ARCHIVE_REV=v5
#
# Bump the archive whenever a rebuild changes what is inside it without changing any
# version already encoded in the name (rust, target, arch, DSM, gcc): the rebuild then
# lands under a new name instead of silently replacing a cached artifact.
#
# Included by native/rustc-1.82/Makefile (defines TC_ARCH/TC_VERS) and by each rust
# consumer toolchain/syno-<arch>-<vers>-rust-gcc<gcc> (defines RUST_TC_ARCH/RUST_TC_VERS),
# so both the producer and the download resolve the same rev with no per-arch edits
# outside this file.
RUST_ARCHIVE_REV_ppc853x-5.2   = v7
RUST_ARCHIVE_REV_qoriq-6.2.4   = v3
RUST_ARCHIVE_REV_88f6281-5.2   = v2
RUST_ARCHIVE_REV_88f6281-6.2.4 = v2
RUST_ARCHIVE_REV_x86-5.2       = v2

# CLI override wins (?=). Try the (arch,dsm) from either naming, else v1.
RUST_ARCHIVE_REV ?= $(or $(RUST_ARCHIVE_REV_$(TC_ARCH)-$(TC_VERS)),$(RUST_ARCHIVE_REV_$(RUST_TC_ARCH)-$(RUST_TC_VERS)),v1)
