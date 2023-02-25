PKG_NAME = glibmm-main

HOMEPAGE = https://www.gtkmm.org/en/
COMMENT  = GLib is a low-level general-purpose library used mainly by GTK+/GNOME applications, but is useful for other programs as well. glibmm is the C++ wrapper for GLib.
LICENSE  = LGPLv2.1

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

OPTIONAL_DEPENDS  = cross/glibmm-latest
OPTIONAL_DEPENDS += cross/glibmm-2.66

include ../../mk/spksrc.install-resources.mk

ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
# Requires libsigc++ >= 3.x
DEPENDS += cross/glibmm-latest
else
# Last version require libsigc++ 2.x
DEPENDS += cross/glibmm-2.66
endif
