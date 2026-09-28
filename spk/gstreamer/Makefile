SPK_NAME = gstreamer
SPK_VERS = 1.28.7
SPK_REV = 1
SPK_ICON = src/gstreamer.png
CHANGELOG = "1. Initial package release."

DEPENDS  = cross/gstreamer
DEPENDS += cross/gst-plugins-base
DEPENDS += cross/gst-plugins-good
DEPENDS += cross/gst-plugins-bad
DEPENDS += cross/gst-plugins-ugly
DEPENDS += cross/gst-rtsp-server
VIDEODRV_PACKAGE = synocli-videodriver

MAINTAINER = th0ma7
DESCRIPTION = GStreamer is a library for constructing graphs of media-handling components. The applications it supports range from simple Ogg/Vorbis playback, audio/video streaming to complex audio \(mixing\) and video \(non-linear editing\) processing.
DESCRIPTION_FRE = GStreamer est une bibliothèque pour construire des graphiques de composants de gestion de médias. Les applications prises en charge vont de la simple lecture Ogg/Vorbis, du streaming audio/vidéo au traitement audio \(mixage\) et vidéo \(édition non linéaire\) complexe.
DISPLAY_NAME = GStreamer
STARTABLE = no

HOMEPAGE = https://gstreamer.freedesktop.org/
LICENSE  = LGPLv2.1

SPK_COMMANDS  = bin/gst-discoverer-1.0
SPK_COMMANDS += bin/gst-inspect-1.0
SPK_COMMANDS += bin/gst-launch-1.0
SPK_COMMANDS += bin/gst-play-1.0
SPK_COMMANDS += bin/gst-typefind-1.0

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, $(TCVERSION), 7.0),1)
SERVICE_USER = auto
VIDEODRIVER = on
endif

include ../../mk/spksrc.spk-meta.mk
