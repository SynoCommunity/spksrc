PKG_NAME = z3
PKG_VERS = 4.7.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Z3Prover/z3/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/Z3Prover/z3
COMMENT  = Theorem prover from Microsoft Research.
LICENSE  = MIT

POST_INSTALL_TARGET = z3_post_install

include ../../mk/spksrc.cross-cmake.mk

.PHONY: z3_post_install
z3_post_install:
	@echo "Generating pkg-config file for z3"
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig
	@( \
		echo "prefix=$(STAGING_INSTALL_PREFIX)"; \
		echo "exec_prefix=$(STAGING_INSTALL_PREFIX)"; \
		echo "libdir=\$${exec_prefix}/lib"; \
		echo "sharedlibdir=\$${exec_prefix}/lib"; \
		echo "includedir=\$${prefix}/include"; \
		echo ""; \
		echo "Name: z3"; \
		echo "Description: The Z3 Theorem Prover"; \
		echo "Version: 4.7.1"; \
		echo ""; \
		echo "Requires:"; \
		echo "Libs: -L\$${libdir} -L\$${sharedlibdir} -lz3"; \
		echo "Cflags: -I\$${includedir}"; \
	) > $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/z3.pc
