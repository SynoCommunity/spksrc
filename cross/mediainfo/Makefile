PKG_NAME = mediainfo-virtual

# mirrors mediainfo-25.04, the fallback, which needs -std=c++11
MIN_GCC_VERSION = 4.7

include ../../mk/spksrc.common.mk

$(call depend,cross/mediainfo-latest|cross/mediainfo-25.04)

include ../../mk/spksrc.cross-virtual.mk
