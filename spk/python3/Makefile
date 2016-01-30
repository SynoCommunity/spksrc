SPK_NAME = python3
SPK_SHORT_VERS = 3.4
SPK_VERS = $(SPK_SHORT_VERS).1
SPK_REV = 4
SPK_ICON = src/python3.png

DEPENDS  = cross/busybox cross/$(SPK_NAME)
DEPENDS += cross/setuptools cross/pip cross/wheel cross/virtualenv cross/six
DEPENDS += cross/cffi cross/cryptography cross/bcrypt
DEPENDS += cross/pyopenssl cross/pycrypto
DEPENDS += cross/lxml cross/markupsafe cross/psutil cross/pycurl cross/pyyaml
DEPENDS += cross/sqlalchemy cross/zope.interface

PIP = pip3
WHEELS = psutil

MAINTAINER = Diaoul
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Python3

CHANGELOG = Added cffi, cryptography, psutil modules

HOMEPAGE   = http://www.python.org
LICENSE    = PSF

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
PYTHON_LIB_DIR = lib/python$(SPK_SHORT_VERS)

PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%' -e 's%@PYTHON_VERSION@%$(SPK_SHORT_VERS)%'

POST_STRIP_TARGET = python3_extra_install

BUSYBOX_CONFIG = usrmng nice daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: python3_extra_install
python3_extra_install: python3_cleanup
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/wheelhouse
	install -m 644 $(WORK_DIR)/wheelhouse/* $(STAGING_DIR)/share/wheelhouse/

.PHONY: python3_cleanup
python3_cleanup:
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -fr $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
