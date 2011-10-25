
SPK_NAME = Headphones
SPK_VERS = 3.1
SPK_REV = 1
SPK_ICON = src/headphone.png

DEPENDS  = 

MAINTAINER = superzebulon@superzebulon.org
COMMENT    = "Automatic music downloader for SABnzbd."
ADMIN_PORT = 8181
RELOAD_UI = yes
DISPLAY_NAME = ${SPK_NAME}

HOMEPAGE   = https://github.com/rembo10/headphones
LICENSE    = ?

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS = 

PYTHON_VERS = 26
SPK_DEPENDS = "Python${PYTHON_VERS}>=2.6.6-5"

INSTALL_PREFIX = /usr/local/headphones

COPY_TARGET = nop
POST_STRIP_TARGET = xz-compress

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: xz-compress
xz-compress:
	@$(MSG) "Adding files for DSM integration"
	install -m 755 -d $(STAGING_DIR)/sbin
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/synoman
	install -m 755 src/updateInfo.py $(STAGING_DIR)/sbin/updateInfo
	install -m 644 src/config.json $(STAGING_DIR)/share/synoman/config
	install -m 755 src/headphones.cgi.py $(STAGING_DIR)/share/synoman/headphones.cgi
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} -transparent white \
	            $(STAGING_DIR)/share/synoman/headphones-$${size}.png ; \
	done
	@$(MSG) "Compressing with xz"
	(cd $(STAGING_DIR) && tar cpJf $(WORK_DIR)/package.txz --group=root --owner=root *)
	rm -fr $(STAGING_DIR)
	mkdir $(STAGING_DIR)
	mv $(WORK_DIR)/package.txz $(STAGING_DIR)/
