SPK_NAME = mercurial
SPK_VERS = 5.7.1
SPK_REV = 7
SPK_ICON = src/mercurial.png

BUILD_DEPENDS = cross/python38 cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/$(SPK_NAME)

WHEELS = src/requirements.txt
SPK_DEPENDS = "python38"

MAINTAINER = Dr-Bean
DESCRIPTION = Mercurial is a free, distributed source control management tool
STARTABLE = no
DISPLAY_NAME = Mercurial
CHANGELOG = Update mercurial to 5.7.1 with python 3.8

HOMEPAGE = https://www.mercurial-scm.org/
LICENSE  = MPL1.1

SERVICE_SETUP = src/service-setup.sh

SPK_USR_LOCAL_LINKS = bin:env/bin/hg

include ../../mk/spksrc.spk.mk
