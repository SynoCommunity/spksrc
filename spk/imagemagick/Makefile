SPK_NAME = imagemagick
SPK_VERS = 6.9.5
SPK_REV = 2
SPK_ICON = src/imagemagick.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = ImageMagick is a software suite to create, edit, compose, or convert bitmap images.
DISPLAY_NAME = ImageMagick
CHANGELOG = Updated to ImageMagick 6.9.5-10

BETA = 1
STARTABLE = no

HOMEPAGE = http://www.imagemagick.org/
LICENSE  = Apache 2.0

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = imagemagick_extra_install


include ../../mk/spksrc.spk.mk
