SPK_NAME = ffmpeg
SPK_VERS = 4.2.2
SPK_REV = 28
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update ffmpeg to 4.2.2<br/>2. Review and isolate Synology FFMPEG 3.3.7 patches with fixes<br/>3. Enable opencore-amr codec<br/>4. Update libva-utils to v2.6<br/>5. Fix issues 3668, 3716, 3861 and 3862<br/>6. evansport arch specific platform compile time cpu arch setting<br/>7. -O3 compile-time optimization<br/>8. Activation of neon acceleration in libswscale<br/>9. Update libvpx to v1.8.2 and enable high bit depth<br/>10. Enablement of opencore-amr codec"

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = th0ma7
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.
DESCRIPTION_FRE = FFmpeg est une solution complète multiplateforme pour enregistrer, convertir et diffuser du contenu audio et vidéo. Il comprend libavcodec - la principale bibliothèque de codecs audio/vidéo.
DISPLAY_NAME = ffmpeg
STARTABLE = no

HOMEPAGE = http://www.ffmpeg.org/
LICENSE  = GPLv3

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
