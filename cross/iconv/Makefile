PKG_NAME = iconv

DEPENDS =

# Take iconv binary provided by the gnu c library (glibc) of the synology toolchain.
COMMENT = Convert encoding of given files from one encoding to another.
HOMEPAGE = http://www.gnu.org/software/libc/bugs.html

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop
INSTALL_TARGET = iconv_install_from_toolchain

include ../../mk/spksrc.install-resources.mk

.PHONY: iconv_install_from_toolchain
iconv_install_from_toolchain:
	@$(MSG) "Install iconv from toolchain"
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@find $(realpath $(TC_PATH)../$(TC_LIBRARY)/..) -type f -name iconv -exec install -m 755 {} $(STAGING_INSTALL_PREFIX)/bin/ \;
