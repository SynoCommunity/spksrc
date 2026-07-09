###############################################################################
# spksrc.build.mk
#
# Standard build pipeline shared by the cross- and native-compilation entry
# points (spksrc.cross-cc.mk and spksrc.native-cc.mk). Chains the per-step
# spksrc.build/*.mk files in canonical order, from download through install.
#
# Pipeline order:
#   download -> checksum -> extract -> patch -> configure -> compile -> install
#
# Prerequisites provided by the including entry point:
#   - depend  (spksrc.rules/depend.mk)   referenced by the extract step
#   - status  (spksrc.rules/status.mk)   referenced by the extract step
#   - the build environment (spksrc.cross/env-default.mk or
#     spksrc.native/env-default.mk) included before this file
#
# Notes:
#   - plist is intentionally NOT part of this shared pipeline: native build-host
#     tools are not packaged, so spksrc.native-cc.mk has no plist step (it uses a
#     cat_PLIST stub). The packaged entry points that need it (spksrc.cross-cc.mk,
#     spksrc.kernel.mk, spksrc.cross-virtual.mk) include spksrc.build/plist.mk
#     themselves, so plist stays under spksrc.build/ as a build-pipeline step.
###############################################################################

include ../../mk/spksrc.build/download.mk

checksum: download
include ../../mk/spksrc.build/checksum.mk

extract: checksum depend status
include ../../mk/spksrc.build/extract.mk

patch: extract
include ../../mk/spksrc.build/patch.mk

configure: patch
include ../../mk/spksrc.build/configure.mk

compile: configure
include ../../mk/spksrc.build/compile.mk

install: compile
include ../../mk/spksrc.build/install.mk
