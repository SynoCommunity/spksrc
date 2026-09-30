PKG_NAME = librsvg-virtual

OPTIONAL_DEPENDS  = cross/librsvg-latest
OPTIONAL_DEPENDS += cross/librsvg-2.40

include ../../mk/spksrc.common.mk

# PowerPC toolchains carry rustc too old for the Rust rewrite
# (overlay 1.82 < 1.92); qoriq is the only PPC arch not otherwise
# excluded, and keeps the frozen C line. The frozen tier carries
# its own arch lists; the latest tier its rustc floor.
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
DEPENDS = cross/librsvg-2.40
else
DEPENDS = cross/librsvg-latest
endif

include ../../mk/spksrc.cross-virtual.mk
