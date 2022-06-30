# Build dotnet programs
#
# prerequisites:
# - cross/module depends on native/dotnet only
# - module does not require kernel (REQUIRE_KERNEL)
#
# remarks:
# - Restriction for minimal DSM version is not supported (toolchains are not used for dotnet builds)
# - CONFIGURE_TARGET is not supported/bypassed
# - most content is taken from spksrc.go.mk and modified for dotnet build and install
#
# NOTE: Don't strip the self-contained binary!
#    aka don't use 'bin' for the PLIST use 'rsc' instead.
#    It *will* break the program.

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Configure the included makefiles
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
ifneq ($(PKG_DIST_FILE),)
LOCAL_FILE    = $(PKG_DIST_FILE)
else
LOCAL_FILE    = $(PKG_DIST_NAME)
endif
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
TC = syno$(ARCH_SUFFIX)
endif

##### dotnet specific configurations
include ../../mk/spksrc.cross-dotnet-env.mk

# avoid run of make configure & make install
CONFIGURE_TARGET = nop

ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = dotnet_compile_target
endif

ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = nop
endif

# default dotnet publish:
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish
dotnet_compile_target:
	@$(MSG) - Compile with dotnet publish
	$(RUN) dotnet publish $(DOTNET_PACKAGE_NAME) $(DOTNET_BUILD_ARGS)

#####

ifneq ($(REQUIRE_KERNEL),)
  @$(error dotnet modules cannot build when REQUIRE_KERNEL is set)
endif

include ../../mk/spksrc.pre-check.mk

include ../../mk/spksrc.cross-env.mk

include ../../mk/spksrc.download.mk

include ../../mk/spksrc.depend.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum depend
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

configure: patch
include ../../mk/spksrc.configure.mk

compile: configure
include ../../mk/spksrc.compile.mk

install: compile
include ../../mk/spksrc.install.mk

plist: install
include ../../mk/spksrc.plist.mk


clean:
	rm -fr work work-*


all: install plist

### For make digests
include ../../mk/spksrc.generate-digests.mk

### For make dependency-tree
include ../../mk/spksrc.dependency-tree.mk

.PHONY: all-archs
all-archs: $(addprefix arch-,$(AVAILABLE_ARCHS))

####

arch-%:
	@$(MSG) Building package for arch $*
	@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*))) 2>&1 | tee --append build-$*.log

####
