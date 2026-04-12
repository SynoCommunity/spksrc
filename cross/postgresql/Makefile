PKG_NAME = postgresql
PKG_VERS = 17.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.postgresql.org/pub/source/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl3 cross/libxml2 cross/libxslt cross/readline cross/libicu

HOMEPAGE = https://www.postgresql.org
COMMENT  = PostgreSQL is a powerful, open source object-relational database system with over 30 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance

LICENSE  = PostgreSQL Licence

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-template=linux 
CONFIGURE_ARGS += --with-openssl
CONFIGURE_ARGS += --without-python

# PostgreSQL includes its own time zone database, which it requires for date and time operations. 
# This time zone database is in fact compatible with the IANA time zone database provided by many 
# operating systems such as FreeBSD, Linux, and Solaris, so it would be redundant to install it again. 
# When this option is used, the system-supplied time zone database in DIRECTORY is used instead of 
# the one included in the PostgreSQL source distribution. DIRECTORY must be specified as an 
# absolute path. /usr/share/zoneinfo is a likely directory on some operating systems. 
# Note that the installation routine will not detect mismatching or erroneous time zone data. 
# If you use this option, you are advised to run the regression tests to verify that the time 
# zone data you have pointed to works correctly with PostgreSQL.
# 
# This option is mainly aimed at binary package distributors who know their target operating system well. 
# The main advantage of using this option is that the PostgreSQL package won't need to be upgraded whenever 
# any of the many local daylight-saving time rules change. Another advantage is that PostgreSQL can be 
# cross-compiled more straightforwardly if the time zone database files do not need to be built 
# during the installation.
CONFIGURE_ARGS += --with-system-tzdata=/usr/share/zoneinfo

# If you want to invoke the build from another makefile rather than manually,
# you must unset MAKELEVEL or set it to zero.
# see: INSTALL file
ENV += MAKELEVEL=

# Force export-dynamic for backend executable so extensions can resolve symbols
# Cross-compilation configure test assumes 'no' since it can't run test programs
CONFIGURE_ARGS += LDFLAGS_EX_BE="-Wl,--export-dynamic"

include ../../mk/spksrc.cross-cc.mk
