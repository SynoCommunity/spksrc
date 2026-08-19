PKG_NAME = fuse3-virtual

OPTIONAL_DEPENDS  = cross/fuse3-latest
OPTIONAL_DEPENDS += cross/fuse3.16

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, $(TC_GCC), 4.9),1)
DEPENDS = cross/fuse3.16
else
DEPENDS = cross/fuse3-latest
endif

include ../../mk/spksrc.cross-virtual.mk
