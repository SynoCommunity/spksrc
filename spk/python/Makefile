SPK_NAME = python
SPK_SHORT_VERS = 2.7
SPK_VERS =$(SPK_SHORT_VERS).11
SPK_REV = 15
SPK_ICON = src/python.png

DEPENDS  = cross/busybox cross/$(SPK_NAME)
DEPENDS += cross/setuptools cross/pip cross/wheel cross/virtualenv cross/six
DEPENDS += cross/cffi cross/cryptography cross/bcrypt
DEPENDS += cross/pyopenssl cross/pycrypto cross/m2crypto
DEPENDS += cross/pycurl cross/pillow cross/cheetah cross/yenc cross/pyzmq
DEPENDS += cross/sqlalchemy cross/pyaudio cross/pyalsa cross/lxml cross/twisted
DEPENDS += cross/zope.interface cross/markupsafe cross/sphinxbase cross/pocketsphinx
DEPENDS += cross/msgpack-python cross/psutil cross/pymongo cross/pyyaml cross/uwsgi

WHEELS = msgpack-python psutil uwsgi

MAINTAINER = Diaoul
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Python
CHANGELOG = "1. Update to Python 2.7.11<br>2. Add psutil module<br>3. Update modules"

HOMEPAGE   = http://www.python.org
LICENSE    = PSF

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
python_extra_install: python_cleanup
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/wheelhouse
	install -m 644 $(WORK_DIR)/wheelhouse/* $(STAGING_DIR)/share/wheelhouse/

.PHONY: python_cleanup
python_cleanup:
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -fr $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
