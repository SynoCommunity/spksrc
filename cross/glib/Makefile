PKG_NAME = glib

HOMEPAGE = https://developer.gnome.org/glib/
COMMENT  = General-purpose utility library.
LICENSE  = LGPLv2.1+

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

OPTIONAL_DEPENDS  = cross/glib-latest
OPTIONAL_DEPENDS += cross/glib-2.66
OPTIONAL_DEPENDS += cross/glib-2.58

include ../../mk/spksrc.install-resources.mk

ifeq ($(call version_ge, $(TC_KERNEL), 3.10),1)
DEPENDS = cross/glib-latest
else
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS = cross/glib-2.66
else
DEPENDS = cross/glib-2.58
endif
endif
