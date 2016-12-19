SPK_NAME = python
SPK_SHORT_VERS = 2.7
SPK_VERS =$(SPK_SHORT_VERS).13
SPK_REV = 16
SPK_ICON = src/python.png

DEPENDS  = cross/busybox cross/$(SPK_NAME)
# Build-time dependencies
DEPENDS += cross/setuptools cross/pip cross/wheel
DEPENDS += cross/cffi cross/cryptography cross/bcrypt

# Cross-compiled wheels
DEPENDS += cross/lxml cross/m2crypto cross/msgpack-python cross/pillow
DEPENDS += cross/pocketsphinx cross/pyalsa cross/pyaudio cross/pycrypto cross/pycurl
DEPENDS += cross/pyyaml cross/pyzmq cross/sphinxbase
DEPENDS += cross/uwsgi cross/yenc

WHEELS = src/requirements.txt

MAINTAINER = Diaoul
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Python
CHANGELOG = "1. Update to Python 2.7.13<br>2. Update modules"

HOMEPAGE = http://www.python.org
LICENSE  = PSF

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
PYTHON_LIB_DIR = lib/python$(SPK_SHORT_VERS)

PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%' -e 's%@PYTHON_VERSION@%$(SPK_SHORT_VERS)%'

POST_STRIP_TARGET = python_extra_install

BUSYBOX_CONFIG = usrmng nice daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: python_extra_install
python_extra_install:
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -fr $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
