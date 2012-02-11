
SPK_NAME = Python26
SPK_VERS = 2.6.6
SPK_REV = 6
SPK_ICON = src/python.png

DEPENDS  = cross/python26 cross/pocketsphinx
DEPENDS += cross/setuptools cross/pip cross/pyopenssl cross/pycrypto cross/pycurl
DEPENDS += cross/pil cross/cheetah cross/yenc cross/tornado 
DEPENDS += cross/busybox cross/xzdec-static

MAINTAINER = superzebulon@superzebulon.org
COMMENT    = "Python Programming Language"
ADMIN_PORT = 
RELOAD_UI = yes
DISPLAY_NAME = Python 2.6

HOMEPAGE   = http://www.python.org/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = 
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/python26
PYTHON_LIB_DIR = lib/python2.6

PLIST_TRANSFORM = sed "s%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%"

POST_STRIP_TARGET = python_cleanup

include ../../mk/spksrc.spk.mk

.PHONY: python_cleanup
python_cleanup:
	rm $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type d -regex '.*/[Tt]ests?' | xargs rm -fr
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py' | xargs chmod 444
