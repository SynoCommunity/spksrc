PKG_NAME = speex
PKG_VERS = 1.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.osuosl.org/pub/xiph/releases/speex
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://speex.org/
COMMENT  = Speex is an Open Source/Free Software patent-free audio compression format designed for speech. The Speex Project aims to lower the barrier of entry for voice applications by providing a free alternative to expensive proprietary speech codecs. Moreover, Speex is well-adapted to Internet applications and provides useful features that are not present in most other codecs. Finally, Speex is part of the GNU Project and is available under the revised BSD license.
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
