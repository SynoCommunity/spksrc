PKG_NAME = glibc-main

OPTIONAL_DEPENDS  = cross/glibc-latest
OPTIONAL_DEPENDS += cross/glibc-2.28

include ../../mk/spksrc.main-depends.mk

###
### In theory the version should be an exact match such as:
###      DEPENDS = cross/glibc-$(TC_GLIBC)
###

ifeq ($(call version_ge, $(TC_KERNEL), 4)$(call version_ge, $(TC_GCC), 5),11)
DEPENDS = cross/glibc-latest
else ifeq ($(call version_ge, $(TC_KERNEL), 3.10),1)
DEPENDS = cross/glibc-2.28
endif
