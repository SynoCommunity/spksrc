PKG_NAME = mono
PKG_VERS = 5.20.1.34
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.mono-project.com/sources/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.mono-project.com
COMMENT  = Cross platform, open source .NET development framework.
LICENSE  = https://github.com/mono/mono/blob/master/LICENSE

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-dependency-tracking
# disable-static does not work without disable-libraries
CONFIGURE_ARGS += --disable-static --disable-libraries 
CONFIGURE_ARGS += --without-mcs-docs

POST_INSTALL_TARGET = mono_native_post_install

ENV += PATH=$($(realpath work-native/install)):$${PATH}

include ../../mk/spksrc.native-cc.mk

.PHONY: mono_native_post_install
mono_native_post_install:
	# adjust path in shell scripts
	file $(WORK_DIR)/install/usr/local/bin/* | grep ASCII | cut -d ':' -f1 | xargs sed -i -e 's# /usr/local# /var/packages/mono/target#g'
	# adjust path in config file
	find $(WORK_DIR)/install/usr/local -name monodoc.dll.config | xargs sed -i -e 's#/usr/local#/var/packages/mono/target#g'
