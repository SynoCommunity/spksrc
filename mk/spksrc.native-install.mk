###############################################################################
# spksrc.native-install.mk
#
# Install-only native build: skip configure and compile, going straight from
# patch to install with a package-provided INSTALL_TARGET (e.g. to stage a
# prebuilt native tool). Mirrors spksrc.cross-install.mk for cross packages.
#
# Packages using this must define a custom INSTALL_TARGET that copies the
# required files under $(STAGING_INSTALL_PREFIX).
###############################################################################

# Skip configure and compile. These must be set before including
# spksrc.native-cc.mk, where configure.mk / compile.mk read them at parse time.
CONFIGURE_TARGET = nop
COMPILE_TARGET   = nop

# native-cc.mk does not include plist.mk, so default the PLIST transform here.
ifeq ($(strip $(PLIST_TRANSFORM)),)
PLIST_TRANSFORM = cat
endif

# An overlay consumer is a DEPENDS of its base toolchain, which cross-cc.mk invokes with
# WORK_DIR= on the command line; that propagates through MAKEFLAGS and would unpack the
# consumer into the base toolchain's work dir. override wins over the command line. The name
# is fixed, not work$(ARCH_SUFFIX): ARCH propagates too, and the overlay pointers must be able
# to name the directory. Scoped to toolchain/ -- native/* is already isolated by depend.mk's
# `env -i`.
ifneq ($(findstring /toolchain/,$(CURDIR)),)
override WORK_DIR = $(CURDIR)/work
endif

ifneq ($(REQUIRE_KERNEL),)
$(error native-install cannot be used when REQUIRE_KERNEL is set)
endif

include ../../mk/spksrc.native-cc.mk
