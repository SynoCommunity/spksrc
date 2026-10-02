PKG_NAME = libheif-virtual

OPTIONAL_DEPENDS  = cross/libheif-latest
OPTIONAL_DEPENDS += cross/libheif-1.20
OPTIONAL_DEPENDS += cross/libheif-1.18

# Compiler floors live on the tiers (GCC >= 10 latest, >= 8.5 1.20,
# >= 4.8 1.18, >= 4.7 libde265); archs below all floors skip here.
include ../../mk/spksrc.common.mk

# support for C++20 incl. defaulted comparisons (GCC 10+);
# GCC 8.5 era toolchains stay on the frozen 1.20 line, older ones on 1.18
ifeq ($(call version_ge, $(TC_GCC), 10),1)
DEPENDS = cross/libheif-latest
else ifeq ($(call version_ge, $(TC_GCC), 8.5),1)
DEPENDS = cross/libheif-1.20
else
DEPENDS = cross/libheif-1.18
endif

include ../../mk/spksrc.cross-virtual.mk
