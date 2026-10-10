###############################################################################
# spksrc.overlay.mk
#
# Entry point of an overlay consumer, overlay/syno-<arch>-<dsm>_<component>-<version>: a
# toolchain component built once by its producer in native/ and published as an archive,
# installed BESIDE the base toolchain toolchain/syno-<arch>-<dsm> rather than in it. When a
# build uses it is decided in spksrc.common/overlay.mk; this only installs it.
#
# The directory name carries the identity, and the Makefile states what it cannot -- the
# component's full version and the archive revision:
#
#   PKG_VERS = 8.5.0
#   PKG_REV  = v5
#   include ../../mk/spksrc.overlay.mk
#
# A rust toolchain also names the gcc it was built with: syno-qoriq-6.2.4_rust-1.98_gcc-8.5.
#
# Provides to the component file, spksrc.overlay/<component>.mk:
#   OVERLAY_TC          syno-<arch>-<dsm>, the base toolchain this one sits beside
#   TC_ARCH, TC_VERS    <arch> and <dsm>
#   OVERLAY_COMPONENT   gcc, binutils or rust
#   OVERLAY_RUST_GCC    the _gcc-<version> suffix, when there is one
#   TC_TARGET           the base toolchain's target triple
#   OVERLAY_DIST_ARCH   the arch the archive is named after (spksrc.overlay/dist-arch.mk)
###############################################################################

_OVERLAY_DIR_WORDS := $(subst _, ,$(notdir $(CURDIR)))
OVERLAY_TC         := $(word 1,$(_OVERLAY_DIR_WORDS))
TC_VERS            := $(lastword $(subst -, ,$(OVERLAY_TC)))
TC_ARCH            := $(patsubst syno-%-$(TC_VERS),%,$(OVERLAY_TC))
OVERLAY_COMPONENT  := $(firstword $(subst -, ,$(word 2,$(_OVERLAY_DIR_WORDS))))
OVERLAY_RUST_GCC   := $(patsubst gcc-%,%,$(word 3,$(_OVERLAY_DIR_WORDS)))

_OVERLAY_TC_MK := $(CURDIR)/../../toolchain/$(OVERLAY_TC)/Makefile
ifeq ($(wildcard $(_OVERLAY_TC_MK)),)
$(error $(notdir $(CURDIR)): no base toolchain toolchain/$(OVERLAY_TC))
endif
ifeq ($(wildcard $(CURDIR)/../../mk/spksrc.overlay/$(OVERLAY_COMPONENT).mk),)
$(error $(notdir $(CURDIR)): no overlay component '$(OVERLAY_COMPONENT)' (mk/spksrc.overlay/))
endif

TC_TARGET := $(shell sed -n 's/^TC_TARGET *= *//p' $(_OVERLAY_TC_MK))

include ../../mk/spksrc.overlay/dist-arch.mk
OVERLAY_DIST_ARCH := $(call overlay_dist_arch,$(TC_ARCH),$(TC_VERS))

# Installed into its own work/, never the base toolchain's: the toolchain pulling this in as
# a DEPENDS passes WORK_DIR= and ARCH= on its command line, and both would reach here. The
# name is fixed because the overlay pointers name it (spksrc.common/overlay.mk).
override WORK_DIR = $(CURDIR)/work
# Not a cross build: no stage0 bootstrap, no toolchain identity, nothing keyed on ARCH.
override ARCH =
override TCVERSION =
# A compiler, not package payload: nothing ever reads its plist.
INSTALL_PLIST_SKIP = 1

include ../../mk/spksrc.overlay/$(OVERLAY_COMPONENT).mk
include ../../mk/spksrc.native-install.mk

# What a component needs from the framework once it is loaded (the rust arch map).
$(foreach f,$(OVERLAY_LATE_INCLUDES),$(eval include $(f)))
