#!/bin/bash
# Generate the binutils overlay consumers for every syno-<arch>-<vers> toolchain of the
# given DSM versions. Each consumer downloads the archive native/binutils-2.30 publishes
# for its own (arch, DSM) -- one component, one archive, no arch reusing another's.
#
#   ./gen-consumers.sh 6.2.4 7.0
#
# Idempotent: an existing consumer is left alone, so a hand-tuned one is never clobbered.
# Run `make digests` in each new dir once its archive is published.
set -e
cd "$(dirname "$0")/../../toolchain"

VERS_LIST="${*:-6.2.4 7.0}"
PKG_VERS=2.30
made=0 kept=0 unavailable=0

for vers in $VERS_LIST; do
  for base in syno-*-"$vers"; do
    [ -d "$base" ] || continue
    case "$base" in *_*) continue ;; esac          # skip overlay consumers themselves
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
    [ -n "$target" ] || { echo "skip $base (no TC_TARGET)" >&2; continue; }

    ovl="${base}_binutils-${PKG_VERS}"
    if [ -e "$ovl/Makefile" ]; then kept=$((kept+1)); continue; fi
    mkdir -p "$ovl"
    cat > "$ovl/Makefile" <<EOF
TC_ARCH = $arch
TC_VERS = $vers
TC_TARGET = $target
# Archive to fetch: this arch's own, or the real arch whose toolchain a meta shares.
PKG_DIST_ARCH = $dist_arch

PKG_NAME = binutils
PKG_VERS = $PKG_VERS
PKG_EXT  = txz
PKG_REV ?= v1
EXTRACT_PATH = \$(INSTALL_DIR)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU Binutils
LICENSE  = GPLv3

INSTALL_TARGET = nop
POST_INSTALL_TARGET = binutils-shim

PKG_DIST_NAME = \$(PKG_NAME)-\$(PKG_VERS)-\$(TC_TARGET)-\$(PKG_DIST_ARCH)-\$(TC_VERS)-\$(PKG_REV).\$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/pre-releases

include ../../mk/spksrc.native-install.mk

# Build the unprefixed as/ld shim gcc reaches via -B (symmetric with the rust consumer's
# rustup-link POST_INSTALL). overlay-binutils.mk points OVERLAY_BINUTILS_SHIM at \$(WORK_DIR)/shim.
.PHONY: binutils-shim
binutils-shim:
	@mkdir -p \$(WORK_DIR)/shim
	@ln -sf \$(INSTALL_DIR)/usr/local/bin/\$(TC_TARGET)-ld \$(WORK_DIR)/shim/ld
	@ln -sf \$(INSTALL_DIR)/usr/local/bin/\$(TC_TARGET)-as \$(WORK_DIR)/shim/as
EOF
    made=$((made+1))
  done
done
echo "binutils consumers: $made created, $kept already present, $unavailable unavailable"
