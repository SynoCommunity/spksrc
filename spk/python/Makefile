SPK_NAME = python
SPK_VERS = 2.7.2
SPK_REV = 1
SPK_ICON = src/python.png

DEPENDS  = cross/busybox cross/$(SPK_NAME)
DEPENDS += cross/setuptools cross/pip cross/pyopenssl cross/pycrypto cross/pycurl
DEPENDS += cross/pil cross/cheetah cross/yenc cross/tornado cross/pyaudio
DEPENDS += cross/pyalsa

MAINTAINER = SynoCommunity
COMMENT    = "Python Programming Language"
RELOAD_UI = yes
DISPLAY_NAME = Python

HOMEPAGE   = http://www.python.org/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       =
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
PYTHON_LIB_DIR = lib/python2.7

PLIST_TRANSFORM = sed "s%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%"

POST_STRIP_TARGET = python_cleanup

include ../../mk/spksrc.spk.mk

.PHONY: python_cleanup
python_cleanup:
	rm $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type d -regex '.*/[Tt]ests?' | xargs rm -fr
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py' | xargs chmod 444

