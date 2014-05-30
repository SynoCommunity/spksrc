SPK_NAME = python
SPK_SHORT_VERS = 2.7
SPK_VERS =$(SPK_SHORT_VERS).6
SPK_REV = 8
SPK_ICON = src/python.png

DEPENDS  = cross/busybox cross/$(SPK_NAME)
DEPENDS += cross/setuptools cross/distutils2 cross/pip cross/virtualenv cross/pyopenssl
DEPENDS += cross/pycrypto cross/pycurl cross/pil cross/cheetah cross/yenc
DEPENDS += cross/sqlalchemy cross/pyaudio cross/pyalsa cross/lxml cross/twisted
DEPENDS += cross/zope.interface cross/markupsafe cross/sphinxbase cross/pocketsphinx
DEPENDS += cross/wheel cross/mercurial cross/scrypt

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Python
CHANGELOG = "1. Add wheel, mercurial and scrypt modules"

HOMEPAGE   = http://www.python.org/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
PYTHON_LIB_DIR = lib/python$(SPK_SHORT_VERS)

PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%' -e 's%@PYTHON_VERSION@%$(SPK_SHORT_VERS)%'

POST_STRIP_TARGET = python_cleanup

BUSYBOX_CONFIG = usrmng nice daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: python_cleanup
python_cleanup:
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -fr $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
