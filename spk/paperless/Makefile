SPK_NAME = paperless
SPK_VERS = 2.7.0
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
#BUILD_DEPENDS += cross/$(SPK_NAME)
#DEPENDS = cross/bash cross/acl cross/attr
WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.5.6"

MAINTAINER = SynoCommunity
DESCRIPTION = to be completed
RELOAD_UI = no
DISPLAY_NAME = Paperless
STARTABLE = no
CHANGELOG = Initial release

HOMEPAGE = https://paperless.readthedocs.io
LICENSE  = GPL-3.0

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
