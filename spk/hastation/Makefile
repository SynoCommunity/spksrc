SPK_NAME = hastation
SPK_VERS = 0.1
SPK_REV = 1
SPK_ICON = src/python.png

DEPENDS  = cross/python cross/pyalsa cross/pyaudio cross/configobj
DEPENDS += cross/espeak cross/speechd cross/julius

MAINTAINER = packages@packages.nas-forum.com
COMMENT    = "Home Automation Station"
ADMIN_PORT = 
RELOAD_UI = yes
DISPLAY_NAME = H.A. Station

HOMEPAGE   = 
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = 
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
PYTHON_LIB_DIR = lib/python2.7
PLIST_TRANSFORM = sed "s%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%"

include ../../mk/spksrc.spk.mk

