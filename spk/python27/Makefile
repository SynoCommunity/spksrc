
SPK_NAME = Python27
SPK_VERS = 2.7.2
SPK_REV = 1
SPK_ICON = src/python.png

DEPENDS  = cross/python27
DEPENDS += cross/pyopenssl cross/pycrypto cross/pycurl cross/pil cross/cheetah cross/yenc 
DEPENDS += cross/busybox cross/xzdec-static

MAINTAINER = superzebulon@superzebulon.org
COMMENT    = Python Programming Language
ADMIN_PORT = 
RELOAD_UI = yes
DISPLAY_NAME = Python 2.7

HOMEPAGE   = http://www.python.org/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/python27
PYTHON_LIB_DIR = lib/python2.7

PLIST_TRANSFORM = sed "s%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%"

POST_STRIP_TARGET = xz-compress

include ../../mk/spksrc.spk.mk

.PHONY: xz-compress
xz-compress:
	for dir in config distutils idellib lib2to3 lib-tk ; \
	do \
	  rm -rf $(STAGING_DIR)/$(PYTHON_LIB_DIR)/$${dir} ; \
	done
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type d -regex '.*/[Tt]ests?' | xargs rm -fr
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py' | xargs chmod 444
	mv $(STAGING_DIR)/bin/xzdec $(WORK_DIR)/xzdec
	(cd $(STAGING_DIR) && tar cpJf $(WORK_DIR)/package.txz *)
	rm -fr $(STAGING_DIR)
	mkdir $(STAGING_DIR)
	mv $(WORK_DIR)/package.txz $(STAGING_DIR)/
	mkdir $(STAGING_DIR)/sbin
	mv $(WORK_DIR)/xzdec $(STAGING_DIR)/sbin/
	chmod 755 $(STAGING_DIR)/sbin/xzdec
	cp src/passgen.pl $(STAGING_DIR)/sbin/passgen
	chmod 755 $(STAGING_DIR)/sbin/passgen
