SPK_NAME = python
SPK_VERS = 2.7.2
SPK_REV = 1
SPK_ICON = src/python.png

DEPENDS  = cross/busybox cross/$(SPK_NAME)
DEPENDS += cross/setuptools cross/pip cross/virtualenv cross/pyopenssl
DEPENDS += cross/pycrypto cross/pycurl cross/pil cross/cheetah cross/yenc
DEPENDS += cross/sqlalchemy cross/pyaudio cross/pyalsa

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language. This package is not startable, it is just required by other packages as dependency.
DESCRIPTION_FRE = Langage de programmation Python. Ce paquet ne se lance pas, il est juste requis en tant que dépendance par d\\\'autres paquets.
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

