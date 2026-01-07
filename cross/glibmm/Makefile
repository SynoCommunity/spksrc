PKG_NAME = glibmm-main

OPTIONAL_DEPENDS  = cross/glibmm-latest
OPTIONAL_DEPENDS += cross/glibmm-2.66

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
# Requires libsigc++ >= 3.x
DEPENDS += cross/glibmm-latest
else
# Last version require libsigc++ 2.x
DEPENDS += cross/glibmm-2.66
endif
