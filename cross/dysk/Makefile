PKG_NAME = dysk-virtual

include ../../mk/spksrc.common.mk

# 3.8.2 needs rustc 1.85; 3.6.1 covers the older Rust 1.82 toolchains.
$(call depend,cross/dysk-latest|cross/dysk-3.6.1)

include ../../mk/spksrc.cross-virtual.mk
