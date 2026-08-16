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

# An overlay consumer under toolchain/ is pulled in as a DEPENDS of its BASE toolchain, which
# spksrc.cross-cc.mk invokes with WORK_DIR= on the command line. That propagates through
# MAKEFLAGS to every sub-make, so the consumer would unpack into the base toolchain's work dir
# -- mixing the vendor tools with the overlay, and making two versions of one component unable
# to coexist. override wins over the command line, so each consumer keeps its own work dir.
# Scoped to toolchain/: the native/* packages that also read this file are already isolated
# (spksrc.rules/depend.mk invokes them through `env -i`).
ifneq ($(findstring /toolchain/,$(CURDIR)),)
# A FIXED name, not work$(ARCH_SUFFIX): ARCH/TCVERSION propagate through MAKEFLAGS too, so the
# suffix would vary with the caller and the overlay pointers below could not name the directory.
override WORK_DIR = $(CURDIR)/work-native
endif

ifneq ($(REQUIRE_KERNEL),)
$(error native-install cannot be used when REQUIRE_KERNEL is set)
endif

include ../../mk/spksrc.native-cc.mk
