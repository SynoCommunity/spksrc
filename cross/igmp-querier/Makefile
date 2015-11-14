PKG_NAME = igmp-querier
PKG_FULL_NAME = IGMP Querier
PKG_DOWNLOAD_METHOD = git
PKG_EXT = tar.gz
PKG_GIT_HASH = 85a4711
PKG_DIST_SITE = https://github.com/dlorch/$(PKG_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/libnet

HOMEPAGE = https://github.com/dlorch/igmp-querier/
COMMENT  = Fixes a problem with Apple AirPlay / Bonjour devices not showing up on the local network (or showing up and then disappearing after a while) due to faulty IGMP snooping implementations on home routers. This is a frequently reported problem with AV receivers (e.g. from Denon, Yamaha, Pioneer) in conjuction with AirPlay.
LICENSE  = BSD

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
