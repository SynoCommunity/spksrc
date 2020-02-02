SPK_NAME = rhash
SPK_VERS = 1.3.8
SPK_REV = 1

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Fredrike
DESCRIPTION = "RHash is a console utility for calculation and verification of magnet links and a wide range of hash sums like CRC32, MD4, MD5, SHA1, SHA256, SHA512, SHA3, AICH, ED2K, Tiger, DC++ TTH, BitTorrent BTIH, GOST R 34.11-94, RIPEMD-160, HAS-160, EDON-R, Whirlpool and Snefru."
RELOAD_UI = no
DISPLAY_NAME = rhash
STARTABLE = no

HOMEPAGE   = http://rhash.sourceforge.net/
LICENSE    = MIT

SPK_COMMANDS = bin/rhash
SPK_LINKS  = /usr/local/bin/ed2k-link:bin/rhash 
SPK_LINKS += /usr/local/bin/edonr256-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/edonr512-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/gost-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/has160-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/magnet-link:bin/rhash 
SPK_LINKS += /usr/local/bin/sfv-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/tiger-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/tth-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/whirlpool-hash:bin/rhash 

include ../../mk/spksrc.spk.mk
