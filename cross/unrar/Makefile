PKG_NAME = unrar-virtual

include ../../mk/spksrc.common.mk

# unrar 7 where its floors admit the arch (gcc 5), unrar 6.2 otherwise.
$(call depend,cross/unrar-latest|cross/unrar-6.2)

include ../../mk/spksrc.cross-virtual.mk
