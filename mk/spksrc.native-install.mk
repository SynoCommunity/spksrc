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

ifneq ($(REQUIRE_KERNEL),)
$(error native-install cannot be used when REQUIRE_KERNEL is set)
endif

include ../../mk/spksrc.native-cc.mk
