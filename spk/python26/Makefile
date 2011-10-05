
SPK_NAME = python26
SPK_VERS = 2.6.6
SPK_REV = 5
SPK_ICON = src/python.png

DEPENDS = cross/$(SPK_NAME) cross/xzdec-static

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://www.python.org/
COMMENT    = Python Programming Language
LICENSE    =
ADMIN_PORT = 
RELOAD_UI = yes

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = xz-compress

include ../../mk/spksrc.spk.mk

.PHONY: xz-compress
xz-compress:
	for dir in config distutils idellib lib2to3 lib-tk ; \
	do \
	  rm -rf $(STAGING_DIR)/lib/python2.6/$${dir} ; \
	done
	find $(STAGING_DIR)/lib/python2.6 -type d -regex '.*/[Tt]ests?' | xargs rm -fr
	find $(STAGING_DIR)/lib/python2.6 -type f -regex '.*\.py[co]' | xargs rm -f
	find $(STAGING_DIR)/lib/python2.6 -type f -regex '.*\.py' | xargs chmod 444
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
