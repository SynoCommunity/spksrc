###############################################################################
# spksrc.build/archive.mk
#
# Optional packaging step: tar a subset of a build tree into a hosted archive, so
# an expensive artefact (llvm, the gcc-8.5 overlays, a from-source rustc, ...) is
# built once and then re-consumed via DEPENDS instead of rebuilt from source.
# Generic on purpose -- included by spksrc.native-cc.mk (auto-run after 'install')
# and by spksrc.toolchain/rustc.mk (the Tier-3 rustc archive). Idempotent via a
# status cookie, with an optional debug-symbol strip.
#
# A pure no-op unless the package declares ARCHIVE_NAME; when it does, the
# other variables default so a package usually needs that one line only:
#
#   ARCHIVE_NAME = native-$(PKG_NAME)-$(PKG_VERS)
#
# Targets (standard pre/post pattern, like every other build step):
#   archive_msg
#   pre_archive_target   (override with PRE_ARCHIVE_TARGET)
#   archive_target       (override with ARCHIVE_TARGET; nop disables the step)
#   post_archive_target  (override with POST_ARCHIVE_TARGET)
#   build-archive        create the archive on demand (same result as 'all')
#   print-archive-name   echo the archive filename without building (generators)
#
# Idempotency is a status cookie, WORK_DIR/.$(COOKIE_PREFIX)archive_done, exactly
# like extract/patch/compile/install: the archive is built once per work dir and
# skipped afterwards. Delete that cookie and re-run make to force a rebuild.
#
# Variables:
#   ARCHIVE_NAME               base name, WITHOUT extension -- enables the step
#   ARCHIVE_EXT                extension / compression           (default: txz)
#   ARCHIVE_DIR                tar working dir, tar -C           (default: $(WORK_DIR))
#   ARCHIVE_KEEP               paths to archive, relative to DIR (default: ./install)
#   ARCHIVE_EXCLUDES           tar --exclude args                (default: none)
#   ARCHIVE_STRIP              non-empty to strip debug symbols first
#   ARCHIVE_STRIP_HOST         host strip program                (default: strip)
#   ARCHIVE_STRIP_HOST_DIRS    host-binary dirs, rel to DIR      (default: bin libexec)
#   ARCHIVE_STRIP_TARGET       cross strip for target objects    (optional)
#   ARCHIVE_STRIP_TARGET_DIRS  target-object dirs, rel to DIR    (optional)
#
#   ARCHIVE (computed) = $(ARCHIVE_NAME).$(ARCHIVE_EXT)
###############################################################################

# Compression by extension, mirroring spksrc.build/extract.mk in reverse.
ARCHIVE_EXT ?= txz
TAR_CMD ?= tar
ARCHIVE_CMD.tgz     = $(TAR_CMD) -czpf
ARCHIVE_CMD.txz     = $(TAR_CMD) -cJpf
ARCHIVE_CMD.tar     = $(TAR_CMD) -cpf
ARCHIVE_CMD.tar.gz  = $(TAR_CMD) -czpf
ARCHIVE_CMD.tar.xz  = $(TAR_CMD) -cJpf
ARCHIVE_CMD.tar.bz2 = $(TAR_CMD) -cjpf
ARCHIVE_CMD.tbz     = $(TAR_CMD) -cjpf
ifeq ($(strip $(ARCHIVE_CMD)),)
ARCHIVE_CMD = $(ARCHIVE_CMD.$(ARCHIVE_EXT))
endif

ifeq ($(strip $(PRE_ARCHIVE_TARGET)),)
PRE_ARCHIVE_TARGET = pre_archive_target
else
$(PRE_ARCHIVE_TARGET): archive_msg
endif
ifeq ($(strip $(ARCHIVE_TARGET)),)
ARCHIVE_TARGET = archive_target
else
$(ARCHIVE_TARGET): $(PRE_ARCHIVE_TARGET)
endif
ifeq ($(strip $(POST_ARCHIVE_TARGET)),)
POST_ARCHIVE_TARGET = post_archive_target
else
$(POST_ARCHIVE_TARGET): $(ARCHIVE_TARGET)
endif

