PKG_NAME = ripgrep-virtual

OPTIONAL_DEPENDS  = cross/ripgrep-latest
OPTIONAL_DEPENDS += cross/ripgrep-14

# mirrors ripgrep-14, the fallback: refuse before routing to a leaf that would
MIN_GCC_VERSION = 4.6

include ../../mk/spksrc.common.mk

ifneq ($(call version_ge,$(TC_RUSTC),1.85),1)
# ripgrep >= 15 requires edition2024
DEPENDS += cross/ripgrep-14
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
DEPENDS += cross/ripgrep-14
else
DEPENDS += cross/ripgrep-latest
endif
else
DEPENDS += cross/ripgrep-latest
endif

include ../../mk/spksrc.cross-virtual.mk
