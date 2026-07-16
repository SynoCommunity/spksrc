#!/bin/bash
# Generate the per-arch gcc8 overlay consumers for every syno-<arch>-<vers>
# toolchain of the given DSM versions. Each consumer downloads the prebuilt
# gcc-8.5 archive built by native/gcc8 (make build-archive) and extracts it into
# the base toolchain, next to the stock gcc. Idempotent; run then `make digests`
# in each new dir once the archives are hosted.
#   ./gen-overlays.sh 6.2.4 7.0
#
# The archive name is taken from native/gcc8 itself (print-archive-name), so the
# consumer never drifts from the producer. Virtual/generic archs (armv7, aarch64,
# x86: those whose name is not their TC_DIST prefix and whose canonical sibling
# has its own toolchain) do not get their own build -- their consumer downloads
# the canonical arch's archive but still extracts it into their own toolchain
# (same triple/sysroot).
set -e
cd "$(dirname "$0")/../../toolchain"
GCC8="../native/gcc8"
VERSIONS="${@:-6.2.4 7.0}"
n=0
for vers in $VERSIONS; do
  # one GitHub release per DSM version
  case "$vers" in
    6.2.4) release="toolchains%2Fdsm6.2.4" ;;
    7.0)   release="toolchains%2Fdsm7.0" ;;
    *)     release="toolchains%2Fdsm$vers" ;;
  esac
  for base in syno-*-$vers; do
    [ -d "$base" ] || continue
    case "$base" in *-gcc8) continue ;; esac
    arch=$(echo "$base" | sed "s/^syno-//; s/-$vers$//")
    # canonical arch for this toolchain = the TC_DIST prefix; a virtual arch
    # (arch != canon, canon has its own toolchain) reuses the canonical archive.
    dist=$(sed -n 's/^TC_DIST *= *//p' "$base/Makefile")
    canon="${dist%%-*}"
    if [ "$arch" != "$canon" ] && [ -d "syno-$canon-$vers" ]; then
      target_arch="$canon"
    else
      target_arch="$arch"
    fi
    distname=$(make -s -C "$GCC8" TC_ARCH="$target_arch" TC_VERS="$vers" print-archive-name)
    ovl="$base-gcc8"; mkdir -p "$ovl"
    cat > "$ovl/Makefile" <<EOF
# GCC 8.5 overlay for $base (consumer, llvm/rust-overlay style). Downloads the
# prebuilt gcc-8.5 archive produced by native/gcc8 and extracts it into the base
# toolchain's work tree, next to the stock gcc; the tc_vars generator then picks
# the newest gcc (TC_GCC_SUFFIX in spksrc.toolchain/tc_vars.mk).
TC_ARCH = $arch
TC_VERS = $vers
TC_BASE = syno-\$(TC_ARCH)-\$(TC_VERS)
TC_TARGET := \$(shell grep -E '^TC_TARGET' ../\$(TC_BASE)/Makefile 2>/dev/null | sed 's/.*= *//')

PKG_NAME = gcc8-\$(TC_ARCH)
PKG_VERS = 8.5.0
PKG_EXT  = txz
# Name/site come from native/gcc8 (print-archive-name); a virtual arch reuses the
# canonical arch's archive ($target_arch), extracted into its own toolchain.
PKG_DIST_NAME = $distname
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/$release

EXTRACT_PATH = \$(abspath ../\$(TC_BASE)/work/\$(TC_TARGET))

DEPENDS =
HOMEPAGE = https://gcc.gnu.org/
COMMENT  = GCC 8.5 overlay for the $base toolchain (built by native/gcc8).
LICENSE  = GPLv3
INSTALL_TARGET = nop
POST_INSTALL_TARGET = gcc8_overlay_post_install
include ../../mk/spksrc.native-install.mk

# gcc-8.5's own libstdc++ lands in the overlay's lib dir, but the driver keeps
# resolving the base toolchain's STOCK libstdc++ out of the sysroot, which has
# none of the C++17 symbols. Both flavours have to be repointed:
#   libstdc++.so.6  dynamic link -- the common case
#   libstdc++.a     -static-libstdc++; without it, gcc-8.5's libstdc++fs.a (the
#                   std::filesystem implementation) links against the stock 4.9.3
#                   libstdc++ and dies on undefined __codecvt_utf8_base /
#                   operator delete(void*, size_t)
# Point whatever the driver resolves at gcc-8.5's copy, keeping the stock as
# .legacy. Idempotent (guarded by cmp) and a no-op wherever gcc-8.5 already
# resolves its own.
.PHONY: gcc8_overlay_post_install
gcc8_overlay_post_install:
	@gxx=\$(EXTRACT_PATH)/bin/\$(TC_TARGET)-g++-8.5 ; \\
	for lib in libstdc++.so.6 libstdc++.a ; do \\
	  case "\$\$lib" in \\
	    *.so.6) new=\$\$(ls \$(EXTRACT_PATH)/lib*/libstdc++.so.6.0.* 2>/dev/null | grep -v -- -gdb.py | sort -V | tail -1) ;; \\
	    *.a)    new=\$\$(ls \$(EXTRACT_PATH)/lib*/libstdc++.a 2>/dev/null | head -1) ;; \\
	  esac ; \\
	  cur=\$\$(\$\$gxx -print-file-name=\$\$lib 2>/dev/null) ; curreal=\$\$(readlink -f "\$\$cur" 2>/dev/null) ; \\
	  if [ -z "\$\$new" ] || [ -z "\$\$curreal" ] || [ ! -f "\$\$curreal" ] || cmp -s "\$\$curreal" "\$\$new" ; then \\
	    \$(MSG) "gcc8 overlay: \$\$lib already resolves to gcc-8.5's (no-op)" ; \\
	    continue ; \\
	  fi ; \\
	  [ -f "\$\$curreal.legacy" ] || cp -a "\$\$curreal" "\$\$curreal.legacy" ; \\
	  case "\$\$lib" in \\
	    *.so.6) d=\$\$(dirname "\$\$curreal") ; b=\$\$(basename "\$\$new") ; \\
	            cp -f "\$\$new" "\$\$d/\$\$b" ; ln -sf "\$\$b" "\$\$d/libstdc++.so.6" ; ln -sf "\$\$b" "\$\$d/libstdc++.so" ;; \\
	    *.a)    cp -f "\$\$new" "\$\$curreal" ;; \\
	  esac ; \\
	  \$(MSG) "gcc8 overlay: pointed \$\$lib at gcc-8.5's (stock kept as .legacy)" ; \\
	done
EOF
    n=$((n+1))
  done
done
echo "generated $n overlay consumers"
