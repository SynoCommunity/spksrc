PKG_NAME = libe_sqlite3
PKG_VERS = 2.1.10

# dotnet core supported archs only:
DOTNET_CORE_ARCHS = 1

HOMEPAGE = https://github.com/ericsink/cb/
COMMENT  = Makefile to build libe_sqlite3.so from sources in https://github.com/ericsink/cb/tree/master/sqlite3 and https://github.com/ericsink/cb/tree/master/stup
LICENSE  = Apache 2.0

# libe_sqlite3.so is the native library for linux provided by SQLitePCLRaw nuget package.
# Since the (cross) toolchains used for creation in https://github.com/ericsink/cb provide newer libc versions, 
# these libraries depend on GLIBC 2.28.
# Such toolchains are used since SQLitePCLRaw 2.0.5.
# 
# As .NET 8 and .NET 9 do not have such restrictions and run well on DSM 7.1.1 with GLIBC 2.26
# and on DSM 6.2.4 with GLIBC 2.20, we create libe_sqlite3.so here with the toolchains from 
# Synology for compatibility with DSM.


# history of source files in https://github.com/ericsink/cb
# Date         Version   Commit Hash   Commit Message
# 11.09.2024   2.1.10    b3ad80b       update sqlite3 and sqlite3mc to 3.46.1

DOWNLOAD_TARGET = libe_sqlite3_download
CHECKSUM_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = libe_sqlite3_compile
INSTALL_TARGET = libe_sqlite3_install

# In original build system, the flags (and toolchains) are defined in blb/cb.cs
ADDITIONAL_CFLAGS = -shared -fPIC -O
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_COLUMN_METADATA
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_FTS3_PARENTHESIS
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_FTS4
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_FTS5
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_JSON1
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_MATH_FUNCTIONS
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_RTREE
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_SNAPSHOT
ADDITIONAL_CFLAGS += -DSQLITE_DEFAULT_FOREIGN_KEYS=1
ADDITIONAL_CFLAGS += -DSQLITE_OS_UNIX
ADDITIONAL_CFLAGS += -DNDEBUG
ADDITIONAL_CFLAGS += -o libe_sqlite3.so

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
ADDITIONAL_CFLAGS += -m64 -msse4.2 -maes
endif

.PHONY: libe_sqlite3_download
libe_sqlite3_download:
	@$(MSG) "install sources into work folder"
	@tar -cf - -C source . | tar -xf - -C $(WORK_DIR)/

.PHONY: libe_sqlite3_compile
libe_sqlite3_compile:
	@$(MSG) "compile libe_sqlite3"
	@cd $(WORK_DIR) ; $(ENV) ; $${CC} $${CFLAGS} sqlite3/sqlite3.c  stubs/stubs.c

.PHONY: libe_sqlite3_install
libe_sqlite3_install:
	@$(MSG) "install libe_sqlite3"
	@install -d $(STAGING_INSTALL_PREFIX)/lib/
	@install -m 744 $(WORK_DIR)/libe_sqlite3.so $(STAGING_INSTALL_PREFIX)/lib/
