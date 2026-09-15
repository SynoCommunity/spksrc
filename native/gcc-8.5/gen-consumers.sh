#!/bin/bash
# Generate the gcc overlay consumers for every syno-<arch>-<vers> toolchain of the given
# DSM versions. Each consumer downloads the archive native/gcc-8.5 publishes for its own
# (arch, DSM) -- one component, one archive, no arch reusing another's.
#
#   ./gen-consumers.sh 6.2.4 7.0
#
# A gcc overlay is inert without a binutils overlay beside it (it ships no as/ld of its
# own -- see mk/spksrc.toolchain/overlay-gcc.mk), so run native/binutils-2.30's generator
# for the same versions first; this one says so rather than emit a consumer that can
# never activate.
#
# Idempotent: an existing consumer is left alone. Run `make digests` in each new dir once
# its archive is published.
set -e
cd "$(dirname "$0")/../../toolchain"

VERS_LIST="${*:-6.2.4 7.0}"
PKG_VERS=8.5.0
OVL_VERS=8.5                                        # directory form, matches OVERLAY_GCC_VERS
made=0 kept=0 nobinutils=0 unavailable=0

for vers in $VERS_LIST; do
  for base in syno-*-"$vers"; do
    [ -d "$base" ] || continue
    case "$base" in *_*) continue ;; esac           # skip overlay consumers themselves
    arch=${base#syno-}; arch=${arch%-"$vers"}
    # A meta architecture (x64, armv7, aarch64) declares several TC_ARCH and shares another
    # arch's toolchain. It still needs a consumer -- packages do build for it -- but it must
    # reuse that arch's archive instead of duplicating an identical build. Find the real arch
    # of the same DSM version declaring the same TC_DIST.
    dist=$(sed -n 's/^TC_DIST *= *//p' "$base/Makefile")
    dist_arch="$arch"
    if [ "$(sed -n 's/^TC_ARCH *= *//p' "$base/Makefile" | wc -w)" -gt 1 ]; then
      dist_arch=""
      for cand in syno-*-"$vers"; do
        case "$cand" in *_*) continue ;; esac
        [ "$cand" = "$base" ] && continue
        [ "$(sed -n 's/^TC_ARCH *= *//p' "$cand/Makefile" | wc -w)" -gt 1 ] && continue
        [ "$(sed -n 's/^TC_DIST *= *//p' "$cand/Makefile")" = "$dist" ] || continue
        dist_arch=${cand#syno-}; dist_arch=${dist_arch%-"$vers"}; break
      done
      [ -n "$dist_arch" ] || { echo "skip $base: meta arch, no real arch shares its toolchain" >&2; continue; }
    fi

    # The base toolchain must actually be obtainable. Several DSM 5.2 archs are declared in
    # the tree but their original Synology archive was never mirrored (404), so an overlay
    # for them could never be built. Ask, rather than maintain a list.
    if [ "$SKIP_TC_CHECK" != "1" ]; then
      # Ask make for the resolved URL: TC_DIST_SITE_URL is not always declared in the
      # toolchain Makefile (DSM 7.0 uses a framework default pointing at Synology's site),
      # so recomposing it by hand yields a scheme-less string that always fails.
      url=$(make --no-print-directory -C "$base" --eval 'z:;@echo $(firstword $(URLS))' z 2>/dev/null | tail -1)
      if ! curl -sfI -o /dev/null -L "$url" ; then
        echo "skip $base: base toolchain not available ($url)" >&2
        unavailable=$((unavailable+1)); continue
      fi
    fi

    target=$(sed -n 's/^TC_TARGET *= *//p' "$base/Makefile")
    tcgcc=$(sed -n 's/^TC_GCC *= *//p'    "$base/Makefile")
    [ -n "$target" ] && [ -n "$tcgcc" ] || { echo "skip $base (no TC_TARGET/TC_GCC)" >&2; continue; }

    # A toolchain already on 8.5 or newer has nothing to gain.
    if [ "$(printf '%s\n8.5.0\n' "$tcgcc" | sort -V | head -1)" = "8.5.0" ]; then continue; fi

    if [ -z "$(echo "${base}"_binutils-*/Makefile 2>/dev/null | grep -v '\*')" ]; then
      echo "warn: $base has no binutils overlay -- gcc overlay would stay inert" >&2
      nobinutils=$((nobinutils+1))
    fi

    ovl="${base}_gcc-${OVL_VERS}"
    if [ -e "$ovl/Makefile" ]; then kept=$((kept+1)); continue; fi
    mkdir -p "$ovl"
    cat > "$ovl/Makefile" <<EOF
TC_ARCH = $arch
TC_VERS = $vers
TC_TARGET = $target
# Archive to fetch: this arch's own, or the real arch whose toolchain a meta shares.
PKG_DIST_ARCH = $dist_arch

PKG_NAME = gcc
PKG_VERS = $PKG_VERS
PKG_EXT  = txz
PKG_REV ?= v1
EXTRACT_PATH = \$(INSTALL_DIR)

DEPENDS =

HOMEPAGE = https://gcc.gnu.org/
COMMENT  = GNU Compiler Collection
LICENSE  = GPLv3

INSTALL_TARGET = nop
POST_INSTALL_TARGET = gcc-overlay-link

PKG_DIST_NAME = \$(PKG_NAME)-\$(PKG_VERS)-\$(TC_TARGET)-\$(PKG_DIST_ARCH)-\$(TC_VERS)-\$(PKG_REV).\$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/toolchains%2Fdsm\$(TC_VERS)

include ../../mk/spksrc.native-install.mk

# Siblings, resolved by directory name: ARCH/TCVERSION are unset in a toolchain dir,
# so overlay.mk's own pointers are empty here.
TC_BASE          = syno-\$(TC_ARCH)-\$(TC_VERS)
GCC_BINUTILS_DIR = \$(firstword \$(wildcard ../\$(TC_BASE)_binutils-*))
GCC_SYSROOT_DIR  = \$(firstword \$(wildcard ../\$(TC_BASE)/work/\$(TC_TARGET)/\$(TC_TARGET)/sys-root \\
                                          ../\$(TC_BASE)/work/\$(TC_TARGET)/\$(TC_TARGET)/sysroot \\
                                          ../\$(TC_BASE)/work/\$(TC_TARGET)/\$(TC_TARGET)/libc))

# Compose the two overlays at INSTALL time rather than baking binutils into the gcc
# archive: one archive per component stays the rule, and either can be rebuilt alone.
#
#   sysroot   gcc was configured --with-sysroot=<prefix>/<target>/<suffix>, which is what
#             makes it relocatable; this link is what makes that path real.
#   as / ld   gcc's driver looks in libexec/gcc/<target>/<vers>/ before PATH, and picks up
#             the HOST assembler if nothing is there. The -B shim covers compiles that
#             carry CFLAGS; this covers the ones that do not.
#   *.la      libtool archives bake the producer's DESTDIR into libdir; unusable here.
.PHONY: gcc-overlay-link
gcc-overlay-link:
	@test -n "\$(GCC_SYSROOT_DIR)"  || { \$(MSG) "gcc overlay: no sysroot under ../\$(TC_BASE)" ; exit 1 ; }
	@test -n "\$(GCC_BINUTILS_DIR)" || { \$(MSG) "gcc overlay: no binutils overlay beside ../\$(TC_BASE)" ; exit 1 ; }
	@mkdir -p \$(INSTALL_DIR)/usr/local/\$(TC_TARGET)
	@ln -sfn \$(abspath \$(GCC_SYSROOT_DIR)) \$(INSTALL_DIR)/usr/local/\$(TC_TARGET)/\$(notdir \$(GCC_SYSROOT_DIR))
	@gccexec=\$(INSTALL_DIR)/usr/local/libexec/gcc/\$(TC_TARGET)/\$(PKG_VERS) ; \\
	 mkdir -p \$\${gccexec} ; \\
	 for tool in as ld ; do \\
	   ln -sf \$(abspath \$(GCC_BINUTILS_DIR))/work/install/usr/local/bin/\$(TC_TARGET)-\$\${tool} \$\${gccexec}/\$\${tool} ; \\
	 done
	@find \$(INSTALL_DIR) -name '*.la' -delete
	@\$(MSG) "gcc overlay: linked sysroot + as/ld from \$(notdir \$(GCC_BINUTILS_DIR))"
EOF
    made=$((made+1))
  done
done
echo "gcc consumers: $made created, $kept already present, $nobinutils without a binutils overlay, $unavailable unavailable"
