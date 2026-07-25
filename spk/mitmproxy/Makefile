SPK_NAME = mitmproxy
SPK_VERS = 0.18.2
SPK_REV = 1
SPK_ICON = src/mitmproxy.png

WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.11-15"

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/ruamel cross/cffi cross/lxml cross/pillow
DEPENDS =

MAINTAINER = cytec
DESCRIPTION = mitmproxy is an interactive, SSL-capable intercepting proxy with a console interface.
DISPLAY_NAME = mitmproxy
CHANGELOG = initial release of mitmproxy

STARTABLE = no
BETA = 1

HOMEPAGE   = https://mitmproxy.org/
LICENSE    = MIT

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
