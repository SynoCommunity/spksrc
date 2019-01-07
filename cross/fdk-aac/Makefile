PKG_NAME = fdk-aac
PKG_VERS = 2.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/opencore-amr
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://wiki.hydrogenaud.io/index.php?title=Fraunhofer_FDK_AAC
COMMENT  = The Fraunhofer FDK AAC is a high-quality open-source AAC encoder library developed by Fraunhofer IIS.
LICENSE  = FDK License & Apache 2: http://wiki.hydrogenaud.io/index.php?title=Fraunhofer_FDK_AAC#FDK_License

PRE_CONFIGURE_TARGET = fdk-aac_configure

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: fdk-aac_configure
fdk-aac_configure:
	$(RUN) ./autogen.sh
