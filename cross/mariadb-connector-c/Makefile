PKG_NAME = mariadb-connector-c-main

OPTIONAL_DEPENDS  = cross/mariadb-connector-c-latest
OPTIONAL_DEPENDS += cross/mariadb-connector-c-3.3.11

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, ${TC_GCC}, 5),1)
DEPENDS = cross/mariadb-connector-c-latest
else
DEPENDS = cross/mariadb-connector-c-3.3.11
endif