.PHONY: archive archive_msg build-archive print-archive-name
.PHONY: $(PRE_ARCHIVE_TARGET) $(ARCHIVE_TARGET) $(POST_ARCHIVE_TARGET)

archive_msg:
	@$(MSG) "Archiving $(NAME)"

pre_archive_target: archive_msg
post_archive_target: $(ARCHIVE_TARGET)

ifeq ($(strip $(ARCHIVE_NAME)),)

# No archive requested: the whole step, and the print helper, are no-ops.
archive: ;
archive_target: ;
build-archive: ;
print-archive-name: ;

else

ARCHIVE                  = $(ARCHIVE_NAME).$(ARCHIVE_EXT)
ARCHIVE_COOKIE           = $(WORK_DIR)/.$(COOKIE_PREFIX)archive_done
ARCHIVE_DIR             ?= $(WORK_DIR)
ARCHIVE_KEEP            ?= ./install
ARCHIVE_STRIP_HOST      ?= strip
ARCHIVE_STRIP_HOST_DIRS ?= bin libexec

print-archive-name:
	@echo $(ARCHIVE)

# The packaging work: an optional debug-symbol strip, then the tar. It lives in
# archive_target so PRE_/POST_ARCHIVE_TARGET wrap it like every other step's hooks,
# and so idempotency is the cookie below -- WORK_DIR/.$(COOKIE_PREFIX)archive_done,
# the same shape as extract/patch/compile/install -- instead of the archive file's
# presence. No pre-build guard, like every other step: it just runs, and the tar
# fails (with a "build it first" note) if there is nothing to archive yet.
# --strip-debug keeps the symbol tables the tools need and only drops the (large)
# debug sections. Target objects need the arch's OWN strip (the host strip cannot
# touch them); host binaries use the host strip.
archive_target: $(PRE_ARCHIVE_TARGET)
	@if [ -n "$(strip $(ARCHIVE_STRIP))" ]; then \
	  $(MSG) "archive: stripping debug symbols -> $(ARCHIVE)" ; \
	  if [ -n "$(strip $(ARCHIVE_STRIP_TARGET))" ] && [ -n "$(strip $(ARCHIVE_STRIP_TARGET_DIRS))" ]; then \
	    find $(addprefix $(ARCHIVE_DIR)/,$(ARCHIVE_STRIP_TARGET_DIRS)) -type f \
	      \( -name '*.a' -o -name '*.o' -o -name '*.so*' \) 2>/dev/null | \
	      while read f; do "$(ARCHIVE_STRIP_TARGET)" --strip-debug "$$f" 2>/dev/null || true ; done ; \
	  fi ; \
	  find $(addprefix $(ARCHIVE_DIR)/,$(ARCHIVE_STRIP_HOST_DIRS)) -type f 2>/dev/null | \
	    while read f; do $(ARCHIVE_STRIP_HOST) --strip-debug "$$f" 2>/dev/null || true ; done ; \
	fi
	@$(MSG) "archive: $(PKG_NAME) -> $(ARCHIVE)"
	@$(ARCHIVE_CMD) $(ARCHIVE) -C $(ARCHIVE_DIR) $(ARCHIVE_EXCLUDES) $(ARCHIVE_KEEP) || \
	  { $(MSG) "$(PKG_NAME): nothing to archive under $(ARCHIVE_DIR)/$(firstword $(ARCHIVE_KEEP)) -- build it first" ; exit 1 ; }

# Cookie-guarded like every other build step: 'archive' runs in the native _all
# pipeline (after install), 'build-archive' is the on-demand entry point for
# generators; both share one cookie, so whichever runs first does the work and the
# other is a no-op. Remove $(ARCHIVE_COOKIE) to force a rebuild.
ifeq ($(wildcard $(ARCHIVE_COOKIE)),)
archive build-archive: $(ARCHIVE_COOKIE)

$(ARCHIVE_COOKIE): $(POST_ARCHIVE_TARGET)
	$(create_target_dir)
	@touch -f $@
else
archive build-archive: ;
endif

endif
