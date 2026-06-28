###############################################################################
# spksrc.cross-install.mk
#
# Install-only cross build: skip configure and compile, going straight from
# patch to install with a package-provided INSTALL_TARGET (e.g. to stage
# prebuilt binaries or arch-independent resources). Mirrors
# spksrc.native-install.mk for native packages.
#
# Packages using this must:
#  - define a custom INSTALL_TARGET that copies the required files under
#    $(STAGING_INSTALL_PREFIX)
#  - provide a PLIST covering the staged file(s)/folder(s)
###############################################################################

# Skip configure and compile. These must be set before including
# spksrc.cross-cc.mk, where configure.mk / compile.mk read them at parse time.
CONFIGURE_TARGET = nop
COMPILE_TARGET   = nop

ifneq ($(REQUIRE_KERNEL),)
$(error cross-install cannot be used when REQUIRE_KERNEL is set)
endif

include ../../mk/spksrc.cross-cc.mk
