SPK_NAME = gstreamer
SPK_VERS = 1.20.3
SPK_REV = 1
SPK_ICON = src/gstreamer.png

DEPENDS  = cross/$(SPK_NAME)
DEPENDS += cross/gst-plugins-base
DEPENDS += cross/gst-plugins-good
DEPENDS += cross/gst-plugins-bad
DEPENDS += cross/gst-plugins-ugly
DEPENDS += cross/gst-rtsp-server

CHANGELOG = "1. Initial package release"

MAINTAINER = th0ma7
DESCRIPTION = GStreamer is a library for constructing graphs of media-handling components. The applications it supports range from simple Ogg/Vorbis playback, audio/video streaming to complex audio \(mixing\) and video \(non-linear editing\) processing.
DESCRIPTION_FRE = GStreamer est une bibliothèque pour construire des graphiques de composants de gestion de médias. Les applications prises en charge vont de la simple lecture Ogg/Vorbis, du streaming audio/vidéo au traitement audio \(mixage\) et vidéo \(édition non linéaire\) complexe.
DISPLAY_NAME = GStreamer
STARTABLE = no

HOMEPAGE = https://gstreamer.freedesktop.org/
LICENSE  = LGPLv2.1

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

CONF_DIR = src/conf

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
DEPENDS += cross/gstreamer-vaapi
SERVICE_SETUP = src/service-setup.sh
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
DEPENDS += cross/gst-omx
endif

CONF_DIR = src/conf

include ../../mk/spksrc.spk.mk
