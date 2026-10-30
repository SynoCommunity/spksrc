PKG_NAME = ripgrep-virtual

# mirrors ripgrep-14, the fallback: refuse before routing to a leaf that would
MIN_GCC_VERSION = 4.6

include ../../mk/spksrc.common.mk

$(call depend,cross/ripgrep-latest|cross/ripgrep-14)

include ../../mk/spksrc.cross-virtual.mk
