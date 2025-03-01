PKG_NAME = OpenBLAS
PKG_VERS = 0.3.29
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenMathLib/OpenBLAS/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.openblas.net/
COMMENT  = OpenBLAS is an optimized BLAS (Basic Linear Algebra Subprograms) library based on GotoBLAS2 1.13 BSD version.
LICENSE  = BSD-3-Clause license

REQUIRED_MIN_DSM = 7.1

include ../../mk/spksrc.cross-cmake.mk
