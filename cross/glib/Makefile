PKG_NAME = glib-main

OPTIONAL_DEPENDS  = cross/glib-latest
OPTIONAL_DEPENDS += cross/glib-2.62
OPTIONAL_DEPENDS += cross/glib-2.54

include ../../mk/spksrc.main-depends.mk

# If (TC_GLIBC >= 2.28 && TC_GCC >= 5) = DSM-7.2
ifeq ($(call version_ge, $(TC_GLIBC), 2.28)$(call version_ge, $(TC_GCC), 5),11)
DEPENDS = cross/glib-latest
# (TC_GLIBC >= 2.25 && TC_GCC >= 4.8) = DSM-7.1
else ifeq ($(call version_ge, $(TC_GLIBC), 2.25)$(call version_ge, $(TC_GCC), 4.8),11)
DEPENDS = cross/glib-2.62
else
DEPENDS = cross/glib-2.54
endif
