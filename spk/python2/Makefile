# keep python as SPK_NAME, as SPK_NAME=python2 would create a different package
SPK_NAME = python
SPK_SHORT_VERS = 2.7
SPK_VERS = $(SPK_SHORT_VERS).18
SPK_REV = 26
SPK_ICON = src/python.png

DEPENDS = cross/busybox cross/python2

# Cross-compiled libraries and tools
DEPENDS += cross/setuptools cross/wheel cross/pip_py2
DEPENDS += cross/cryptography cross/cffi cross/bcrypt

# Cross-compiled wheels
DEPENDS += cross/lxml cross/m2crypto cross/msgpack-python cross/pillow_py2
DEPENDS += cross/pyalsa cross/pyaudio cross/pycrypto cross/pycurl
DEPENDS += cross/pyyaml cross/pyzmq cross/uwsgi

WHEELS = src/requirements.txt


MAINTAINER = Safihre
DESCRIPTION = Python 2.7 Programming Language.
DESCRIPTION_FRE = Langage de programmation Python 2.7.
DESCRIPTION_SPN = Lenguaje de programación Python 2.7.
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Python2
CHANGELOG = "Update depencencies (PyYAML, cryptography and others) including security fixes for CVE-2020-14343."

HOMEPAGE = https://www.python.org
LICENSE  = PSF

SERVICE_SETUP = src/service-setup.sh

PYTHON_LIB_DIR = lib/python$(SPK_SHORT_VERS)
PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%' -e 's%@PYTHON_VERSION@%$(SPK_SHORT_VERS)%'

POST_STRIP_TARGET = python_extra_install

# Busybox needed so pure-Python spk's can use it
BUSYBOX_CONFIG = usrmng nice daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

# Wheel "cryptography" lacks libpthread when cross-compile for ARM
ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
WHEELS_CFLAGS = "-pthread"
WHEELS_LDFLAGS = "-lpthread"
endif

.PHONY: python_extra_install
python_extra_install:
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -fr $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
