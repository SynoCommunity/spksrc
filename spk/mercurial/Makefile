SPK_NAME = mercurial
SPK_VERS = 4.8.1
SPK_REV = 5
SPK_ICON = src/mercurial.png

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel cross/$(SPK_NAME)
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.6-8"

MAINTAINER = Dr-Bean
DESCRIPTION = Mercurial is a free, distributed source control management tool
STARTABLE = no
DISPLAY_NAME = Mercurial
CHANGELOG = Update to 4.8.1

HOMEPAGE = http://mercurial.selenic.com/
LICENSE  = MPL1.1

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
