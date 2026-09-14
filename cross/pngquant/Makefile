PKG_NAME = pngquant-virtual

OPTIONAL_DEPENDS  = cross/pngquant3
OPTIONAL_DEPENDS += cross/pngquant2

include ../../mk/spksrc.common.mk

# pngquant3 needs gcc >= 4.8 (its MIN_GCC_VERSION); pngquant2 declares none. Asking the
# floor rather than listing archs also covers x64-5.2, which the list had missed.
ifeq ($(call version_lt,$(TC_GCC),4.8),1)
DEPENDS = cross/pngquant2
else
DEPENDS = cross/pngquant3
endif

include ../../mk/spksrc.cross-virtual.mk
