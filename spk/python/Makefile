SPK_NAME = python
SPK_VERS = 2.7.3
SPK_REV = 3
SPK_ICON = src/python.png
BETA = 1

DEPENDS  = cross/busybox cross/$(SPK_NAME)
DEPENDS += cross/distribute cross/distutils2 cross/pip cross/virtualenv cross/pyopenssl
DEPENDS += cross/pycrypto cross/pycurl cross/pil cross/cheetah cross/yenc
DEPENDS += cross/sqlalchemy cross/pyaudio cross/pyalsa cross/lxml cross/twisted
DEPENDS += cross/zope.interface cross/markupsafe
# Add libtorrent for ARCHs that support it
ifneq ($(findstring $(ARCH),88f5281 powerpc ppc824x ppc853x ppc854x),$(ARCH))
DEPENDS += cross/libtorrent
endif

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language. This package is not startable, it is just required by other packages as dependency.
DESCRIPTION_FRE = Langage de programmation Python. Ce paquet ne se lance pas, il est juste requis en tant que dépendance par d\\\'autres paquets.
DESCRIPTION_SPN = Lenguaje de programación Python. Este paquente no se inicia, solo es requerido como dependecia de otros paquetes.
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Python
CHANGELOG = "1. Update existing modules\\\n2. Add modules distutils2, Twisted, zope.interface and MarkupSafe\\\n3. Replace setuptools with distribute\\\n4. Add libtorrent for some architectures\\\n5. Enable unicode usc4\\\n6. Make the SPK not startable"

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
	rm $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
