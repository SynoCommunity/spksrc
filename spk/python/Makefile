SPK_NAME = python
SPK_VERS = 2.7.3
SPK_REV = 4
SPK_ICON = src/python.png

DEPENDS  = cross/busybox cross/$(SPK_NAME)
DEPENDS += cross/distribute cross/distutils2 cross/pip cross/virtualenv cross/pyopenssl
DEPENDS += cross/pycrypto cross/pycurl cross/pil cross/cheetah cross/yenc
DEPENDS += cross/sqlalchemy cross/pyaudio cross/pyalsa cross/lxml cross/twisted
DEPENDS += cross/zope.interface cross/markupsafe

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language. This package is not startable, it is just required by other packages as dependency.
DESCRIPTION_FRE = Langage de programmation Python. Ce paquet ne se lance pas, il est juste requis en tant que dépendance par d\\\'autres paquets.
DESCRIPTION_SPN = Lenguaje de programación Python. Este paquente no se inicia, solo es requerido como dependecia de otros paquetes.
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Python
CHANGELOG = "1. Update existing modules  and remove libtorrent\\\n2. Fix install for legacy archs\\\n3. Use 64-bit toolchains for bromolow, cedarview and x86"

HOMEPAGE   = http://www.python.org/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
PYTHON_LIB_DIR = lib/python2.7

PLIST_TRANSFORM = sed "s%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%"

POST_STRIP_TARGET = python_cleanup

BUSYBOX_CONFIG = usrmng nice daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: python_cleanup
python_cleanup:
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -fr $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
