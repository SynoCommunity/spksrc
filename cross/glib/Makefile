PKG_NAME = glib-main

OPTIONAL_DEPENDS  = cross/glib-latest
OPTIONAL_DEPENDS += cross/glib-2.66
OPTIONAL_DEPENDS += cross/glib-2.58

include ../../mk/spksrc.main-depends.mk

# If kernel >= 3.10 && gcc >= 7.5
ifeq ($(call version_ge, $(TC_KERNEL), 3.10)$(call version_ge, $(TC_GCC), 7.5),11)
DEPENDS = cross/glib-latest
else
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS = cross/glib-2.66
else
# old compilers do not support glib with meson build
DEPENDS = cross/glib-2.58
endif
endif
