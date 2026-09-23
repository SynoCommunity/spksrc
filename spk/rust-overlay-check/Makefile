SPK_NAME = rust-overlay-check
SPK_VERS = 1.0
SPK_REV = 1

# The whole point of this package: compile real crates through the rustc overlay. 1.98
# exists only in the gcc-8.5 variant, so without this the check silently falls back to 1.82.
# Safe to force here and nowhere else -- this package has no consumers, so the switch
# reaches nothing but its own dependency tree.
OVERLAY_GCC ?= 1

# One crate that mixes C and Rust and one that is pure Rust, neither of which excludes an
# arch: pngquant3 links libimagequant and zlib, ripgrep-14 leans on std and pcre2.
DEPENDS = cross/pngquant3 cross/ripgrep-14

MAINTAINER = SynoCommunity
DESCRIPTION = Build-time check that the rustc overlay compiles, links and runs through the normal package path. Not meant for publication.
DISPLAY_NAME = Rust Overlay Check
STARTABLE = no

HOMEPAGE = https://github.com/SynoCommunity/spksrc
LICENSE  = Each tool is licensed under its respective license.

include ../../mk/spksrc.common.mk

# Only where the arch carries a rust overlay. Everywhere else this would rebuild two crates
# against stock rustup, which every other CI job already exercises for free.
ifeq ($(strip $(TC_OVERLAY_RUSTC)),)
UNSUPPORTED_ARCHS = $(ALL_ARCHS)
endif

SPK_COMMANDS = bin/pngquant bin/rg

include ../../mk/spksrc.spk.mk
