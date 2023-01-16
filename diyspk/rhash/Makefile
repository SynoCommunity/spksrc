SPK_NAME = rhash
SPK_VERS = 1.4.3
SPK_REV = 2

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Fredrike
DESCRIPTION = "RHash is a console utility for calculation and verification of magnet links and a wide range of hash sums like CRC32, MD4, MD5, SHA1, SHA256, SHA512, SHA3, AICH, ED2K, Tiger, DC++ TTH, BitTorrent BTIH, GOST R 34.11-94, RIPEMD-160, HAS-160, EDON-R, Whirlpool and Snefru."
DISPLAY_NAME = RHash
STARTABLE = no

POST_STRIP_TARGET = rhash_extra_install

HOMEPAGE   = http://rhash.sourceforge.net/
LICENSE    = MIT

SPK_COMMANDS  = bin/rhash
SPK_COMMANDS += bin/ed2k-link
SPK_COMMANDS += bin/edonr256-hash
SPK_COMMANDS += bin/edonr512-hash
SPK_COMMANDS += bin/gost12-256-hash
SPK_COMMANDS += bin/gost12-512-hash
SPK_COMMANDS += bin/has160-hash
SPK_COMMANDS += bin/magnet-link
SPK_COMMANDS += bin/sfv-hash
SPK_COMMANDS += bin/tiger-hash
SPK_COMMANDS += bin/tth-hash
SPK_COMMANDS += bin/whirlpool-hash

include ../../mk/spksrc.spk.mk

.PHONY: rhash_extra_install
rhash_extra_install:
	@$(MSG) "Set library runpath in rhash executable."
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/rhash
